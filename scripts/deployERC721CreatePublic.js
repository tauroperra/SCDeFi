const hre = require("hardhat");

async function main() {
 
  console.log('💪 deployment of ERC721CreatePublic started');

  // We get the contract to deploy
  const ERC721Create = await hre.ethers.getContractFactory("ERC721CreatePublic"); // deploy first, no constructor param dependency
  const erc721Create = await ERC721Create.deploy("LisaNFTPublic", "LNFp"); //constructor param inside () here
  //await Settings.deployed();
  const erc721CreateAddress = erc721Create.address;
  console.log("💪💪 ERC721CreatePublic deployed to:", erc721CreateAddress);
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
