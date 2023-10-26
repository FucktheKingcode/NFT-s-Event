import { ethers } from "hardhat";

async function main() {

    const deployerAddr = "0xE633Edce68f4f31A8108f50e1A189e840C1B9fD5";
    const deployer = await ethers.getSigner(deployerAddr);

    console.log(`Deploying contracts with the account: ${deployer.address}`);
    console.log(`Account balance: ${(await ethers.provider.getBalance(deployerAddr)).toString()}`);

    const SoulBoundTokenFactory = await ethers.getContractFactory("SoulBoundToken");
    const sbtContract = await SoulBoundTokenFactory.deploy();


    console.log(`Congratulations! You have just successfully deployed your soul bound tokens.`);
    console.log(`You can verify on https://baobab.scope.klaytn.com/account/${(await sbtContract.getAddress()).toString()}`);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});