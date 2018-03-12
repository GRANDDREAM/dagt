pragma solidity ^0.4.17;

//import 'zeppelin-solidity/contracts/token/ERC20/MintableToken.sol';
//import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import "./DagtStandard.sol";

contract DagtPri is DagtStandard {

uint public LOCK_NUMS_SUPPLY = 20000000;

bool private LockinMonth0=false;
bool private LockinMonth1=false;
bool private LockinMonth2=false;
bool private LockinMonth3=false;
bool private LockinMonth4=false;

uint256 mintedNums;
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
    LockinMonth4=false;d
    LockinMonth0 = true;
    mintedNums=0;
  }
  if(now< 1525881600 && LockinMonth0==true && mintedNums>LOCK_NUMS_SUPPLY)
  {
    LockinMonth0 = false;
  }
   //e
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

}
