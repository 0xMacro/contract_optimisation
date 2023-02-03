require("@nomiclabs/hardhat-waffle");
require("hardhat-gas-reporter");
/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.17",
  gasReporter: {
    enabled: true,
    currency: "USD",
  },
}
