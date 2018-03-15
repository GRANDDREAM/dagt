var DagtPri = artifacts.require("DagtPri.sol");
var Dagt = artifacts.require("Dagt.sol");
module.exports = function(deployer) {
  deployer.deploy(Dagt);
  deployer.link(Dagt,DagtPri);
  deployer.deploy(DagtPri);
  
};
