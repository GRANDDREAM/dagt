App = {
  web3Provider: new Web3.providers.HttpProvider('https://ropsten.infura.io/'),
  contracts: {},

  init: function() {
    return App.initWeb3();
  },

  initWeb3: function() {
    // Initialize web3 and set the provider to the testRPC.
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    } else {
      // set the provider you want from Web3.providers
      App.web3Provider = new Web3.providers.HttpProvider('http://127.0.0.1:9545');
      web3 = new Web3(App.web3Provider);
    }

    return App.initContract();
  },

  initContract: function() {
    $.getJSON('Dagt.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract.
      var DagtArtifact = data;
      App.contracts.Dagt = TruffleContract(DagtArtifact);

      // Set the provider for our contract.
      App.contracts.Dagt.setProvider(App.web3Provider);

      // Use our contract to retieve and mark the adopted pets.
      return App.getBalances();
    });

    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '#transferButton', App.handleTransfer);
  },

  handleTransfer: function(event) {
    event.preventDefault();

    var amount = parseInt($('#TTTransferAmount').val());
    var toAddress = $('#TTTransferAddress').val();

    console.log('Transfer ' + amount + ' DAGT to ' + toAddress);

    var dagtInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = "0x8154fE1Fe5Db5e7916a004a7B9a1121CFA9aDaAa";

      App.contracts.Dagt.deployed().then(function(instance) {
        dagtInstance = instance;

        return dagtInstance.transfer(toAddress, amount, {from: account});
      }).then(function(result) {
        alert('Transfer Successful!');
        return App.getBalances();
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  },

  getBalances: function() {
    console.log('Getting balances...');

    var dagtInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = "0x8154fE1Fe5Db5e7916a004a7B9a1121CFA9aDaAa";

      App.contracts.Dagt.deployed().then(function(instance) {
        dagtInstance = instance;

        return dagtInstance.balanceOf(account);
      }).then(function(result) {
        balance = result.c[0];

        $('#TTBalance').text(balance);
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  }

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
