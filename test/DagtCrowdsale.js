
var DagtCrowdsale = artifacts.require("./DagtCrowdsale.sol");
contract('DagtCrowdsale', function(accounts) {
    accounts[0]='0x8154fE1Fe5Db5e7916a004a7B9a1121CFA9aDaAa';
    var owner  = accounts[0];
    var account1 = "0xfc2eE3eCbF820DB0E3264358462D64Fda4362133";
    var account2 = accounts[1];
    var totalSupply;

  //Test Initial Owner Balance
  it("should put 0 DagtCrowdsale in the first account", function() {
    return DagtCrowdsale.deployed().then(function(instance) {
      return instance.getBalance.call(accounts[0]);
    }).then(function(balance) {
      assert.equal(balance.valueOf(), 0, "0 wasn't in the first account");
    });
  });
  //
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

  //Test setBlocksRate
  it("should put valid DAGT in the arry of blocksRanges blocksRanges and rates", function() {
    var dagt;
    var rate;
    return DagtCrowdsale.deployed().then(function(instance) {
        dagt = instance;
        return dagt.setBlocksRate([2840652,2908683,2909223,2970937,2977794,3039509,3048012,3108080,3121795,3149223],
                 [1700,1600,1400,1240,1118]);
      }).then(function() {
        return dagt.getETH2DAGTRate();
      }).then(function(ret) {
        console.log(ret)        
      });
  });


  //Test setRewardRange
  it("should put valid DAGT in the arry of blocksRewarRanges _blocksNums 、_extraRewardRanges and _rewards", function() {
    var dagt;
    return DagtCrowdsale.deployed().then(function(instance) {
        dagt = instance;
        return dagt.setRewardRange([2840652,3149223],[200,299,300,499,500,1000000000],[5,10,15]);
      }).then(function() {
        return dagt.amountReward(150000);
      }).then(function(ret) {
        console.log(ret)        
      }).then(function(ret) {
        return dagt.transfer(account1, 1000 * (10 ** 18), {from: owner});     
      }).then(function(ret) {
        return dagt.balanceOf.call(account1);    
      }).then(function(ret) {
        console.log("balanceOf:"+ret)
      });
  });

   //Test WhiteList
  it("should put valid DAGT in the arry of blocksRewarRanges _blocksNums 、_extraRewardRanges and _rewards", function() {
    var dagt;
    return DagtCrowdsale.deployed().then(function(instance) {
        dagt = instance;
        return dagt.whitelistAddresses([0xfc2eE3eCbF820DB0E3264358462D64Fda4362133]);
      }).then(function() {
        return dagt.isWhitelisted([0xfc2eE3eCbF820DB0E3264358462D64Fda4362133]);
      }).then(function(ret) {
        console.log("isWhitelisted:"+ret)    
         return dagt.unwhitelistAddress([0xfc2eE3eCbF820DB0E3264358462D64Fda4362133]);    
      }).then(function(ret) {
         return dagt.isWhitelisted([0xfc2eE3eCbF820DB0E3264358462D64Fda4362133]);        
      }).then(function(ret) {
          console.log("isWhitelisted:"+ret)         
      });
  });

  //Test transfer
  it("should put valid DAGT in the account of account1 and account2", function() {
    var dagt;
    return DagtCrowdsale.deployed().then(function(instance) {
        dagt = instance;
        return dagt.transfer(account1, 1000 * (10 ** 18), {from: owner});
      }).then(function(ret) {
        return dagt.transfer(account2, 5000 * (10 ** 18), {from: owner});
      }).then(function(ret) {
        return dagt.totalSupply.call();
      }).then(function(balance) {
        totalSupply = balance.valueOf();
        assert.equal(totalSupply, (10 ** 8) * (10 ** 18), "Total supply  has " + (10 ** 8) * (10 ** 18) + " DAGT");
        return dagt.balanceOf.call(account1);
      }).then(function(balance1) {
        assert.equal(balance1.valueOf(), 1000 * (10 ** 18), "Account1 is right");
        return dagt.balanceOf.call(account2);
      }).then(function(balance2) {
        assert.equal(balance2.valueOf(), 5000 * (10 ** 18), "Account2 is right");
        return dagt.balanceOf.call(owner);
      }).then(function(balanceOwner) {
        assert.equal(balanceOwner.valueOf(), 9.9994e+25, "Owner is right");
      });
  });

  //Test approve and transferFrom
  it("should approve the valid allowance", function() {
      var dagt;

       return dagt.deployed().then(function(instance) {
          dagt = instance;
          return dagt.approve(account1, 10000 * (10 ** 18), {from: account2});
      }).then(function(ret) {
          return dagt.allowance.call(account2, account1);
      }).then(function(allowance) {
          assert.equal(allowance.valueOf(), 10000 * (10 ** 18), "account2 gives account1 " +  4000 * (10 ** 18) + " tokens");
          return dagt.approve(account1, 0, {from: account2});
      }).then(function(ret) {
          return  dagt.allowance.call(account2, account1);
      }).then(function(allowance) {
          assert.equal(allowance.valueOf(), 0, "account2 give account1 " + 0 + " tokens");
          return dagt.approve(account1, 10000 * (10 ** 18), {from: account2});
      }).then(function(ret) {
          return dagt.transferFrom(account2, account1, 2000 * (10 ** 18), {from: account1});
      }).then(function(ret) {
          return dagt.balanceOf.call(account1);
      }).then(function(balance1) {
          assert.equal(balance1.valueOf(), 3000 * (10 ** 18), "Account1 is right");
          return dagt.balanceOf.call(account2);
      }).then(function(balance2) {
          assert.equal(balance2.valueOf(), 3000 * (10 ** 18), "Account2 is right");
          return dagt.allowance.call(account2, account1);
      }).then(function(allowance) {
          assert.equal(allowance.valueOf(), 8000 * (10 ** 18), "account2 gives account1 " +  8000 * (10 ** 18) + " tokens");
          return dagt.totalSupply.call();
      }).then(function(totalSupply) {
          assert.equal(totalSupply.valueOf(), (10 ** 8) * (10 ** 18), "Total supply  has " + (10 ** 8) * (10 ** 18) + " tokens");
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
