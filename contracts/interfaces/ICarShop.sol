// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICarShop {
    struct Car {
        uint price;
        address id;
    }
    function addCar(address id, uint price) external;
    function buy(address id) external payable returns (uint timestamp);

    /**
    * @dev Emitted when the store's owner adds a new car.
    */
    event Add(address indexed id, uint price);

    /**
    * @dev Emitted when a car is sold.
    */
    event Buy(address indexed buyer, address indexed id, uint price);
}