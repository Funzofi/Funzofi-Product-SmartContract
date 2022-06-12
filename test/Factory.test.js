const { expect, assert }  = require("chai");
const { ethers }          = require("hardhat");

let contract;
let accounts;

// deployment of the factory contract 
beforeEach( async () => {
    accounts                = await ethers.getSigners();
    const FunzofiFactory    = await ethers.getContractFactory("FunzofiFactory");
    contract                = await FunzofiFactory.deploy();
    await contract.deployed();
});

describe("Factory Contract Tests", () => {
    it("Deployment & Owner Check", async () => {
        const owner = await contract.owner();
        expect(owner).to.equal(accounts[0].address);
    });
    
    it("Funzofi Child Deployment Check", async () => {
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
        
    });

});

