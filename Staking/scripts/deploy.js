const hre = require("hardhat");
//npx hardhat run --network localhost scripts/deploy.js 

async function main() {
  // const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  // const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
  // const unlockTime = currentTimestampInSeconds + ONE_YEAR_IN_SECS;
  // const lockedAmount = hre.ethers.utils.parseEther("1");

  const token = await hre.ethers.getContractFactory("TestStakingToken");
  const TSTtoken = await token.deploy();
  await TSTtoken.deployed();

  const stake = await hre.ethers.getContractFactory("Staking");
  const Staking = await stake.deploy(TSTtoken.address);
  await Staking.deployed();


  console.log(
   "Token address=>" , TSTtoken.address,"Staking address=>", Staking.address
  );


}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
