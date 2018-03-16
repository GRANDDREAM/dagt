pragma solidity ^0.4.11;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import "./crowdsale/CappedCrowdsale.sol";
import "./crowdsale/RefundableCrowdsale.sol";
import './Dagt.sol';

contract DagtCrowdSale is CappedCrowdsale, RefundableCrowdsale {
    // DAGT token unit.
    // Using same decimal value as ETH (makes ETH-DAGT conversion much easier).
    // This is the same as in DAGT token contract.
    uint256 public constant TOKEN_UNIT = 10 ** 18;

    // Maximum number of tokens in circulation
    uint256 public constant MAX_TOKENS = 100000000 * TOKEN_UNIT;
    
    // new rates
    uint256 public constant RATE1 = 13000;
    uint256 public constant RATE2 = 12000;
    uint256 public constant RATE3 = 11000;
    uint256 public constant RATE4 = 10000;


    // Cap per tier for bonus in wei.
    uint256 public constant TIER1 =  3000 * TOKEN_UNIT;
    uint256 public constant TIER2 =  5000 * TOKEN_UNIT;
    uint256 public constant TIER3 =  7500 * TOKEN_UNIT;



    function DagtCrowdSale(uint256 _startBlock, uint256 _endBlock, uint256 _goal, uint256 _cap, address _wallet) CappedCrowdsale(_cap) FinalizableCrowdsale() RefundableCrowdsale(_goal) Crowdsale(_startBlock, _endBlock, _wallet) public {
        require(_goal <= _cap);
        require(_endBlock > _startBlock);
    }

    function createTokenContract() internal returns (MintableToken) {
        return new Dagt();
    }

    //white listed address
    mapping (address => bool) public whiteListedAddress;
    mapping (address => bool) public whiteListedAddressPresale;

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

        uint256 weiAmount = msg.value;
        uint256 tokens = calculateTokenAmount(weiAmount);
        weiRaised = weiRaised.add(weiAmount);

        token.mint(beneficiary, tokens);
        TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
        forwardFunds();
    }

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
