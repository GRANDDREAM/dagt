pragma solidity ^0.4.18;


import "./Dagt.sol";

contract DagtPub is Dagt {

 uint public LOCK_NUMS_SUPPLY = 20000000;

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

  function DagtPub() public {
    RATE1 =  1400;
    RATE2 =  1310;
    RATE3 =  1240;
    RATE4 =  1180;
    RATE5 =  1118;  
    totalSupply_ = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
}

  function forwardFunds() internal {
    wallet.transfer(msg.value);
  }

  function getDAGTRate() returns (uint256 rate) {
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
  uint256 weiAmount = msg.value;
  //weiRaisedPreSale = weiRaisedPreSale.add(weiAmount);
  mint(beneficiary, tokens);
  TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
  //forwardFunds();
}






}
