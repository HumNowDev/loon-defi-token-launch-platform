const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying with account:", deployer.address);

  const Loon = await hre.ethers.getContractFactory("Loon");

  const initialSupply = hre.ethers.parseEther("1000000"); // 1M LOON
  const maxSupply = hre.ethers.parseEther("5000000"); // 5M LOON cap

  const loon = await Loon.deploy(initialSupply, maxSupply);
  await loon.waitForDeployment();

  console.log("Loon deployed to:", await loon.getAddress());
}

main()
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
