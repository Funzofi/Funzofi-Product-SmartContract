const { expect, assert }  = require("chai");
const { ethers }          = require("hardhat");

let contract;
let accounts;
let FactoryContract;
let CricketChildFactory;
let CricketChildContract;

// deployment of the factory contract 
beforeEach( async () => {
    accounts                = await ethers.getSigners();
    FactoryContract          = await ethers.getContractFactory("CricketFactory");
    CricketChildFactory     = await ethers.getContractFactory("Cricket");
    contract                = await FactoryContract.deploy();
    await contract.deployed();

    await contract.createGame(
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

    const addr              = await contract.CricketGames(0);
    CricketChildContract    = CricketChildFactory.attach(addr);
});

describe("Cricket Factory Contract Tests", () => {
    it("Deployment & Owner Check", async () => {
        const owner = await contract.owner();
        expect(owner).to.equal(accounts[0].address);
    });
    
    it("Cricket Child Deployment Check", async () => {
        try {
            await contract.createGame(
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
            assert(true);
        } catch (err) {
            assert(false, err);
        }
        
        const name = await CricketChildContract.name();
        expect(name).to.equal("CSK vs KKR");
        
    });

    it("StartGame function check in factory format", async () => {
        try {
            await contract.startGame(0);
            assert(true);
        } catch (err) {
            assert(false, err);
        }

        const gameStat = await CricketChildContract.gameStatus();
        expect(gameStat).to.equal(1);
    });

    it("Getgames function check for factory", async () => {
        await contract.createGame(
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
        const data = await contract.getGames();
        expect(data.length).to.equal(2);
    });

    it("Update score function check in factory format", async () => {
        try {
            await contract.startGame(0);
            await contract.updateScore(0, [
                ['id01','dhoni', 20, true],
                ['id02','mahi', 10, true],
                ['id03','virat', 0, true],
            ]);
            assert(true);
        } catch (err) {
            assert(false, err);
        }

        const player1 = await CricketChildContract.players('id01');
        const player2 = await CricketChildContract.players('id03');
        const player3 = await CricketChildContract.players('id02');

        expect(player1.score).to.equal(20);
        expect(player2.score).to.equal(0);
        expect(player3.score).to.equal(10);
    });

});