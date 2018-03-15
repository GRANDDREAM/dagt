const SafeMath = artifacts.require('./SafeMath.sol');
const Ownable = artifacts.require('./Ownable.sol');

// var DagtPri = artifacts.require("DagtPri.sol");
var Dagt = artifacts.require("Dagt.sol");
module.exports = function(deployer) {
  
  deployer.deploy(SafeMath);
  deployer.deploy(Ownable);

  deployer.link(Ownable,Dagt);
  deployer.link(SafeMath,Dagt);
  
  deployer.deploy(Dagt);
  
};
