// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";

import {StringUtils} from "./libraries/StringUtils.sol";

contract Master {
    event NewPlayer(address ownerAddress, string username);
    event PlayerProfileUpdated(
        address ownerAddress,
        string oldUsername,
        string newUsername
    );

    struct ShopItem {
        string name;
        uint256 price;
    }

    struct Player {
        address ownerAddress;
        string username;
        uint256 coins;
    }

    Player[] public players;
    ShopItem[] public shop;

    mapping(address => uint256) public addressToPlayerIndex;

    constructor() {
        addMockShopData();
    }

    function addMockShopData() private {
        // Don't judge this pls, i asked copilot to add random food items to the shop :)
        // Add random fast food items to the shop
        shop.push(ShopItem("Pizza", 10));
        shop.push(ShopItem("Burger", 20));
        shop.push(ShopItem("Hotdog", 30));
        shop.push(ShopItem("Fries", 40));
        shop.push(ShopItem("Coke", 50));
        shop.push(ShopItem("Coffee", 60));
        shop.push(ShopItem("Tea", 70));
        shop.push(ShopItem("Water", 80));
        shop.push(ShopItem("Beer", 90));
        shop.push(ShopItem("Chips", 100));
        shop.push(ShopItem("Soda", 110));
        shop.push(ShopItem("Milk", 120));
        shop.push(ShopItem("Juice", 130));
        shop.push(ShopItem("Cake", 140));
        shop.push(ShopItem("Pie", 150));
        shop.push(ShopItem("Cupcake", 160));
    }

    function isUsernameTaken(string memory username)
        public
        view
        returns (bool)
    {
        for (uint256 i = 0; i < players.length; i++) {
            if (
                keccak256(abi.encodePacked(players[i].username)) ==
                keccak256(abi.encodePacked(username))
            ) {
                return true;
            }
        }
        return false;
    }

    function addressHasPlayer(address ownerAddress) public view returns (bool) {
        for (uint256 i = 0; i < players.length; i++) {
            if (players[i].ownerAddress == ownerAddress) {
                return true;
            }
        }
        return false;
    }

    function registerPlayer(string memory username) public {
        // Check if username is between 3 and 20 characters
        require(
            StringUtils.strlen(username) >= 3 &&
                StringUtils.strlen(username) <= 20,
            "Username must be between 3 and 20 characters"
        );

        // Check if the username is already taken
        require(isUsernameTaken(username) == false, "Username already taken");
        // One player per address
        require(
            addressHasPlayer(msg.sender) == false,
            "You already have a player"
        );

        Player memory player = Player(msg.sender, username, 0);

        players.push(player);
        addressToPlayerIndex[msg.sender] = players.length - 1;
        emit NewPlayer(msg.sender, username);
    }

    function updatePlayer(string memory newUsername) public {
        Player memory player = players[addressToPlayerIndex[msg.sender]];
        string memory oldUsername = player.username;
        player.username = newUsername;
        emit PlayerProfileUpdated(msg.sender, oldUsername, newUsername);
    }
}
