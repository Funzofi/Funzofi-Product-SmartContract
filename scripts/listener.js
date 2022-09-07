require('dotenv').config();
const { ethers } = require('ethers');

const contractAddress = "0x69564e027017eDA06E3Fd1dd06008AA6eeB4c81c";
const artifact = require("../artifacts/contracts/FunzofiFactory.sol/FunzofiFactory.json")
const providerOrUrl = {
    mumbai: process.env.MUMBAI,
    rinkeby : process.env.RINKEBY
}

async function callContract() {
    let provider = new ethers.providers.JsonRpcProvider(providerOrUrl['rinkeby']);
    const signer = new ethers.Wallet(process.env.PVT_KEY, provider);
    const contract_write = new ethers.Contract(contractAddress, artifact.abi, signer);

    contract_write.on("GameCreated", async (id, address) =>{
        const data = ethers.BigNumber.from(id).toNumber();
        console.log("Current deployed game id : ", data, ", address : ", address);      
    });
}


async function main(){
    await callContract();
}

main()
  .catch(err => {
      console.error(err)
      process.exit(1)
})
