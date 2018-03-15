// module.exports = {
//   // See <http://truffleframework.com/docs/advanced/configuration>
//   // for more about customizing your Truffle configuration!
//   networks: {
//     development: {
//       host: "127.0.0.1",
//       port: 8545,
//       network_id: "*" // Match any network id
//     }
//   }
// };

// module.exports = {
//   networks: {
//     development: {
//       host: "localhost",
//       port: 8545,
//       network_id: "*" // Match any network id
//     },
//      ropsten:  {
//      network_id: 3,
//      host: "localhost",
//      port:  8545,
//      gas:   2900000
//     }
//   },
//   rpc: {
//     host: 'localhost',
//     post:8080
//   }
// };

var HDWalletProvider = require("truffle-hdwallet-provider");

var infura_apikey = "yXxYEFUojdEzpVGtkz0v";
var mnemonic = "rely skin athlete acoustic slight later improve blue brass party voice priority";

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    ropsten: {
      provider: new HDWalletProvider(mnemonic, "https://ropsten.infura.io/"+infura_apikey),
      network_id: 3,
      gas:   2900000
    }
  }
};