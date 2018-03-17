pragma solidity ^0.4.11;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import "./crowdsale/CappedCrowdsale.sol";
import "./crowdsale/RefundableCrowdsale.sol";
import './Dagt.sol';

//contract DagtCrowdSale is CappedCrowdsale, RefundableCrowdsale {
contract DagtCrowdSale is Dagt,CappedCrowdsale, RefundableCrowdsale {
    // DAGT token unit.
    // Using same decimal value as ETH (makes ETH-DAGT conversion much easier).
    // This is the same as in DAGT token contract.
    uint256 public constant TOKEN_UNIT = 10 ** 18;

    // Maximum number of tokens in circulation
    uint256 public constant MAX_TOKENS = 100000000 * TOKEN_UNIT;
    uint256 public constant LOCK_NUMS_SUPPLY = 20000000;
    // new rates
    uint256 public constant RATE1 = 1700;
    uint256 public constant RATE2 = 1600;
    uint256 public constant RATE3 = 1400;
    uint256 public constant RATE4 = 1240;
    uint256 public constant RATE5 = 1118;

    bool private LockinMonth0=false;
    bool private LockinMonth1=false;
    bool private LockinMonth2=false;
    bool private LockinMonth3=false;
    bool private LockinMonth4=false;


    // Cap per tier for bonus in wei.
    uint256 public constant TIER1 =  3000 * TOKEN_UNIT;
    uint256 public constant TIER2 =  5000 * TOKEN_UNIT;
    uint256 public constant TIER3 =  7500 * TOKEN_UNIT;
    uint256 public mintedNums;
    mapping (address => uint256) public rewardBalanceOf;
    //white listed address
    mapping (address => bool) public whiteListedAddress;
    mapping (address => bool) public whiteListedAddressPresale;

/*
    uint256 public startBlock;
    uint256 public endBlock;

    // address where funds are collected
    address public wallet;*/


    function DagtCrowdSale(uint256 _startBlock, uint256 _endBlock, uint256 _goal, uint256 _cap, address _wallet)
     CappedCrowdsale(_cap) FinalizableCrowdsale() RefundableCrowdsale(_goal) Crowdsale(_startBlock, _endBlock, _wallet) public {
        require(_goal <= _cap);
        require(_endBlock > _startBlock);
      //  startBlock = _startBlock;
      //  endBlock = _endBlock;
      //  wallet =_wallet;

    }

    function createTokenContract() internal returns (MintableToken) {
        return new Dagt();
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
    function whitelistAddresses( address[] _users) public onlyOwner {
        for( uint i = 0 ; i < _users.length ; i++ ) {
        whiteListedAddress[_users[i]] = true;
        }
    }

    function unwhitelistAddress( address _users) public onlyOwner {
        whiteListedAddress[_users] = false;
    }

    /**
    * @dev Add a list of address to be whitelisted for the Presale And sale.
    * @param _users , the list of user Address. Tested for out of gas until 200 addresses.
    */
    function whitelistAddressesPresale( address[] _users) public onlyOwner {
        for( uint i = 0 ; i < _users.length ; i++ ) {
        whiteListedAddressPresale[_users[i]] = true;
        }
    }

    function unwhitelistAddressPresale( address _users) public onlyOwner {
        whiteListedAddressPresale[_users] = false;
    }

    function isWhitelisted(address _user) public constant returns (bool) {
        return whiteListedAddress[_user];
    }

    function isWhitelistedPresale(address _user) public constant returns (bool) {
        return whiteListedAddressPresale[_user];
    }

    function () public payable {
        buyTokens(msg.sender);
    }

    function buyTokens(address beneficiary) public payable onlyWhitelisted {
        require(beneficiary != 0x0);
        require(validPurchase());

        uint256 rate=getDAGTRate();

        uint256 weiAmount = msg.value;
        uint256 ethAmount = weiAmount.div(1000000000000000000);
        uint256 tokens = ethAmount.mul(rate);

        rate =calculateAmountReward(beneficiary,ethAmount);

       // 不支持小数折扣率返回值是已经乘以100，使用时再除以100
        tokens = tokens.add((tokens.mul(rate)).div(100));

        //为了锁仓计算
        setOnceLockNum(tokens);
        require(validPurchasePresale(tokens));
        token.mint(beneficiary, tokens);
        TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
        forwardFunds();
    }

    function calculateAmountReward(address from,uint256 eth) private returns (uint256 rewardDagt) {


      rewardDagt=0;
      if((now>=1521129600) && (now<=1525017599) )
      {
          rewardBalanceOf[from] = rewardBalanceOf[from].add(eth);
          uint veth = rewardBalanceOf[from];
          if(veth>=200 && veth<=299)
          {
            rewardDagt=5;

          }else if(veth>=300 && veth<=499)
          {
            rewardDagt=10;

          }else if(veth>=500)
          {
            rewardDagt=15;
          }
      }


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
      //2018/5/1 0:0:0 1525104000;2018/6/1 0:0:0 1527782400;2018/7/1 0:0:0 1530374400
      //2018/8/1 0:0:0 1533052800;2018/9/1 0:0:0 1535731200;2018/9/30 23:59:59 1538323199
      uint blockHight = block.number;
      // 2018.3.16 1521129600,blockHight:2840652
      //
      if((blockHight< 3156080) && (LockinMonth0==false))
      {

        LockinMonth1=false;
        LockinMonth2=false;
        LockinMonth3=false;
        LockinMonth4=false;
        LockinMonth0 = true;
        mintedNums=0;
      }
      if((blockHight< 3156080) && (LockinMonth0==true) && (mintedNums>LOCK_NUMS_SUPPLY))
      {
        LockinMonth0 = false;
      }
       //e
        if( (blockHight >=3156080) && (blockHight< 3217795) && (LockinMonth1==false))
        {
          LockinMonth0 = false;
          LockinMonth2=false;
          LockinMonth3=false;
          LockinMonth4=false;
          LockinMonth1 = true;
          mintedNums=0;
        }
        if( (blockHight >=3156080) && (blockHight< 3217795) && (LockinMonth1==true) && (mintedNums>LOCK_NUMS_SUPPLY))
        {
          LockinMonth1 = false;
        }
        //
        if( (blockHight >=3217795) && (blockHight< 3574366) && (LockinMonth2==false))
        {
          LockinMonth0 = false;
          LockinMonth1=false;
          LockinMonth3=false;
          LockinMonth4=false;
          LockinMonth2 = true;
          mintedNums=0;
        }
        if((blockHight >=3217795) && (blockHight< 3574366) && (LockinMonth2==true) && (mintedNums>LOCK_NUMS_SUPPLY))
        {
          LockinMonth2 = false;
        }


      //  return (now,LockinMonth0,LockinMonth1,LockinMonth2,LockinMonth3,LockinMonth4);

    }

    function setLockMonth_2 ()
    {
      //2018/5/1 0:0:0 1525104000;2018/6/1 0:0:0 1527782400;2018/7/1 0:0:0 1530374400
      //2018/8/1 0:0:0 1533052800;2018/9/1 0:0:0 1535731200;2018/9/30 23:59:59 1538323199
      uint blockHight = block.number;
       if( (blockHight >=3574366) && (blockHight< 3786938) && (LockinMonth3==false))
        {
          LockinMonth0 = false;
          LockinMonth1=false;
          LockinMonth2=false;
          LockinMonth4=false;
          LockinMonth3 = true;
          mintedNums=0;
        }
        if( (blockHight >=3574366) && (blockHight< 3786938) && (LockinMonth3==true) && (mintedNums>LOCK_NUMS_SUPPLY))
        {
          LockinMonth3 = false;
        }
        //
        if( blockHight >=3786938 && blockHight< 3963509 && LockinMonth4==false)
        {
          LockinMonth0 = false;
          LockinMonth1=false;
          LockinMonth2=false;
          LockinMonth3=false;

          LockinMonth4 = true;
          mintedNums=0;
        }
        if(blockHight >=3963509 && blockHight< 4205223 && LockinMonth4==true && mintedNums>LOCK_NUMS_SUPPLY)
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

    function getDAGTRate() private returns (uint256 rate) {
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

     uint blockHight = block.number;
      rate = 0;
    /* */
      /*if((block.number>=startNumbers_1) && (block.number<=endNumbers_1) )
      {
          rate = RATE1;
      }else if((block.number>=startNumbers_2) && (block.number<=endNumbers_2))
      {
          rate = RATE2;*/
      if((blockHight>=2840652) && (blockHight<=2908683) )
       {
         rate = RATE1;
       }else if((blockHight>2908683) && (blockHight<=2970937) )
      {
          rate = RATE2;
      }else if((blockHight>2970937) && (blockHight<=3039509) )
      {
        rate = RATE3;
      }else if((blockHight>3039509) && (blockHight<=3108080) )
      {
        rate = RATE4;
      }else if((blockHight>3108080) && (blockHight<=3149223) )
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
/*
    // calculate the amount of token the user is getting - can overlap on multiple tiers.
    function calculateTokenAmount(uint256 weiAmount) internal returns (uint256) {
        uint256 amountToBuy = weiAmount;
        uint256 amountTokenBought;
        uint256 currentWeiRaised = weiRaised;
        if (currentWeiRaised < TIER1 && amountToBuy > 0) {
        var (amountBoughtInTier, amountLeftTobuy) = calculateAmountPerTier(amountToBuy,TIER1,RATE1,currentWeiRaised);
        amountTokenBought = amountTokenBought.add(amountBoughtInTier);
        currentWeiRaised = currentWeiRaised.add(amountToBuy.sub(amountLeftTobuy));
        amountToBuy = amountLeftTobuy;
        }
        if (currentWeiRaised < TIER2 && amountToBuy > 0) {
        (amountBoughtInTier, amountLeftTobuy) = calculateAmountPerTier(amountToBuy,TIER2,RATE2,currentWeiRaised);
        amountTokenBought = amountTokenBought.add(amountBoughtInTier);
        currentWeiRaised = currentWeiRaised.add(amountToBuy.sub(amountLeftTobuy));
        amountToBuy = amountLeftTobuy;
        }
        if (currentWeiRaised < TIER3 && amountToBuy > 0) {
        (amountBoughtInTier, amountLeftTobuy) = calculateAmountPerTier(amountToBuy,TIER3,RATE3,currentWeiRaised);
        amountTokenBought = amountTokenBought.add(amountBoughtInTier);
        currentWeiRaised = currentWeiRaised.add(amountToBuy.sub(amountLeftTobuy));
        amountToBuy = amountLeftTobuy;
        }
        if ( currentWeiRaised < cap && amountToBuy > 0) {
        (amountBoughtInTier, amountLeftTobuy) = calculateAmountPerTier(amountToBuy,cap,RATE4,currentWeiRaised);
        amountTokenBought = amountTokenBought.add(amountBoughtInTier);
        currentWeiRaised = currentWeiRaised.add(amountToBuy.sub(amountLeftTobuy));
        amountToBuy = amountLeftTobuy;
        }
        return amountTokenBought;
    }

    // calculate the amount of token within a tier.
    function calculateAmountPerTier(uint256 amountToBuy,uint256 tier,uint256 rate,uint256 currentWeiRaised) internal returns (uint256,uint256) {
        uint256 amountAvailable = tier.sub(currentWeiRaised);
        if ( amountToBuy > amountAvailable ) {
        uint256 amountBoughtInTier = amountAvailable.mul(rate);
        amountToBuy = amountToBuy.sub(amountAvailable);
        return (amountBoughtInTier,amountToBuy);
        } else {
        amountBoughtInTier = amountToBuy.mul(rate);
        return (amountBoughtInTier,0);
        }
    }*/

    function finalization() internal {
        if (goalReached()) {
        //DAGT gets 20% of the amount of the total token supply
        uint256 totalSupply = token.totalSupply();
        // total supply
        token.mint(wallet, MAX_TOKENS.sub(totalSupply));

        token.finishMinting();
        }
        super.finalization();
    }

    function setOnceLockNum(uint256 _amount) public returns (bool ret) {

      mintedNums =mintedNums+_amount;

    }

}
