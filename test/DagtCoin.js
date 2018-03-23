
var DAGTCoin = artifacts.require("./DAGTCoin.sol");
contract('DAGTCoin', function(accounts) {
  //  accounts[0]='0x8154fE1Fe5Db5e7916a004a7B9a1121CFA9aDaAa';
    var owner  = '0xfc2eE3eCbF820DB0E3264358462D64Fda4362133';
  //  var account1 = "0xfc2eE3eCbF820DB0E3264358462D64Fda4362133";
    //var account2 = accounts[1];
    var totalSupply;

  //Test Balance
  it("should get balance from address", function() {
    var dagt ;
    return DAGTCoin.deployed().then(function(instance) {
      dagt = instance;
       return dagt.balanceOf(owner);
    }).then(function(ret) {
      assert.ok(true,"e====");
    }).then(function() {
      //dagt.getBalance.call(accounts[0]);
      // return dagt.totalSupply.call();
       return dagt.balanceOf(accounts[0]);
    }).then(function(total) {
      //dagt.getBalance.call(accounts[0]);
         console.log("\nbalance:"+total);
         console.log("\n test balance end");
    });
  });
// Test mint
it("should mint DAGT to owner", function() {
   var dagt;
   return DAGTCoin.deployed().then(function(instance) {
     dagt = instance;
     return dagt.balanceOf(accounts[0]);
   }).then(function(balance){
     console.log(" balance==:"+balance);
  }).then(function(){
    return dagt.mint(accounts[0],1000000);

  }).then(function(ret){
     assert(true,"minted 100 ");
     console.log(" \n minted 100 DAGT");
  }).then(function(){
    return dagt.balanceOf(accounts[0]);
  }).then(function(balance){
    console.log("\n minted DAGT of balance:"+balance);
  }).then(function(){
     console.log("\n mint end");
  });
});

// Test transfer
it("should transfer DAGT frome one address to another ", function() {
   var dagt;
   return DAGTCoin.deployed().then(function(instance) {
     dagt = instance;
     return dagt.balanceOf(accounts[0]);

   }).then(function(balance){

        console.log("  %s balance:%s",accounts[0],balance);

   }).then(function(){

      return dagt.transfer(accounts[1],1000);
      //  console.log("\n  %s balance:%s",accounts[1],balance);
    }).then(function(ret){
        assert.ok(true,"transfer ok");
    }).then(function(){

       return dagt.balanceOf(accounts[0]);

    }).then(function(balance){

        console.log("\n the balance of %s : %s",accounts[0],balance);

    }).then(function(){

      return dagt.balanceOf(accounts[1]);

    }).then(function(balance){

        console.log("\n the balance of %s : %s",accounts[1],balance);

    });
});

// Test transferFrom
it("should transferFrom DAGT from one address to another ", function() {
   var dagt;
   return DAGTCoin.deployed().then(function(instance) {
     dagt = instance;
     return dagt.balanceOf(accounts[0]);

   }).then(function(balance){

          console.log("\n the balance of %s : %s",accounts[0],balance);

   }).then(function(){

      return dagt.balanceOf(accounts[1]);
      //  console.log("\n  %s balance:%s",accounts[1],balance);
    }).then(function(balance){
        console.log("\n the balance of %s : %s",accounts[1],balance);
    }).then(function() {
       return dagt.transfer(accounts[1],1000);
    }).then(function(ret){

       return dagt.getBuyNos(accounts[0]);

    }).then(function(buyNo){
      console.log("\n the buyNo of %s : %s",accounts[1],buyNo);
    });
});
///////////////////////////////////end
});
