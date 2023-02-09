const hre = require("hardhat");

async function main() {
 
  console.log('💪 deployment of LsDfDutchAuction started');

  // We get the contract to deploy
  const LsaDutchAuction = await hre.ethers.getContractFactory("LsaDutchAuction"); // deploy first, no constructor param dependency
  
  const lsaDutchAuction = await LsaDutchAuction.deploy(10000000, 1, "0xcd9cdE25a9eA582246067bDbDf0E3BB66d4cd8F2", 0 ); //constructor param inside () here
  //await Settings.deployed();
  const lsaDutchAuctionAddress = lsaDutchAuction.address;
  console.log("💪💪 lsaDutchAuction deployed to:", lsaDutchAuctionAddress);
  console.log('💪 deployment complete!');
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
