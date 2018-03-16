pragma solidity ^0.4.17;

import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract Dagt is StandardToken {
    string public name = "DAGT Token";
    string public symbol = "DAGT";
    uint8 public decimals = 18;
    uint public INITIAL_SUPPLY = 100000000;
  


    function Dagt() public {
        totalSupply_ = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
    }
}