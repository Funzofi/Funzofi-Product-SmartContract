const { expect, assert }  = require("chai");
const { ethers }          = require("hardhat");

let contract;
let accounts;

beforeEach( async () => {
  accounts      = await ethers.getSigners();
  const Funzofi = await ethers.getContractFactory("Funzofi");
  contract      = await Funzofi.deploy("CSK vs KKR", "test description", 1, ['dhoni', 'mahi', 'chahal', 'sachin']);
  await contract.deployed();
});

describe("Funzofi Contract Tests", () => {
  it("Deployment Test and Data Check", async () => {
    const name      = await contract.name();
    const details   = await contract.gameDetails();
    const entryFee  = await contract.entryFee();
    const player1   = await contract.players('dhoni');
    const player2   = await contract.players('test');

    assert(name == 'CSK vs KKR' && details == 'test description' && entryFee == 1);
    expect(player1.present).to.equal(true);
    expect(player1.score).to.equal(0);
    expect(player2.present).to.equal(false);
  });

  it("Owner Check", async () => {
    expect(await contract.owner()).to.equal(accounts[0].address);
  });

  it("Game Status Check", async () => {
    expect(await contract.gameStatus()).to.equal(0);
  });

  it("Game start function", async () => {
    await contract.startGame();
    expect(await contract.gameStatus()).to.equal(1);
  });

  it("Entry function", async () => {
    team = ['dhoni', 'mahi', 'sachin'];
    await contract.startGame();
    await contract.connect(accounts[1]).enterGame(
      team,
      {"value" : ethers.utils.parseEther("1.0")}
    );
    expect(await contract.connect(accounts[1]).users(accounts[1].address)).to.equal(1);
  });

});
