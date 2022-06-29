require('dotenv').config();
const { ethers } = require('ethers');

const contractAddress = "0xbaCCd71C5E48a55C86f3efe4b9E45eBcC75826d4";
const artifact = require("../artifacts/contracts/FunzofiFactory.sol/FunzofiFactory.json")
const providerOrUrl = {
    mumbai: process.env.MUMBAI,
    rinkeby : process.env.RINKEBY
}

let provider = new ethers.providers.JsonRpcProvider(providerOrUrl['mumbai']);
const signer = new ethers.Wallet(process.env.PVT_KEY, provider);
const contract_write = new ethers.Contract(contractAddress, artifact.abi, signer);
const fee = ethers.utils.parseEther("1.0");

async function callContract() {
    await contract_write.createGame("CSK v/s K", "test game n", fee, [
        ['id01','dhoni', 0, true],
        ['id02','mahi', 0, true],
        ['id03','virat', 0, true],
        ['id04','chahal', 0, true],
        ['id05','sachin', 0, true],
        ['id06','yuvraj', 0, true],
        ['id07','shami', 0, true],
        ['id08','kale', 0, true],
    ]).catch(err => {
        console.log(err);
    });

    
}


async function main(){
    await callContract();
    console.log("completed");
}

main()
  .catch(err => {
      console.error(err)
      process.exit(1)
})
