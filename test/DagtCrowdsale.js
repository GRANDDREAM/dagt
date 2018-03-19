var DagtCrowdsale = artifacts.require("./DagtCrowdsale.sol");

contract('DagtCrowdsale', function(accounts) {
    accounts[0]='0x8154fE1Fe5Db5e7916a004a7B9a1121CFA9aDaAa';
  it("should put 0 DagtCrowdsale in the first account", function() {
    return DagtCrowdsale.deployed().then(function(instance) {
      return instance.getBalance.call(accounts[0]);
    }).then(function(balance) {
      assert.equal(balance.valueOf(), 0, "0 wasn't in the first account");
    });
  });
  it("should call a function that depends on a linked library", function() {
    var dagt;
    var dagtCoinBalance;
    var dagtCoinEthBalance;

    return DagtCrowdsale.deployed().then(function(instance) {
      dagt = instance;
      return dagt.getBalance.call(accounts[0]);
    }).then(function(outCoinBalance) {
      dagtCoinBalance = outCoinBalance.toNumber();
      return dagt.getBalanceInEth.call(accounts[0]);
    }).then(function(outCoinBalanceEth) {
      dagtCoinEthBalance = outCoinBalanceEth.toNumber();
    }).then(function() {
      assert.equal(dagtCoinEthBalance, 2 * dagtCoinBalance, "Library function returned unexpected function, linkage may be broken");
    });
  });
  it("should send coin correctly", function() {
    var dagt;

    // Get initial balances of first and second account.
    var account_one = accounts[0];
    var account_two = accounts[1];

    var account_one_starting_balance;
    var account_two_starting_balance;
    var account_one_ending_balance;
    var account_two_ending_balance;

    var amount = 10;

    return DagtCrowdsale.deployed().then(function(instance) {
      dagt = instance;
      return dagt.getBalance.call(account_one);
    }).then(function(balance) {
      account_one_starting_balance = balance.toNumber();
      return dagt.getBalance.call(account_two);
    }).then(function(balance) {
      account_two_starting_balance = balance.toNumber();
      return dagt.sendCoin(account_two, amount, {from: account_one});
    }).then(function() {
      return dagt.getBalance.call(account_one);
    }).then(function(balance) {
      account_one_ending_balance = balance.toNumber();
      return dagt.getBalance.call(account_two);
    }).then(function(balance) {
      account_two_ending_balance = balance.toNumber();

      assert.equal(account_one_ending_balance, account_one_starting_balance - amount, "Amount wasn't correctly taken from the sender");
      assert.equal(account_two_ending_balance, account_two_starting_balance + amount, "Amount wasn't correctly sent to the receiver");
    });
  });
});