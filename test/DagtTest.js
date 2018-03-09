let DagtPri = artifacts.require('contracts/DagtPri.sol');


contract('DagtPri', function(accounts) {


    let dagtPri;

  //  const tokenAmount = 30 * 10 ** 18;

    beforeEach(async () => {

        //dagtPri = await DagtPri.new({from: accounts[0]});
        dagtPri = await DagtPri.new({from: accounts[0]});
        await dagtPri.mint(dagtPri.address, {from: accounts[0]});
    });


    it("Deploys contract with correct hardcap", async function() {

       await dagtPri.getDAGTRate().call();


   });

    it("Owner can allocate tokens", async function() {
  /*
        await controller.allocateTokens(accounts[1], 100, {from: accounts[0]});

        let circulation = await token.currentlyInCirculation.call();

        assert.equal(100, circulation);

        assert.equal(100, await token.balanceOf(accounts[1]));*/

    });

});
