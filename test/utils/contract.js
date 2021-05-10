const pako = require('pako');

function compressABI (abi) {
  return Buffer.from(pako.deflate(JSON.stringify(abi))).toString('base64');
}

function decompressABI (abi) {
  return JSON.parse(pako.inflate(Buffer.from(abi, 'base64'), { to: 'string' }));
}

module.exports = {
  compressABI,
  decompressABI,
};
