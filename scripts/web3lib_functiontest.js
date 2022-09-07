const Web3 = require('web3');
const HDWalletProvider = require("@truffle/hdwallet-provider");
require('dotenv').config();

const contractAddress = "0x52400fC05F4cf166305353f0fac175A2D85331fC";
const artifact = require("../artifacts/contracts/Funzofi.sol/Funzofi.json")
const providerOrUrl = {
    mumbai: process.env.MUMBAI,
    rinkeby : process.env.RINKEBY
}

let provider = new HDWalletProvider({
    privateKeys: [process.env.PVT_KEY],
    providerOrUrl: providerOrUrl['rinkeby'],
});

async function callContract(){
    const web3 = new Web3(provider);
    const accounts = await web3.eth.getAccounts();
    const fee = Web3.utils.toWei('1', 'ether');
    const contract = new web3.eth.Contract(artifact.abi, contractAddress);
    // team1 = ['id01', 'id02', 'id05'];
    // team2 = ['id02', 'id04'];
    // team3 = ['id05', 'id04'];
    // team4 = ['id04'];
    // await contract.methods.startGame().send({
    //     from: accounts[0],
    // }).catch(err => {
    //     console.log(err);
    // });
    // await contract.methods.enterGame(
    //     team3,
    //     {"value" : ethers.utils.parseEther("1.0")}
    // ).send({
    //     from: accounts[0],
    //     value : fee,
    // }).catch(err => {
    //     console.log(err);
    // });
    const data = await contract.methods.getEntriesList().call({
        from : accounts[0],
    }).catch(err => {
        console.log(err);
    });
    console.log(data);
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