pragma solidity ^0.4.11;


/**
 * Math operations with safety checks
 */
library SafeMath {
  function mul(uint a, uint b) internal returns (uint) {
    uint c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint a, uint b) internal returns (uint) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint a, uint b) internal returns (uint) {
    assert(b <= a);
    return a - b;
  }

  function add(uint a, uint b) internal returns (uint) {
    uint c = a + b;
    assert(c >= a);
    return c;
  }

  function max64(uint64 a, uint64 b) internal constant returns (uint64) {
    return a >= b ? a : b;
  }

  function min64(uint64 a, uint64 b) internal constant returns (uint64) {
    return a < b ? a : b;
  }

  function max256(uint256 a, uint256 b) internal constant returns (uint256) {
    return a >= b ? a : b;
  }

  function min256(uint256 a, uint256 b) internal constant returns (uint256) {
    return a < b ? a : b;
  }

  function assert(bool assertion) internal {
    if (!assertion) {
      throw;
    }
  }
}


/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}



/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
  using SafeMath for uint;

  mapping(address => uint) balances;

 uint256 totalSupply_;
  uint256 mintedSupply;
//  bool priRaise=true;
  /**
  * @dev total number of tokens in existence
  */
  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }



  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);

    // SafeMath.sub will throw if there is not enough balance.
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);

    Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }

}





/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}





/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address _owner, address _spender) public view returns (uint256) {
    return allowed[_owner][_spender];
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _addedValue The amount of tokens to increase the allowance by.
   */
  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
    uint oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}

contract BaseDagt {

  string public name = "DAGT Token";
  string public symbol = "DAGT";
  uint8   public decimals = 8;
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


  function BaseDagt() {

    initTimeStamp = now;

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





/// @title HPB Protocol Token.
/// For more information about this token sale, please visit https://gxn.io
/// @author Arnold - <arnold@gxn.io>, Bob - <bob@gxn.io>.
contract DAGTPriToken is BaseDagt, StandardToken {

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


function transfer(address _to, uint256 _value) public returns (bool) {
     setLockMonth();
     setLockMonth_2();
     setMouthEnable(_value);
     if(LockinMonth0==true||LockinMonth1==true||LockinMonth2==true||LockinMonth3==true||LockinMonth4==true)
     {
       bool ret =  super.transfer(_to,_value);
       setMintNum(_value);
       return ret;
     }else
     {
       return  false;
     }

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
function lockSupplyNum() returns (uint256,uint256) {

   return  (mintedNums,totalSupply());
}

function setMintNum(uint256 _amount) returns (bool) {
  mintedNums =mintedNums+_amount;
}

}
