首先开启testrpc
------
1.	truffle compile
2.	truffle migrate --reset
3.	truffle console
4.	let contract
5. 	DagtPri.deployed().then(instance => contract = instance)
6.
    contract.setLockMonth.call(1)
	  contract.getDAGTRate.call()
	

 web3.eth.coinbase
 contract.balanceOf(web3.eth.coinbase)
 contract.balanceOf(web3.eth.accounts[1])
 contract.transfer(web3.eth.accounts[1], 1)
 contract.mint(web3.eth.accounts[1], 1)
 web3.eth.getBlock(0)
