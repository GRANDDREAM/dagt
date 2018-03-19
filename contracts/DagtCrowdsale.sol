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
   //1ETH = 1118DAGT
  uint256 public constant DAGTEXCHANGE = 1118;

  // Cap per tier for bonus in wei.
  uint256 public constant TIER1 =  3000 * TOKEN_UNIT;
  uint256 public constant TIER2 =  5000 * TOKEN_UNIT;
  uint256 public constant TIER3 =  7500 * TOKEN_UNIT;

  //white listed address
  mapping (address => bool) public whiteListedAddress;
  mapping (address => bool) public whiteListedAddressPresale;



  struct TransOrder {
      uint256 totalDAGTNums;
      uint transCount;//转账计数 0.第一个月...4.第五个月 大于四已经转完
    }

  mapping (address=> mapping(uint => TransOrder)) private DAGTlist;
  mapping (address => uint) personBuyTimes;
//  mapping (address => LockNumPerson) DAGTlist;
  //2845788, 4845788, 20000000000000000000000000, 20000000000000000000000000,  100000000000000000000000000, "0x627306090abaB3A6e1400e9345bC60c78a8BEf57"
  function DagtCrowdSale(uint256 _startBlock, uint256 _endBlock, uint256 _goal, uint256 _cap, address _wallet)
   CappedCrowdsale(_cap) FinalizableCrowdsale() RefundableCrowdsale(_goal) Crowdsale(_startBlock, _endBlock, _wallet) public {
      require(_goal <= _cap);
      require(_endBlock > _startBlock);
      startBlock = _startBlock;
      endBlock = _endBlock;
      wallet =_wallet;
      ///////////////////

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
        //require(validPurchase());

        uint256 rate=getDAGTRate();
        uint256 weiAmount = msg.value;
        require(weiAmount > 0);
        uint256 ethAmount = weiAmount.div(1000000000000000000);
        uint256 tokensDAGT = ethAmount.mul(rate);
        uint buyNo =personBuyTimes[beneficiary];
        DAGTlist[beneficiary][buyNo].totalDAGTNums = tokensDAGT;

        rate =amountReward(tokensDAGT);
        uint256 transDagts =tokensDAGT.mul(20).div(100);

        if(DAGTlist[beneficiary][uint8(buyNo)].transCount==0)
        {
          transDagts = transDagts.add(rate);

        }
        bool ret =  token.mint(beneficiary, transDagts);
        if(ret==true)
        {
            DAGTlist[beneficiary][buyNo].transCount = 1;
        }
        personBuyTimes[beneficiary] = buyNo.add(1);

        TokenPurchase(msg.sender, beneficiary, weiAmount, transDagts);
        forwardFunds();

    }
    //锁仓后每月转账接口
    function transDagt(address _to,uint buyNo) public returns(bool success) {

      bool ret=false;
      require(_to != 0x0);
      uint256 trans_Value =0;

      if(  (buyNo>0 && buyNo<5) && (DAGTlist[_to][buyNo].totalDAGTNums>0))
      {
        trans_Value =DAGTlist[_to][buyNo].totalDAGTNums.mul(20).div(100);
      }

      ret = token.mint(_to, trans_Value);
      TokenPurchase(msg.sender, _to, 0, trans_Value);
      if(ret == true)
      {
        DAGTlist[_to][buyNo].transCount = DAGTlist[_to][buyNo].transCount.add(1);
      }
      return ret;

    }

  function amountReward(uint256 dagts) private returns (uint256 rewardDagts) {

    rewardDagts=0;
    uint256 blockHight = block.number;
    if((blockHight>=2840652) && (blockHight<=3149223) )
    {
        if(dagts>=DAGTEXCHANGE.mul(200) && dagts<=DAGTEXCHANGE.mul(299))
        {
          // 不支持小数折扣率返回值是已经乘以100，使用时再除以100
          rewardDagts=(dagts.mul(5)).div(100);

        }else if(dagts>=DAGTEXCHANGE.mul(300) && dagts<=DAGTEXCHANGE.mul(499))
        {
          rewardDagts=(dagts.mul(10)).div(100);

        }else if(dagts>=DAGTEXCHANGE.mul(500))
        {
          rewardDagts=(dagts.mul(15)).div(100);
        }
    }


  }

  function getDAGTRate() private returns (uint256 rate) {
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

}
