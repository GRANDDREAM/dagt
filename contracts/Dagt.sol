pragma solidity ^0.4.17;

import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract Dagt is StandardToken {
    string public constant name = "DAGT Token";
    string public  constant symbol = "DAGT";
    uint8 public  constant decimals = 18;
    // DAGT token unit.
    // Using same decimal value as ETH (makes ETH-DAGT conversion much easier).
    // This is the same as in DAGT token contract.
    uint256 public constant TOKEN_UNIT = 10 ** 18;

    // Maximum number of tokens in circulation
    uint256 public constant MAX_TOKENS = 100000000 * TOKEN_UNIT;

    function Dagt() public {
        totalSupply_ = MAX_TOKENS;
        balances[msg.sender] = MAX_TOKENS;
    }
}