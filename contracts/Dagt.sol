pragma solidity ^0.4.4;

import './BaseDagt.sol';
//import './SafeMath.sol';


contract Dagt is MintableToken, BaseDagt{

  using SafeMath for uint256;

  /*string public name = "DAGT Token";

  string public symbol = "DAGT";

  uint8   public decimals = 8;
  uint    public INITIAL_SUPPLY = 20000000;
  uint256  public initTimeStamp;

//  uint256 public constant RATE1 =  1400;
  uint256 public  RATE1 =  1400;
  uint256 public  RATE2 =  1310;
  uint256 public  RATE3 =  1240;
  uint256 public  RATE4 =  1180;
  uint256 public  RATE5 =  1118;*/
  // new rates


    // Cap per tier for bonus in wei.
    //uint256 public constant TIER1 =  10000000000000000000000;
    //uint256 public constant TIER2 =  25000000000000000000000;
    //uint256 public constant TIER3 =  50000000000000000000000;


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
  function transfer(address _to, uint256 _value) public  onlyWhitelisted  returns (bool) {
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
