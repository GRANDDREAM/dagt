pragma solidity ^0.4.4;

import './BaseDagt.sol';
//import './SafeMath.sol';


contract Dagt is MintableToken, BaseDagt{

  using SafeMath for uint256;


  function Dagt() {

  }

  modifier onlyMintingFinished() {
  require(mintingFinished == true);
  _;
}

  function approve(address _spender, uint256 _value) public onlyMintingFinished returns (bool) {
        return super.approve(_spender, _value);
    }

    //不需要挖矿
  function transfer(address _to, uint256 _value) public   returns (bool) {
      return super.transfer(_to, _value);
    }

  function transferFrom(address _from, address _to, uint256 _value) public onlyMintingFinished returns (bool) {
      return super.transferFrom(_from, _to, _value);
    }

  function mint(address _to, uint256 _amount)  public onlyWhitelisted returns (bool)
  {
    return super.mint(_to, _amount);
  }

}
