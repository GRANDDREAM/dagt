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
  function transfer(address _to, uint256 _value) public returns (bool) {
      return super.transfer(_to, _value);
    }

  function transferFrom(address _from, address _to, uint256 _value) public onlyMintingFinished returns (bool) {
      return super.transferFrom(_from, _to, _value);
    }

  function mint(address _to, uint256 _amount)  public returns (bool)
  {
    return super.mint(_to, _amount);
  }

  function getDAGTRate() returns (uint256 rate ,uint blocktime,uint256 blocknum) {
    //uint256  timeRate1_1 = 1521129600;// ToTimestamp(2018, 3, 16, 0, 0, 0);
    //uint256  timeRate1_2 = 1521993599;// ToTimestamp(2018, 3, 25, 23, 59, 59);
  //  require(timeRate1_1 >= initTimeStamp);
    //transfer(msg.sender, 0);
    //uint256 startNumbers_1 = (1521129600-initTimeStamp)/15;
    //uint256 endNumbers_1 =(1521993599-initTimeStamp)/15;

    //2018.3.26~2018.4.4
    //  uint256  timeRate2_1 = 1521993600;
   //  uint256  timeRate2_2 = 1522771199;
    //uint256 startNumbers_2 = (1521993600-initTimeStamp)/15;
    //uint256 endNumbers_2 =(1522771199-initTimeStamp)/15;

    //2018.4.5~2018.4.14
    //uint256  timeRate3_1 = 1522857600;
   //  uint256  timeRate3_2 = 1523635199;

    //uint256 startNumbers_3 = (1522857600-initTimeStamp)/15;
    //uint256 endNumbers_3 =(1523635199-initTimeStamp)/15;

    //2018.4.15~2018.4.24
    //uint256  timeRate4_1 = 1523721600;
    //uint256  timeRate4_2 = 1524499199;
    //uint256 startNumbers_4 = (1523721600-initTimeStamp)/15;
    //uint256 endNumbers_4 =(1524499199-initTimeStamp)/15;

    //2018.4.26—2018.4.30
    //uint256  timeRate5_1 = 1524672000;
    //uint256  timeRate5_2 = 1525017599;

  //  uint256 startNumbers_5 = (1524672000-initTimeStamp)/15;
    //uint256 endNumbers_5 =(1525017599-initTimeStamp)/15;
    rate = 0;
  /* */
    /*if((block.number>=startNumbers_1) && (block.number<=endNumbers_1) )
    {
        rate = RATE1;
    }else if((block.number>=startNumbers_2) && (block.number<=endNumbers_2))
    {
        rate = RATE2;*/
    if((now>=1521129600) && (now<=1521993599) )
     {
       rate = RATE1;
     }else if((now>=1521993600) && (now<=1522771199) )
    {
        rate = RATE2;
    }else if((now>=1522857600) && (now<=1523635199) )
    {
      rate = RATE3;
    }else if((now>=1523721600) && (now<=1524499199) )
    {
      rate = RATE4;
    }else if((now>=1524672000) && (now<=1525017599) )
    {
      rate = RATE5;
    }else
    {
    //  throw;
    }
    blocktime = block.timestamp;
    blocknum = block.number;
    //return rate;
  }
}
