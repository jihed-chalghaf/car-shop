// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./../interfaces/ICarShop.sol";

contract CarShop is ICarShop {
    address payable _owner;

    Car[] public inventory;
    address[] public sales;
    mapping(address => uint256) public carsIndexes;
    uint256 public carsCount;
    uint256 public salesCount;

    constructor() {
        _owner = payable(msg.sender);
    }

    /**
    @notice Adds a new Car to the inventory.
    @param id - the new car's ethereum address
    @param price - the new car's price in Wei
    */
    function addCar(address id, uint256 price) public virtual override {
        require(msg.sender == _owner, "NOT_AUTHORIZED");
        require(carsIndexes[id] == 0, "CAR_ALREADY_EXISTS");
        carsCount++;
        carsIndexes[id] = inventory.length + 1;
        inventory.push(Car(price, id));
        emit Add(id, price);
    }

    /**
    @notice Buys the Car with the given `id` and stores the sold car in the sales records.
    @dev We are not transferring the Car to the buyer. We are just making him pay for testing purposes.
    @param id - the car's ethereum address.
    @return timestamp - the timestamp in which the selling took place.
    */
    function buy(address id) public payable override returns(uint timestamp) {
        require(carsIndexes[id] > 0, "CAR_NOT_FOUND");
        uint price = inventory[carsIndexes[id] - 1].price;
        require(msg.sender.balance > price, "INSUFFICIENT_BALANCE");
        require(msg.value >= price, "INSUFFICIENT_AMOUNT");
        // transfer Car ownership in real life scenario.
        // Example: Car should be an NFT and we can transfer it to the buyer.
        // Our scenario is simple so we're just transfering money from buyer to owner.

        // store the record.
        salesCount++;
        sales.push(id);
        // remove the car from the inventory.
        _removeCarFromInventory(id);
        // transfer the car's price from buyer -> owner
        _owner.transfer(price);
        timestamp = block.timestamp;
        emit Buy(msg.sender, id, price);
    }

    /**
    @notice Removes the Car with the given id from the inventory.
    @param id - the car's ethereum address.
    */
    function _removeCarFromInventory(address id) internal {
        for (
            uint256 i = carsIndexes[id] - 1;
            i < inventory.length - 1;
            i++
        ) {
            inventory[i] = inventory[i + 1];
        }
        inventory.pop();
        delete carsIndexes[id];
        carsCount--;
    }
}