// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Logic {
    uint256 public value;

    // Initialize the contract
    function initialize(uint256 _value) external {
        value = _value;
    }

    // Update the value
    function setValue(uint256 _newValue) external {
        value = _newValue;
    }

    // Retrieve the value
    function getValue() external view returns (uint256) {
        return value;
    }
}