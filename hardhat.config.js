require('@nomiclabs/hardhat-ganache');
require('@nomiclabs/hardhat-truffle5');

require('chai/register-should');

module.exports = {
  defaultNetwork: 'hardhat',
  solidity: {
    version: '0.7.6',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};
