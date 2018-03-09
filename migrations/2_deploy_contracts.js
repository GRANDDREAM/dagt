var DagtPri = artifacts.require("DagtPri.sol");
var DagtPub = artifacts.require("DagtPub.sol");
module.exports = function(deployer) {
  deployer.deploy(DagtPri);
  deployer.deploy(DagtPub);
};
