// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');
  console.log('💪 deployment started');

  // We get the contract to deploy
  const Settings = await hre.ethers.getContractFactory("contracts/Settings.sol:Settings"); // deploy first, no constructor param dependency
  const settings = await Settings.deploy(); //constructor param inside () here
  //await Settings.deployed();
  const settingsAddress = settings.address;
  console.log("💪💪 Settings deployed to:", settingsAddress);

  const ERC721TokenVault = await hre.ethers.getContractFactory("TokenVault");
  const eRC721TokenVault = await ERC721TokenVault.deploy(settingsAddress); //constructor param inside () here
  //await ERC721TokenVault.deployed();
  console.log("💪💪 ERC721TokenVault deployed to:", eRC721TokenVault.address);

  const ERC721VaultFactory = await hre.ethers.getContractFactory("ERC721VaultFactory");
  const eRC721VaultFactory  = await ERC721VaultFactory .deploy(settingsAddress); //constructor param inside () here
  //await ERC721VaultFactory .deployed();
  console.log("💪💪 ERC721VaultFactory deployed to:", eRC721VaultFactory.address);

  const IndexERC721Factory = await hre.ethers.getContractFactory("IndexERC721Factory");
  const indexERC721Factory = await IndexERC721Factory.deploy(); //constructor param inside () here
  //await IndexERC721Factory.deployed();
  console.log("💪💪 IndexERC721Factory deployed to:", indexERC721Factory.address);

//   const InitializedProxy = await hre.ethers.getContractFactory("InitializedProxy");
//   const initializedProxy = await InitializedProxy.deploy(); //constructor param inside () here
//   //await InitializedProxy.deployed();
//   console.log("💪💪 InitializedProxy deployed to:", initializedProxy.address);

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
