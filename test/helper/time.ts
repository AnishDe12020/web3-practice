import { ethers } from "hardhat";

const SECONDS_IN_A_DAY = 60 * 60 * 24;

const increaseDays = async (days: number) => {
  await ethers.provider.send("evm_increaseTime", [days * SECONDS_IN_A_DAY + 1]);
};

export { SECONDS_IN_A_DAY, increaseDays };
