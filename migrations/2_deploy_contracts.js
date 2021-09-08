const fs = require("fs");
const Vote = artifacts.require("./Vote.sol");

module.exports = function (deployer) {
  deployer.deploy(Vote).then(() => {
    if (Vote._json) {
      fs.writeFile("deployedABI", JSON.stringify(Vote._json.abi), (err) => {
        if (err) throw err;
        console.log("Success Write ABI Content");
      });

      fs.writeFile("deployedAddress", Vote.address, (err) => {
        if (err) throw err;
        console.log("Success Write Address Content");
      });
    }
  });
};
