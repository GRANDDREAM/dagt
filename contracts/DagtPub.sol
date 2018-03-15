pragma solidity ^0.4.17;


import "./Dagt.sol";


contract DagtPub is Dagt {

function DagtPub() public {

    INITIAL_SUPPLY = 20000000;
    RATE1 =  1400;
    RATE2 =  1310;
    RATE3 =  1240;
    RATE4 =  1180;
    RATE5 =  1118;
    totalSupply_ = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
}



/*
function test() returns (string block0) {

  return  GetBlock(0);
}*/
function approve(address _spender, uint256 _value) public onlyMintingFinished returns (bool) {
      return super.approve(_spender, _value);
  }

  /*function transfer(address _to, uint256 _value) public onlyMintingFinished returns (bool) {
    return super.transfer(_to, _value);
}*/
//不需要挖矿
function transfer(address _to, uint256 _value) public returns (bool) {
  return super.transfer(_to, _value);
}

function transferFrom(address _from, address _to, uint256 _value) public onlyMintingFinished returns (bool) {
  return super.transferFrom(_from, _to, _value);
}



}
