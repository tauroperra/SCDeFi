const { expect } = require("chai");

const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

describe("ERC721 Vault Factory", function () {
 
  async function deployVaultFixture() {
    // Get the ContractFactory and Signers here.
    const ERC721VaultFactory = await ethers.getContractFactory("ERC721VaultFactory");
    const [owner, addr1, addr2] = await ethers.getSigners();

    // To deploy our contract.
    const erc721VaultFactory = await ERC721VaultFactory.deploy();

    await erc721VaultFactory.deployed();

    return { ERC721VaultFactory, erc721VaultFactory, owner, addr1, addr2 };
  }

  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      const { erc721VaultFactory, owner } = await loadFixture(deployVaultFixture);
      expect(await erc721VaultFactory.owner()).to.equal(owner.address);
    });

  });
  
});