pragma solidity ^0.4.18;


import "./Dagt.sol";

contract DagtPri is Dagt {

  using SafeMath for uint256;

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
  uint    public INITIAL_SUPPLY = 20000000;
  uint256  public initTimeStamp;

//  uint256 public constant RATE1 =  1400;
  uint256 public  RATE1 =  1400;
  uint256 public  RATE2 =  1310;
  uint256 public  RATE3 =  1240;
  uint256 public  RATE4 =  1180;
  uint256 public  RATE5 =  1118;
  // new rates


    // Cap per tier for bonus in wei.
    //uint256 public constant TIER1 =  10000000000000000000000;
    //uint256 public constant TIER2 =  25000000000000000000000;
    //uint256 public constant TIER3 =  50000000000000000000000;
    //white listed address
  mapping (address => bool) public whiteListedAddress;
  mapping (address => bool) public whiteListedAddressPresale;
  address public wallet;

  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

  function DagtPri() public {
    initTimeStamp = now;
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

  function forwardFunds() internal {
    wallet.transfer(msg.value);
  }

  function getDAGTRate() returns (uint256 rate) {
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
  //  blocktime = block.timestamp;
  //  blocknum = block.number;
    //return rate;
  }

  modifier onlyPresaleWhitelisted() {
    require( isWhitelistedPresale(msg.sender) ) ;
    _;
  }

  modifier onlyWhitelisted() {
    require( isWhitelisted(msg.sender) || isWhitelistedPresale(msg.sender) ) ;
    _;
  }
  /**
     * @dev Add a list of address to be whitelisted for the crowdsale only.
     * @param _users , the list of user Address. Tested for out of gas until 200 addresses.
     */
    function whitelistAddresses( address[] _users) onlyOwner {
      for( uint i = 0 ; i < _users.length ; i++ ) {
        whiteListedAddress[_users[i]] = true;
      }
    }

    function unwhitelistAddress( address _users) onlyOwner {
      whiteListedAddress[_users] = false;
    }

    /**
     * @dev Add a list of address to be whitelisted for the Presale And sale.
     * @param _users , the list of user Address. Tested for out of gas until 200 addresses.
     */
    function whitelistAddressesPresale( address[] _users) onlyOwner {
      for( uint i = 0 ; i < _users.length ; i++ ) {
        whiteListedAddressPresale[_users[i]] = true;
      }
    }

    function unwhitelistAddressPresale( address _users) onlyOwner {
      whiteListedAddressPresale[_users] = false;
    }

    function isWhitelisted(address _user) public constant returns (bool) {
      return whiteListedAddress[_user];
    }

    function isWhitelistedPresale(address _user) public constant returns (bool) {
      return whiteListedAddressPresale[_user];
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
    uint256 rate=getDAGTRate();
  uint256 tokens = weiAmount.mul(rate);

  require(validPurchasePresale(tokens));

  setLockMonth();
  setLockMonth_2();
  setMouthEnable(tokens);

  uint256 weiAmount = msg.value;


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
