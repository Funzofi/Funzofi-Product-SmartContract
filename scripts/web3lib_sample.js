const Web3 = require('web3');
const HDWalletProvider = require("@truffle/hdwallet-provider");
require('dotenv').config();

const contractAddress = "0xbaCCd71C5E48a55C86f3efe4b9E45eBcC75826d4";
const artifact = require("../artifacts/contracts/FunzofiFactory.sol/FunzofiFactory.json")
const providerOrUrl = {
    mumbai: process.env.MUMBAI,
    rinkeby : process.env.RINKEBY
}

let provider = new HDWalletProvider({
    privateKeys: [process.env.PVT_KEY],
    providerOrUrl: providerOrUrl['mumbai'],
});


async function callContract(){
    const web3 = new Web3(provider);
    const accounts = await web3.eth.getAccounts();
    const fee = Web3.utils.toWei('1', 'ether');
    const contract = new web3.eth.Contract(artifact.abi, contractAddress);
    await contract.methods.createGame("CSK v/s K", "test game n", fee, [
        ['id01','dhoni', 0, true],
        ['id02','mahi', 0, true],
        ['id03','virat', 0, true],
        ['id04','chahal', 0, true],
        ['id05','sachin', 0, true],
        ['id06','yuvraj', 0, true],
        ['id07','shami', 0, true],
        ['id08','kale', 0, true],
    ]).send({
        from: accounts[0],
    })
    .catch(err => {
        console.log(err);
    });
}

async function main(){
    await callContract();
    console.log("completed");

    provider.engine.stop();
}

main()
  .catch(err => {
      console.error(err)
      process.exit(1)
})