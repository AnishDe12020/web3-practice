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
    event PlayerMadeMoney(
        address ownerAddress,
        uint256 amount,
        uint256 oldCoins,
        uint256 newCoins
    );

    struct ShopItem {
        string name;
        uint256 price;
    }

    ShopItem[] public shop;

    mapping(address => string) public addressToUsername;
    mapping(address => uint256) public addressToCoins;
    mapping(string => address) public usernameToAddress;

    constructor() {
        addMockShopData();
    }

    function random() private view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        msg.sender
                    )
                )
            );
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
        return
            usernameToAddress[username] !=
            0x0000000000000000000000000000000000000000;
    }

    function addressHasPlayer(address ownerAddress) public view returns (bool) {
        return
            keccak256(abi.encodePacked(addressToUsername[ownerAddress])) !=
            keccak256(abi.encodePacked(""));
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

        addressToUsername[msg.sender] = username;
        usernameToAddress[username] = msg.sender;
        addressToCoins[msg.sender] = 0;

        emit NewPlayer(msg.sender, username);
    }

    function updatePlayer(string memory newUsername) public {
        string memory oldUsername = addressToUsername[msg.sender];
        addressToUsername[msg.sender] = newUsername;
        emit PlayerProfileUpdated(msg.sender, oldUsername, newUsername);
    }

    function work() public {
        uint256 oldCoins = addressToCoins[msg.sender];
        uint256 coinsMade = ((random() % 100) * 10);
        addressToCoins[msg.sender] += coinsMade;
        emit PlayerMadeMoney(
            msg.sender,
            coinsMade,
            oldCoins,
            addressToCoins[msg.sender]
        );
    }
}
