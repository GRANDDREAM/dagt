pragma solidity ^0.4.17;

import 'zeppelin-solidity/contracts/token/ERC20/MintableToken.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';


contract DagtPri is MintableToken {

using SafeMath for uint256;

string public name = "DAGT Token";

string public symbol = "DAGT";

uint8 public decimals = 8;

uint public INITIAL_SUPPLY = 100000000;
uint public LOCK_NUMS_SUPPLY = 20000000;
bool private LockinMonth0=false;
bool private LockinMonth1=false;
bool private LockinMonth2=false;
bool private LockinMonth3=false;
bool private LockinMonth4=false;
uint256 mintedNums;
// new rates
uint256 public constant RATE1 =  1700;
uint256 public constant RATE2 =  1600;
uint256 public constant RATE3 =  1400;
uint256 public constant RATE4 =  1240;
uint256 public constant RATE5 =  1118;

  // Cap per tier for bonus in wei.
  //uint256 public constant TIER1 =  10000000000000000000000;
  //uint256 public constant TIER2 =  25000000000000000000000;
  //uint256 public constant TIER3 =  50000000000000000000000;
uint256 public initTimeStamp;
function DagtPri() public {
    initTimeStamp = now;
    mintedNums =0;
    totalSupply_ = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
}

function test() returns (uint256 initTimes,uint256 nowtime,uint256 blocktime) {
  return  (initTimeStamp,now,block.timestamp);
}
modifier onlyMintingFinished() {
  require(mintingFinished == true);
  _;
}


function lockSupplyNum() returns (uint256,uint256) {

   return  (mintedNums,totalSupply());
}
function setMintNum(uint256 _amount) returns (bool) {
  mintedNums =mintedNums+_amount;
}


function setLockMonth(uint256 _amount)  {
  //2018/5/10 0:0:0 1525881600;2018/6/1 0:0:0 1527782400;2018/7/1 0:0:0 1530374400
  //2018/8/1 0:0:0 1533052800;2018/9/1 0:0:0 1535731200;2018/9/30 23:59:59 1538323199

  if(now< 1525881600 && LockinMonth0==false)
  {

    LockinMonth1=false;
    LockinMonth2=false;
    LockinMonth3=false;
    LockinMonth4=false;
    LockinMonth0 = true;
    mintedNums=0;
  }
  if(now< 1525881600 && LockinMonth0==true && mintedNums>LOCK_NUMS_SUPPLY)
  {
    LockinMonth0 = false;
  }
   //
    if( now >=1525881600 && now< 1527782400 && LockinMonth1==false)
    {
      LockinMonth0 = false;
      LockinMonth2=false;
      LockinMonth3=false;
      LockinMonth4=false;
      LockinMonth1 = true;
      mintedNums=0;
    }
    if( now >=1525881600 && now< 1527782400 && LockinMonth1==true && mintedNums>LOCK_NUMS_SUPPLY)
    {
      LockinMonth1 = false;
    }
    //
    if( now >=1527782400 && now< 1530374400 && LockinMonth2==false)
    {
      LockinMonth0 = false;
      LockinMonth1=false;
      LockinMonth3=false;
      LockinMonth4=false;
      LockinMonth2 = true;
      mintedNums=0;
    }
    if( now >=1527782400 && now< 1530374400 && LockinMonth2==true && mintedNums>LOCK_NUMS_SUPPLY)
    {
      LockinMonth2 = false;
    }
    //
    if( now >=1530374400 && now< 1533052800 && LockinMonth3==false)
    {
      LockinMonth0 = false;
      LockinMonth1=false;
      LockinMonth2=false;
      LockinMonth4=false;
      LockinMonth3 = true;
      mintedNums=0;
    }
    if( now >=1530374400 && now< 1533052800 && LockinMonth3==true && mintedNums>LOCK_NUMS_SUPPLY)
    {
      LockinMonth3 = false;
    }
    //
    if( now >=1533052800 && now< 1535731200 && LockinMonth4==false)
    {
      LockinMonth0 = false;
      LockinMonth1=false;
      LockinMonth2=false;
      LockinMonth3=false;

      LockinMonth4 = true;
      mintedNums=0;
    }
    if(  now >=1533052800 && now< 1535731200 && LockinMonth4==true && mintedNums>LOCK_NUMS_SUPPLY)
    {
      LockinMonth4 = false;
    }

    if((mintedNums+_amount)>LOCK_NUMS_SUPPLY)
    {
      LockinMonth0 = false;
      LockinMonth1=false;
      LockinMonth2=false;
      LockinMonth3=false;
      LockinMonth4=false;
    }
  //  return (now,LockinMonth0,LockinMonth1,LockinMonth2,LockinMonth3,LockinMonth4);

}

/*
function test() returns (string block0) {

  return  GetBlock(0);
}*/
function approve(address _spender, uint256 _value) public onlyMintingFinished returns (bool) {
      return super.approve(_spender, _value);
  }

function mint(address _to, uint256 _amount)  public returns (bool)
{
     setLockMonth(_amount);
     if(LockinMonth0==true||LockinMonth1==true||LockinMonth2==true||LockinMonth3==true||LockinMonth4==true)
     {
       bool ret =  super.mint(_to,_amount);
       setMintNum(_amount);
       return ret;
     }else
     {
       return  false;
     }




}
//不需要挖矿
function transfer(address _to, uint256 _value) public returns (bool) {
  return super.transfer(_to, _value);
}

function transferFrom(address _from, address _to, uint256 _value) public onlyMintingFinished returns (bool) {
  return super.transferFrom(_from, _to, _value);
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
