const { ethers } = require("hardhat")

async function main(params) {

    const AdditionalLibrary = await ethers.getContractFactory("ArraysPlus");
    const additionalLibrary = await AdditionalLibrary.deploy()

    const TheDAO = await ethers.getContractFactory("TheDAO", {
        libraries: {
            ArraysPlus: additionalLibrary.target,
        }
    })
    const theDao = await TheDAO.deploy(1000)
    console.log("Contract deployed to:", theDao.target);

}

main().catch((error) => {
    console.error(error)
    process.exit(1)
})