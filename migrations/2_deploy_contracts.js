var DAGT = artifacts.require("Dagt");
var DagtCrowdSale = artifacts.require("DagtCrowdSale");


module.exports = function(deployer) {
  deployer.deploy(DAGT);
  deployer.deploy(DagtCrowdSale);
};