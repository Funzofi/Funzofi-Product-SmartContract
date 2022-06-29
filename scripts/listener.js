require('dotenv').config();
const { ethers } = require('ethers');

const contractAddress = "0xbaCCd71C5E48a55C86f3efe4b9E45eBcC75826d4";
const artifact = require("../artifacts/contracts/FunzofiFactory.sol/FunzofiFactory.json")
const providerOrUrl = {
    mumbai: process.env.MUMBAI,
    rinkeby : process.env.RINKEBY
}

async function callContract() {
    let provider = new ethers.providers.JsonRpcProvider(providerOrUrl['mumbai']);
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
