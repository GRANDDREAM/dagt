var DAGT = artifacts.require("Dagt");
var DagtCrowdSale = artifacts.require("DagtCrowdSale");


module.exports = function(deployer) {
  deployer.deploy(DAGT);
  deployer.deploy(DagtCrowdSale,2845788, 4845788, 2845788, 4845788, 20000000000000000000000000, 20000000000000000000000000,  100000000000000000000000000, 0x627306090abaB3A6e1400e9345bC60c78a8BEf57);
};