// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";

contract Master {
    event NewPlayer(address ownerAddress, string username);

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

    function registerPlayer(address _ownerAddress, string memory username)
        public
    {
        players.push(Player(_ownerAddress, username, 0));
        emit NewPlayer(_ownerAddress, username);
    }

    function updateProfile(address _ownerAddress, string memory newUsername)
        public
    {
        for (uint256 i = 0; i < players.length; i++) {
            if (players[i].ownerAddress == _ownerAddress) {
                players[i].username = newUsername;
                break;
            }
        }
    }
}
