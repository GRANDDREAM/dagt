pragma solidity ^0.4.18;


import "./Dagt.sol";

contract DagtPri is Dagt {

uint public LOCK_NUMS_SUPPLY = 20000000;

bool private LockinMonth0=false;
bool private LockinMonth1=false;
bool private LockinMonth2=false;
bool private LockinMonth3=false;
bool private LockinMonth4=false;

uint256 mintedNums=0;
// new rates

  // Cap per tier for bonus in wei.
  //uint256 public constant TIER1 =  10000000000000000000000;
  //uint256 public constant TIER2 =  25000000000000000000000;
  //uint256 public constant TIER3 =  50000000000000000000000;

function DagtPri() public {

   INITIAL_SUPPLY = 100000000;
    RATE1 =  1700;
    RATE2 =  1600;
    RATE3 =  1400;
    RATE4 =  1240;
    RATE5 =  1118;
    mintedNums =0;
    totalSupply_ = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
}

function transfer(address _to, uint256 _value) public onlyWhitelisted  returns (bool)  {
    return super.transfer(_to, _value);
  }


function mint(address _to, uint256 _amount)  public returns (bool)
{
  return  super.mint(_to,_amount);

}

function () payable {
  buyTokensPresale(msg.sender);
}
function buyTokensPresale(address beneficiary) payable {
  require(beneficiary != 0x0);
  uint256 tokens = weiAmount.mul(rate);

  require(validPurchasePresale(tokens));

  setLockMonth();
  setLockMonth_2();
  setMouthEnable(tokens);

  uint256 weiAmount = msg.value;
  uint256 rate=getDAGTRate();

  //weiRaisedPreSale = weiRaisedPreSale.add(weiAmount);
  mint(beneficiary, tokens);
  TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
  //forwardFunds();
}
function validPurchasePresale(uint256 _amount) internal constant returns (bool) {
//  bool withinPeriod = (block.number >= startBlock) && (block.number <= endPresale);
  //bool nonZeroPurchase = msg.value != 0;
  //bool withinCap = weiRaisedPreSale.add(msg.value) <= presaleCap;
  setLockMonth();
  setLockMonth_2();
  setMouthEnable(_amount);
  return (LockinMonth0==true||LockinMonth1==true||LockinMonth2==true||LockinMonth3==true||LockinMonth4==true);
}
function setLockMonth()  {
  //2018/5/10 0:0:0 1525881600;2018/6/1 0:0:0 1527782400;2018/7/1 0:0:0 1530374400
  //2018/8/1 0:0:0 1533052800;2018/9/1 0:0:0 1535731200;2018/9/30 23:59:59 1538323199

  if((now< 1525881600) && (LockinMonth0==false))
  {

    LockinMonth1=false;
    LockinMonth2=false;
    LockinMonth3=false;
    LockinMonth4=false;
    LockinMonth0 = true;
    mintedNums=0;
  }
  if((now< 1525881600) && (LockinMonth0==true) && (mintedNums>LOCK_NUMS_SUPPLY))
  {
    LockinMonth0 = false;
  }
   //e
    if( (now >=1525881600) && (now< 1527782400) && (LockinMonth1==false))
    {
      LockinMonth0 = false;
      LockinMonth2=false;
      LockinMonth3=false;
      LockinMonth4=false;
      LockinMonth1 = true;
      mintedNums=0;
    }
    if( (now >=1525881600) && (now< 1527782400) && (LockinMonth1==true) && (mintedNums>LOCK_NUMS_SUPPLY))
    {
      LockinMonth1 = false;
    }
    //
    if( (now >=1527782400) && (now< 1530374400) && (LockinMonth2==false))
    {
      LockinMonth0 = false;
      LockinMonth1=false;
      LockinMonth3=false;
      LockinMonth4=false;
      LockinMonth2 = true;
      mintedNums=0;
    }
    if((now >=1527782400) && (now< 1530374400) && (LockinMonth2==true) && (mintedNums>LOCK_NUMS_SUPPLY))
    {
      LockinMonth2 = false;
    }


  //  return (now,LockinMonth0,LockinMonth1,LockinMonth2,LockinMonth3,LockinMonth4);

}

function setLockMonth_2()
{
     if( (now >=1530374400) && (now< 1533052800) && (LockinMonth3==false))
    {
      LockinMonth0 = false;
      LockinMonth1=false;
      LockinMonth2=false;
      LockinMonth4=false;
      LockinMonth3 = true;
      mintedNums=0;
    }
    if( (now >=1530374400) && (now< 1533052800) && (LockinMonth3==true) && (mintedNums>LOCK_NUMS_SUPPLY))
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


}

function setMouthEnable(uint256 _amount)
{
    if((mintedNums+_amount)>LOCK_NUMS_SUPPLY)
    {
      LockinMonth0 = false;
      LockinMonth1=false;
      LockinMonth2=false;
      LockinMonth3=false;
      LockinMonth4=false;
    }
}
/*
function lockSupplyNum() returns (uint256,uint256) {

   return  (mintedNums,totalSupply());
}*/

function setMintNum(uint256 _amount) returns (bool) {
  mintedNums =mintedNums+_amount;
}



}
