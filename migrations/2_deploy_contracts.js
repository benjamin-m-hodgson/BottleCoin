var BottleCoin = artifacts.require("./BottleCoin.sol");

module.exports = function(deployer) {
  deployer.deploy(BottleCoin);
};
