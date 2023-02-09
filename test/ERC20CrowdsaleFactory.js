const { expect } = require("chai");

const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

describe("ERC20 Crowdsale Factory", function () {
 
  async function deployCrowdsaleFixture() {
    // Get the ContractFactory and Signers here.
    const ERC20CrowdsaleFactory = await ethers.getContractFactory("ERC20CrowdsaleFactory");
    const [owner, addr1, addr2] = await ethers.getSigners();

    // To deploy our contract.
    const erc20CrowdsaleFactory = await ERC20CrowdsaleFactory.deploy();

    await erc20CrowdsaleFactory.deployed();

    return { ERC20CrowdsaleFactory, erc20CrowdsaleFactory, owner, addr1, addr2 };
  }

  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      const { erc20CrowdsaleFactory, owner } = await loadFixture(deployCrowdsaleFixture);
      expect(await erc20CrowdsaleFactory.owner()).to.equal(owner.address);
    });

  });
  
});