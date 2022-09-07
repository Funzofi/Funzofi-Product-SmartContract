const { expect, assert }  = require("chai");
const { ethers }          = require("hardhat");

let contract;
let accounts;

beforeEach( async () => {
  accounts      = await ethers.getSigners();
  const Funzofi = await ethers.getContractFactory("Funzofi");
  contract      = await Funzofi.deploy(
    "CSK vs KKR", "test description", 
    ethers.utils.parseEther("1.0"), 
    [
      ['id01','dhoni', 0, true],
      ['id02','mahi', 0, true],
      ['id03','virat', 0, true],
      ['id04','chahal', 0, true],
      ['id05','sachin', 0, true],
      ['id06','yuvraj', 0, true],
      ['id07','shami', 0, true],
      ['id08','kale', 0, true],
    ]
  );
  await contract.deployed();
});

describe("Funzofi Contract Tests", () => {
  it("Deployment Test and Data Check", async () => {
    const name      = await contract.name();
    const details   = await contract.gameDetails();
    const entryFee  = ethers.utils.formatEther(await contract.entryFee());
    const player1   = await contract.players('id01');
    const player2   = await contract.players('id00');

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
    team = ['id01', 'id02', 'id03'];
    await contract.startGame();
    await contract.connect(accounts[1]).enterGame(
      team,
      {"value" : ethers.utils.parseEther("1.0")}
    );
    expect(await contract.connect(accounts[1]).users(accounts[1].address)).to.equal(1);
  });

  it("Update Score Check", async () => {
    await contract.startGame();
    await contract.updateScore([
      ['id01','dhoni', 20, true],
      ['id02','mahi', 10, true],
      ['id03','virat', 0, true],
    ]);

    const player1 = await contract.players('id01');
    const player2 = await contract.players('id03');
    const player3 = await contract.players('id02');

    expect(player1.score).to.equal(20);
    expect(player2.score).to.equal(0);
    expect(player3.score).to.equal(10);
  });

  it("Endgame result check", async () => {
    team = ['id03', 'id02', 'id01'];
    await contract.startGame();
    await contract.connect(accounts[1]).enterGame(
      team,
      {"value" : ethers.utils.parseEther("1.0")}
    );

    await contract.updateScore([
      ['id01','dhoni', 20, true],
      ['id02','mahi', 10, true],
    ]);

    await contract.endGame();
    expect(await contract.gameStatus()).to.equal(3);
    const entryData = await contract.entries(0);
    expect(entryData.score).to.equal(30);
    
  });

  it("Winner declaration check", async () => {
    team1 = ['id01', 'id02', 'id05'];
    team2 = ['id02', 'id04'];
    team3 = ['id05', 'id04'];
    team4 = ['id04'];
    await contract.startGame();
    await contract.connect(accounts[3]).enterGame(
      team3,
      {"value" : ethers.utils.parseEther("1.0")}
    );
    await contract.connect(accounts[2]).enterGame(
      team2,
      {"value" : ethers.utils.parseEther("1.0")}
    );
    await contract.connect(accounts[4]).enterGame(
      team4,
      {"value" : ethers.utils.parseEther("1.0")}
    );
    await contract.connect(accounts[1]).enterGame(
      team1,
      {"value" : ethers.utils.parseEther("1.0")}
    );

    await contract.updateScore([
      ['id01','dhoni', 20, true],
      ['id02','mahi', 10, true],
      ['id04','chahal', 5, true],
      ['id05','sachin', 2, true],
    ]);

    await contract.endGame();
    await contract.getWinnersList();
    const data = await contract.getResultList();
    expect(data[0].score).to.equal(32);
  });

});