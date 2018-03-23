pragma solidity ^0.4.17;

import "./zeppelin/token/ERC20/MintableToken.sol";

contract DAGTCoin is MintableToken {
  string public constant name = "DAGT Crypto Platform";
  string public constant symbol = "DAGT_A";
  uint8 public constant decimals = 18;
  uint256 public constant TOKEN_UNIT = 10 ** 18;
  address private wallet;
  address compAddress;
  address teamAddress;
  //uint256 public constant MAX_TOKENS = 100000000 * TOKEN_UNIT;


   //1ETH = 1118DAGT
  uint256 public constant DAGTEXCHANGE = 1118;
  mapping (address => bool) public whiteListedAddress;

 //折扣值区块高度范围
 uint256[] private blocksRanges;
 uint[] private rates;
// 奖励区块高度范围:[0]...[1]
 uint256[] private rewardBlocksHeight = new uint256[](2);
 uint[] private rewardRates;
 uint[] private extraRewardRanges;

event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
 struct TransOrder {
     uint256 totalDAGTNums;
     uint transCount;//转账计数 0.第一个月...4.第五个月 大于四已经转完
   }

 mapping (address=> mapping(uint => TransOrder)) private DAGTlist;
 mapping (address => uint) personBuyTimes;

 uint  public TtestNo =1;

 function DAGTCoin() public {

   totalSupply_ = 100000000 * TOKEN_UNIT;
   wallet = 0xfc2eE3eCbF820DB0E3264358462D64Fda4362133;
   balances[wallet] = TOKEN_UNIT;
 }


 function () public payable {
     TtestNo = 3;
     buyTokens(msg.sender);
 }
  function transfer(address _to, uint256 _value) public returns (bool) {

  }
 function buyTokens(address beneficiary) public payable onlyWhitelisted {
        TtestNo = 3;
       require(beneficiary != 0x0);
       //require(validPurchase());
       uint256 rate=getETH2DAGTRate();
       uint256 weiAmount = msg.value;
       require(weiAmount > 0);
       uint256 ethAmount = weiAmount.div(1000000000000000000);
       uint256 tokensDAGT = ethAmount.mul(rate);
       uint buyNo =personBuyTimes[beneficiary];

       DAGTlist[beneficiary][buyNo].totalDAGTNums = tokensDAGT;

       rate =amountReward(tokensDAGT);
       uint256 transDagts =tokensDAGT.mul(20).div(100);

       if(DAGTlist[beneficiary][buyNo].transCount==0)
       {
         transDagts = transDagts.add(rate);

       }
       bool ret = super.transferFrom(compAddress,beneficiary,transDagts);//   token.mint(beneficiary, transDagts);
       if(ret==true)
       {
           DAGTlist[beneficiary][buyNo].transCount = 1;
       }
       personBuyTimes[beneficiary] = buyNo.add(1);

       TokenPurchase(msg.sender, beneficiary, weiAmount, transDagts);
       forwardFunds();

   }
   //锁仓后每月转账接口
   function transDagt(address _to,uint buyNo) public  {

     bool ret=false;
     require(_to != 0x0);
     uint256 trans_Value =0;

     if(  (buyNo>0 && buyNo<5) && (DAGTlist[_to][buyNo].totalDAGTNums>0))
     {
       trans_Value =DAGTlist[_to][buyNo].totalDAGTNums.mul(20).div(100);
     }


     ret = super.transferFrom(compAddress,_to,trans_Value);
     if(ret == true)
     {
       DAGTlist[_to][buyNo].transCount = DAGTlist[_to][buyNo].transCount.add(1);
     }
    TokenPurchase(msg.sender, _to, 0, trans_Value);

   }

 function getBuyNos(address _from) public view returns(uint buyNo){
    buyNo =TtestNo;//personBuyTimes[_from];
 }

//设置开始 结束区块高度及折扣值,以便计算ETH折扣DAGT
function setBlocksRate(uint256[] _blocksRanges,uint256[] _rates) public{
  require(_blocksRanges.length >=2);
  require(_blocksRanges.length == _rates.length.mul(2));
  blocksRanges =  new uint256[](_blocksRanges.length);
  rates = new uint[](_rates.length);
  blocksRanges = _blocksRanges;
  rates = _rates;
  /* for( uint i = 0 ; i < _startBlocks.length ; i++ )
   {

     blocksRateStart[i] = _startBlocks[i];
     blocksRateEnd[i] = _endBlocks[i];
     rates[i] = _rates[i];

   }*/
}
//通过时间转换成区块高度，取得ETH折扣DAGT
function getETH2DAGTRate() private view returns (uint256 rate) {

   uint blockHight = block.number;
    rate = 0;
    uint idx =0;
    for( uint i = 0 ; i < blocksRanges.length ; i+=2)
    {
      if((blockHight>blocksRanges[i]) && (blockHight<=blocksRanges[i+1]) )
      {
        rate = rates[idx];
        idx++;
      }
    }
    return rate;
  }
//
function setRewardRange(uint256[] _blocksNums, uint[] _extraRewardRanges, uint[] _rewards) public{
  rewardBlocksHeight =  new uint256[](_blocksNums.length);
  extraRewardRanges =  new uint256[](_extraRewardRanges.length);
  extraRewardRanges =  new uint256[](_rewards.length);
  rewardBlocksHeight = _blocksNums;
  extraRewardRanges =_extraRewardRanges;
  rewardRates = _rewards;
}

function amountReward(uint256 dagts) private view returns (uint256 rewardDagts) {
    rewardDagts=0;
    uint256 blockHight = block.number;
    if((blockHight>=rewardBlocksHeight[0]) && (blockHight<=rewardBlocksHeight[1]) )
    {
      uint idx =0;
       for(uint i =0;i<extraRewardRanges.length;i=i+2)
       {
         if(dagts>=DAGTEXCHANGE.mul(extraRewardRanges[i]) && dagts<=DAGTEXCHANGE.mul(extraRewardRanges[i+1]))
         {
           rewardDagts=(dagts.mul(rewardRates[idx])).div(100);
           idx++;
         }
       }
    }


  }

  function forwardFunds() internal {
    wallet.transfer(msg.value);
  }

 modifier onlyWhitelisted() {
     require( isWhitelisted(msg.sender)) ;
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


 function isWhitelisted(address _user) public constant returns (bool) {
     return whiteListedAddress[_user];
 }

 function testjs() public returns(bool ret){

   return true;

 }

}
