import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require('dotenv').config()


module.exports = {
  solidity: "0.8.17",
  networks: {
    baobab: {
      url: process.env.KLAYTN_BAOBAB_URL || "",
      gasPrice: 250000000000,
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    }
  }
};

const config: HardhatUserConfig = {
  solidity: "0.8.19",
};

export default config;
