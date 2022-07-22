import { ethers } from "hardhat";
import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";

const deployContract = async () => {
  const [owner, otherAccount] = await ethers.getSigners();

  const Master = await ethers.getContractFactory("Master");
  const contract = await Master.deploy();

  return { contract, owner, otherAccount };
};

describe("Player", async () => {
  it("should create a player", async () => {
    const { contract, owner } = await loadFixture(deployContract);

    const username = "lol a random username";

    expect(await contract.registerPlayer(username))
      .to.emit(contract, "NewPlayer")
      .withArgs(owner.address, username);
  });
});
