const { balance, BN, constants, expectEvent, expectRevert } = require('@openzeppelin/test-helpers');
const { ZERO_ADDRESS } = constants;

const { compressABI /* decompressABI */ } = require('./utils/contract');

const { expect } = require('chai');

const BC1StorageHelper = artifacts.require('BC1StorageHelper');

const DeCashStorage = artifacts.require('DeCashStorage');
const DeCashUpgrade = artifacts.require('DeCashUpgrade');
const DeCashRole = artifacts.require('DeCashRole');
const DeCashToken = artifacts.require('DeCashToken');
const DeCashProxy = artifacts.require('DeCashProxy');

const contracts = {
  upgrade: DeCashUpgrade,
  role: DeCashRole,
  token: DeCashToken,
  proxy: DeCashProxy,
};

contract('BC1 Tests', function ([owner, admin, other, thirdParty, delegate, feeRecipient]) {
  const _name = 'DeCash EURD';
  const _symbol = 'EURD';
  const _decimals = new BN(2);

  const SIG_STANDARD_PERSONAL = 1;

  context('testing network behaviours', function () {
    beforeEach(async function () {
      this.instances = [];

      this.storage = await DeCashStorage.new({ from: owner });
      this.storageHelper = await BC1StorageHelper.new(this.storage.address, { from: owner });

      for (const key in contracts) {
        this.instances[key] = await contracts[key].new(this.storage.address, { from: owner });

        await this.storage.setBool(
          web3.utils.soliditySha3('contract.exists', this.instances[key].address),
          true,
          { from: owner },
        );

        await this.storage.setString(
          web3.utils.soliditySha3('contract.name', this.instances[key].address),
          key,
          { from: owner },
        );

        await this.storage.setAddress(
          web3.utils.soliditySha3('contract.address', key),
          this.instances[key].address,
          { from: owner },
        );

        await this.storage.setString(
          web3.utils.soliditySha3('contract.abi', key),
          compressABI(this.instances[key].abi),
          { from: owner },
        );
      }

      await this.instances.role.addRole('admin', admin, { from: owner });

      await this.instances.proxy.initialize(this.instances.token.address, { from: owner });

      this.token = await DeCashToken.at(this.instances.proxy.address);
    });

    context('before token initialization', function () {
      describe('check storage', function () {
        it('should have 0 as current version', async function () {
          (await this.storageHelper.getTokenVersionByName(_name)).should.be.bignumber.equal(new BN(0));
        });
      });
    });

    context('after token initialization', function () {
      beforeEach(async function () {
        await this.token.initialize(_name, _symbol, _decimals, { from: owner });

        await this.storage.setBool(web3.utils.soliditySha3('contract.storage.initialised'), true, { from: owner });
      });

      describe('check storage', function () {
        it('should have 1 as current version', async function () {
          (await this.storageHelper.getTokenVersionByName(_name)).should.be.bignumber.equal(new BN(1));
        });
      });

      context('check delegatecall view', function () {
        it('has a name', async function () {
          (await this.token.name()).should.be.equal(_name);
        });

        it('has a symbol', async function () {
          (await this.token.symbol()).should.be.equal(_symbol);
        });

        it('has an amount of decimals', async function () {
          (await this.token.decimals()).should.be.bignumber.equal(_decimals);
        });
      });

      context('check multisignature', function () {
        const initialSupply = new BN(0);
        const amount = new BN(50);

        describe('with 1 required signature', function () {
          describe('owner can mint', function () {
            beforeEach('minting', async function () {
              this.receipt = await this.token.mint(thirdParty, amount, { from: owner });
            });

            it('increments totalSupply', async function () {
              const expectedSupply = initialSupply.add(amount);
              (await this.token.totalSupply()).should.be.bignumber.equal(expectedSupply);
            });

            it('increments thirdParty balance', async function () {
              (await this.token.balanceOf(thirdParty)).should.be.bignumber.equal(amount);
            });

            it('emits Transfer event', async function () {
              const event = expectEvent(this.receipt, 'Transfer', {
                from: ZERO_ADDRESS,
                to: thirdParty,
              });

              event.args.value.should.be.bignumber.equal(amount);
            });
          });
        });

        describe('with 2 required signature', function () {
          beforeEach(async function () {
            await this.token.changeRequiredSigners(new BN(2), { from: owner });
          });

          describe('when the first user calls', function () {
            beforeEach('minting', async function () {
              this.receipt = await this.token.mint(thirdParty, amount, { from: owner });
            });

            it('emit OperationUpvoted event but not OperationPerformed', async function () {
              expectEvent(this.receipt, 'OperationUpvoted', {
                voter: owner,
              });

              expectEvent.notEmitted(this.receipt, 'OperationPerformed');
            });

            it('doesn\'t increment totalSupply', async function () {
              (await this.token.totalSupply()).should.be.bignumber.equal(initialSupply);
            });

            describe('when the second user calls', function () {
              beforeEach('minting', async function () {
                this.receipt = await this.token.mint(thirdParty, amount, { from: admin });
              });

              it('emit OperationUpvoted event and OperationPerformed event', async function () {
                expectEvent(this.receipt, 'OperationUpvoted', {
                  voter: admin,
                });

                expectEvent(this.receipt, 'OperationPerformed', {
                  performer: admin,
                });
              });

              it('increments totalSupply', async function () {
                const expectedSupply = initialSupply.add(amount);
                (await this.token.totalSupply()).should.be.bignumber.equal(expectedSupply);
              });
            });
          });
        });
      });

      context('check signed token transfer', () => {
        const amount = new BN(1000);

        const from = thirdParty;
        const to = other;

        const usedSigId = 1;

        beforeEach(async function () {
          await this.instances.role.addRole('delegator', delegate, { from: owner });
          await this.instances.role.addRole('fee', feeRecipient, { from: owner });

          await this.token.mint(thirdParty, amount, { from: owner });
        });

        it('success using personal sign standard', async function () {
          const balanceTracker = await balance.tracker(from);

          const fee = new BN(1);
          const value = amount.sub(fee);
          const deadline = (await web3.eth.getBlock('latest')).timestamp + 60 * 60 * 24 * 7; // +7 days
          const dataToSign = web3.utils.soliditySha3(
            this.token.address, from, to, value, fee, feeRecipient, deadline, usedSigId,
          );
          const signature = await web3.eth.sign(dataToSign, from);

          const receipt = await this.token.transferViaSignature(
            from,
            to,
            value,
            fee,
            feeRecipient,
            deadline,
            usedSigId,
            signature,
            SIG_STANDARD_PERSONAL,
            { from: delegate },
          );

          const transferEvent = expectEvent(receipt, 'Transfer', {
            from: from,
            to: to,
          });

          transferEvent.args.value.should.be.bignumber.equal(value);

          const feeEvent = expectEvent(receipt, 'Transfer', {
            from: from,
            to: feeRecipient,
          });

          feeEvent.args.value.should.be.bignumber.equal(fee);

          expect(await balanceTracker.delta()).to.be.bignumber.equal(new BN(0));

          expect(await this.token.balanceOf(from)).to.be.bignumber.equal(amount.sub(value).sub(fee));
          expect(await this.token.balanceOf(to)).to.be.bignumber.equal(value);
          expect(await this.token.balanceOf(feeRecipient)).to.be.bignumber.equal(fee);
        });

        it('success using personal sign standard with zero fee', async function () {
          const balanceTracker = await balance.tracker(from);

          const fee = new BN(0);
          const value = amount.sub(fee);
          const deadline = (await web3.eth.getBlock('latest')).timestamp + 60 * 60 * 24 * 7; // +7 days
          const dataToSign = web3.utils.soliditySha3(
            this.token.address, from, to, value, fee, feeRecipient, deadline, usedSigId,
          );
          const signature = await web3.eth.sign(dataToSign, from);

          const receipt = await this.token.transferViaSignature(
            from,
            to,
            value,
            fee,
            feeRecipient,
            deadline,
            usedSigId,
            signature,
            SIG_STANDARD_PERSONAL,
            { from: delegate },
          );

          const transferEvent = expectEvent(receipt, 'Transfer', {
            from: from,
            to: to,
          });

          transferEvent.args.value.should.be.bignumber.equal(value);

          expect(await balanceTracker.delta()).to.be.bignumber.equal(amount.sub(value));

          expect(await this.token.balanceOf(from)).to.be.bignumber.equal(amount.sub(value).sub(fee));
          expect(await this.token.balanceOf(to)).to.be.bignumber.equal(value);
          expect(await this.token.balanceOf(feeRecipient)).to.be.bignumber.equal(fee);
        });

        it('revert with signature with expired deadline', async function () {
          const fee = new BN(1);
          const value = amount.sub(fee);
          const deadline = (await web3.eth.getBlock('latest')).timestamp - 60 * 60; // 1 hour ago
          const dataToSign = web3.utils.soliditySha3(
            this.token.address, from, to, value, fee, feeRecipient, deadline, usedSigId,
          );
          const signature = await web3.eth.sign(dataToSign, from);

          await expectRevert(
            this.token.transferViaSignature(
              from,
              to,
              value,
              fee,
              feeRecipient,
              deadline,
              usedSigId,
              signature,
              SIG_STANDARD_PERSONAL,
              { from: delegate },
            ),
            'Request expired',
          );
        });

        it('revert if re-use signature', async function () {
          const fee = new BN(0);
          const value = amount.sub(fee);
          const deadline = (await web3.eth.getBlock('latest')).timestamp + 60 * 60 * 24 * 7; // +7 days
          const dataToSign = web3.utils.soliditySha3(
            this.token.address, from, to, value, fee, feeRecipient, deadline, usedSigId,
          );
          const signature = await web3.eth.sign(dataToSign, from);

          await this.token.transferViaSignature(
            from,
            to,
            value,
            fee,
            feeRecipient,
            deadline,
            usedSigId,
            signature,
            SIG_STANDARD_PERSONAL,
            { from: delegate },
          );

          await expectRevert(
            this.token.transferViaSignature(
              from,
              to,
              value,
              fee,
              feeRecipient,
              deadline,
              usedSigId,
              signature,
              SIG_STANDARD_PERSONAL,
              { from: delegate },
            ),
            'Request already used',
          );
        });
      });

      context('estimate gas for transferMany', function () {
        beforeEach(async function () {
          const amount = new BN(5000);

          await this.token.mint(thirdParty, amount, { from: owner });

          this.dataSet = {
            tos: [],
            values: [],
          };

          while (this.dataSet.values.length < 100) {
            const to = web3.eth.accounts.create();
            this.dataSet.tos.push(to.address);
            this.dataSet.values.push(1);
          }
        });

        describe('with less than 100 receivers', function () {
          it('gas should remain under 8M', async function () {
            expect(
              await this.token.transferMany.estimateGas(
                this.dataSet.tos,
                this.dataSet.values,
                { from: thirdParty },
              ),
            ).to.be.lte(8000000);
          });
        });
      });
    });

    context('testing proxy upgrade', function () {
      beforeEach(async function () {
        await this.token.initialize(_name, _symbol, _decimals, { from: owner });

        await this.storage.setBool(web3.utils.soliditySha3('contract.storage.initialised'), true, { from: owner });
      });

      describe('try to reinitialize the proxy', function () {
        it('fail', async function () {
          this.newContract = await DeCashToken.new(this.storage.address, { from: owner });

          await expectRevert(
            this.instances.proxy.initialize(this.newContract.address, { from: owner }),
            'Proxy already initialized',
          );
        });
      });

      describe('trying to upgrade proxy from owner', function () {
        it('revert', async function () {
          this.newContract = await DeCashToken.new(this.storage.address, { from: owner });
          await expectRevert(
            this.instances.proxy.upgrade(this.newContract.address, { from: owner }),
            'Invalid or outdated contract',
          );
        });
      });
    });

    context('testing storage upgrade', function () {
      describe('upgrade contract (testing DeCashRole)', function () {
        it('should success', async function () {
          (await this.storageHelper.getContractAddressByName('role')).should.be.equal(this.instances.role.address);
          (await this.storageHelper.hasRole(thirdParty, 'admin')).should.be.equal(false);

          this.newContract = await DeCashRole.new(this.storage.address, { from: owner });

          const receipt = await this.instances.upgrade.upgradeContract(
            'role',
            this.newContract.address,
            compressABI(this.newContract.abi),
            { from: owner },
          );

          expectEvent(receipt, 'ContractUpgraded', {
            name: await this.storageHelper.getHash('role'),
            oldAddress: this.instances.role.address,
            newAddress: this.newContract.address,
          });

          (await this.storageHelper.getContractAddressByName('role')).should.be.equal(this.newContract.address);

          await expectRevert(
            this.instances.role.addRole('admin', thirdParty, { from: owner }),
            'Invalid or outdated contract',
          );

          await this.newContract.addRole('admin', thirdParty, { from: owner });

          (await this.storageHelper.hasRole(thirdParty, 'admin')).should.be.equal(true);
        });
      });

      describe('Upgrade contract (testing DeCashToken)', function () {
        it('should success', async function () {
          (await this.storageHelper.getContractAddressByName('token')).should.be.equal(this.instances.token.address);
          (await this.storageHelper.getContractAddressByName('proxy')).should.be.equal(this.instances.proxy.address);

          this.newContract = await DeCashToken.new(this.storage.address, { from: owner });

          const receipt = await this.instances.upgrade.upgradeContract(
            'token',
            this.newContract.address,
            compressABI(this.newContract.abi),
            { from: owner },
          );

          expectEvent(receipt, 'ContractUpgraded', {
            name: await this.storageHelper.getHash('token'),
            oldAddress: this.instances.token.address,
            newAddress: this.newContract.address,
          });

          (await this.storageHelper.getContractAddressByName('token')).should.be.equal(this.newContract.address);
        });
      });
    });
  });
});
