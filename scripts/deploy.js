const { ethers } = require("hardhat")

async function main(params) {
    const [deployer] = await ethers.getSigners()

    const TheDAO = await ethers.getContractFactory("TheDAO")
    const theDao = await TheDAO.deploy()
    console.log("Contract deployed to:", theDao.target);

}

main().catch((error) => {
    console.error(error)
    process.exit(1)
})