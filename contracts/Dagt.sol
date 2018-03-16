pragma solidity ^0.4.17;

import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";

contract Dagt is MintableToken {
    string public constant version = "1.0";
    // DAGT token unit.
    // Using same decimal value as ETH (makes ETH-DAGT conversion much easier).
    // This is the same as in DAGT token contract.
    uint256 public constant TOKEN_UNIT = 10 ** 18;

    // Maximum number of tokens in circulation
    uint256 public constant MAX_TOKENS = 100000000 * TOKEN_UNIT;

    string public constant name = "DAGT Crypto Platform";
    string public constant symbol = "DAGT";
    uint8 public constant decimals = 18;

    modifier onlyMintingFinished() {
        require(mintingFinished == true);
        _;
    }
    /// @dev Same ERC20 behavior, but require the token to be unlocked
    /// @param _spender address The address which will spend the funds.
    /// @param _value uint256 The amount of tokens to be spent.
    function approve(address _spender, uint256 _value) public onlyMintingFinished returns (bool) {
        return super.approve(_spender, _value);
    }

    /// @dev Same ERC20 behavior, but require the token to be unlocked
    /// @param _to address The address to transfer to.
    /// @param _value uint256 The amount to be transferred.
    function transfer(address _to, uint256 _value) public onlyMintingFinished returns (bool) {
        return super.transfer(_to, _value);
    }

    /// @dev Same ERC20 behavior, but require the token to be unlocked
    /// @param _from address The address which you want to send tokens from.
    /// @param _to address The address which you want to transfer to.
    /// @param _value uint256 the amount of tokens to be transferred.
    function transferFrom(address _from, address _to, uint256 _value) public onlyMintingFinished returns (bool) {
        return super.transferFrom(_from, _to, _value);
    }

}