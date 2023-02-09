const hre = require("hardhat");

async function main() {
 
  console.log('💪 deployment of ERC20DutchAuction started');

  // We get the contract to deploy
  const ERC20DutchAuction = await hre.ethers.getContractFactory("ERC20DutchAuction"); // deploy first, no constructor param dependency
  
  const erc20DutchAuction = await ERC20DutchAuction.deploy(); //constructor param inside () here
  //await Settings.deployed();
  const erc20DutchAuctionAddress = erc20DutchAuction.address;
  console.log("💪💪 ERC20DutchAuction deployed to:", erc20DutchAuctionAddress);
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
