const { expect, assert }  = require("chai");
const { ethers }          = require("hardhat");

let contract;
let accounts;

beforeEach( async () => {
  accounts      = await ethers.getSigners();
  const Funzofi = await ethers.getContractFactory("Funzofi");
  contract      = await Funzofi.deploy("CSK vs KKR", "test description", 20, ['dhoni', 'mahi']);
  await contract.deployed();
});

describe("Funzofi Contract Tests", () => {
  it("Deployment Test and Data Check", async () => {
    const name      = await contract.name();
    const details   = await contract.gameDetails();
    const entryFee  = await contract.entryFee();
    const player1   = await contract.players('dhoni');
    const player2   = await contract.players('test');

    assert(name == 'CSK vs KKR' && details == 'test description' && entryFee == 20);
    expect(player1.present).to.equal(true);
    expect(player1.score).to.equal(0);
    expect(player2.present).to.equal(false);
  });

  it("Owner Check", async () => {
    expect(await contract.owner()).to.equal(accounts[0].address);
  });
});
