const { expect } = require("chai");
const { ethers } = require("hardhat");

let contract;
let accounts;

beforeEach( async () => {
  accounts = await ethers.getSigners();
  const Funzofi = await ethers.getContractFactory("Funzofi");
  contract = await Funzofi.deploy("CSK vs KKR", "test description");
  await contract.deployed();
});

describe("Funzofi Contract Tests", () => {
  it("Deployment Test and Data Check", async () => {
      expect(await contract.name()).to.equal("CSK vs KKR");
    });

  it("Owner Check", async () => {
      expect(await contract.owner()).to.equal(accounts[0].address);
  });
});
