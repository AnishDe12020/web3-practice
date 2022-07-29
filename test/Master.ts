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

    const username = "random username";

    expect(await contract.registerPlayer(username))
      .to.emit(contract, "NewPlayer")
      .withArgs(owner.address, username);
  });

  it("should not create a player with an existing username", async () => {
    const { contract } = await loadFixture(deployContract);

    const username = "random username";

    await contract.registerPlayer(username);

    await expect(contract.registerPlayer(username)).to.be.revertedWith(
      "Username already taken"
    );
  });

  it("should not create a player with a username less than 3 characters", async () => {
    const { contract } = await loadFixture(deployContract);

    const username = "gm";

    await expect(contract.registerPlayer(username)).to.be.revertedWith(
      "Username must be between 3 and 20 characters"
    );
  });

  it("should not create a player with a username more than 20 characters", async () => {
    const { contract } = await loadFixture(deployContract);

    const username = "abcdefghijklmnopqrstuvwxyz";

    await expect(contract.registerPlayer(username)).to.be.revertedWith(
      "Username must be between 3 and 20 characters"
    );
  });

  it("should update a player's username", async () => {
    const { contract, owner } = await loadFixture(deployContract);

    const username = "random username";

    await contract.registerPlayer(username);

    const newUsername = "new username";

    expect(await contract.updatePlayer(newUsername))
      .to.emit(contract, "PlayerProfileUpdated")
      .withArgs(owner.address, username, newUsername);
  });

  it("should not create a player with different username if address already has a player", async () => {
    const { contract } = await loadFixture(deployContract);

    const username = "random username";

    await contract.registerPlayer(username);

    const newUsername = "new username";

    await expect(contract.registerPlayer(newUsername)).to.be.revertedWith(
      "You already have a player"
    );
  });

  it("should work", async () => {
    const { contract, owner } = await loadFixture(deployContract);

    const username = "random username";

    await contract.registerPlayer(username);

    const playerIndex = await contract.addressToPlayerIndex(owner.address);

    const oldCoins = await (await contract.players(playerIndex)).coins;

    const res = await contract.work();

    const newCoins = await (await contract.players(playerIndex)).coins;

    const amountEarned = newCoins.sub(oldCoins);

    expect(res)
      .to.emit(contract, "PlayerMadeMoney")
      .withArgs(owner.address, amountEarned, oldCoins, newCoins);
  });
});
