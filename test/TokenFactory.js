const { expect } = require("chai");

const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

describe("Token Factory", function () {
 
  async function deployTokenFixture() {
    // Get the ContractFactory and Signers here.
    const TokenFactory = await ethers.getContractFactory("TokenFactory");
    const [owner, addr1, addr2] = await ethers.getSigners();

    // To deploy our contract.
    const tokenFactory = await TokenFactory.deploy();

    await tokenFactory.deployed();

    return { TokenFactory, tokenFactory, owner, addr1, addr2 };
  }

  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      const { tokenFactory, owner } = await loadFixture(deployTokenFixture);
      expect(await tokenFactory.owner()).to.equal(owner.address);
    });

  });
  
});