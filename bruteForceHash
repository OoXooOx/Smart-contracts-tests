const { ethers } = require("hardhat");
const { BigNumber } = require("ethers");

const targetHash = "0x16f21ac3";

function bruteForceHash() {
  let found = false;
  let attempts = 0;

  const uint32Max = BigNumber.from(2).pow(32).sub(1);

  // Loop from 0 to uint32Max
  for (let i = 0; i <= uint32Max.toNumber(); i++) {
    const hashedNumber = ethers.utils.keccak256(ethers.utils.defaultAbiCoder.encode(["uint256"], [i]))
      .substring(0, 10);
      
    if (hashedNumber === targetHash) {
      console.log("Found a match!");
      console.log("Random Number:", i);
      console.log("Hash:", hashedNumber);
      found = true;
      break; 
    }

    attempts++;

    if (attempts % 100000 === 0) {
      console.log("Attempts:", attempts);
    }
  }
}

bruteForceHash();


async function getHash() {
  const number = 346;
  const hashedNumber = ethers.utils.keccak256(ethers.utils.defaultAbiCoder.encode(["uint256"], [number]));
  const firstFourBytes = hashedNumber.substring(0, 10);
  console.log(firstFourBytes); // 0x16f21ac3
}

// getHash();


