const HDWalletProvider = require("truffle-hdwallet-provider-klaytn");

const config = require("./config");
const URL = "https://api.baobab.klaytn.net:8651"; // TestNet
// const URL = 'https://api.cypress.klaytn.net:8651'; // MainNet

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*", // Match any network id
    },
    testnet: {
      provider: () => {
        return new HDWalletProvider(
          config.privateKey,
          URL,
          0,
          config.privateKey.length
        );
      },
      network_id: "1001", //Klaytn baobab testnet's network id
      gas: "8500000",
      gasPrice: null,
    },
    mainnet: {
      provider: () => new HDWalletProvider(config.privateKey, URL),
      network_id: "8217", //Klaytn mainnet's network id
      gas: "8500000",
      gasPrice: null,
    },
  },
  compilers: {
    solc: {
      version: "0.5.6",
    },
  },
};
