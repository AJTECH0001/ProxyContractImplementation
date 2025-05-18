// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Storage.sol";

contract Proxy is StorageSlot, Ownable {
    event Upgraded(address indexed newImplementation);

    constructor(address _implementation) Ownable(msg.sender) {
        _setImplementation(_implementation);
    }

    // Upgrade to a new implementation contract
    function upgradeTo(address _newImplementation) external onlyOwner {
        _setImplementation(_newImplementation);
        emit Upgraded(_newImplementation);
    }

    // Fallback function to delegate calls to the implementation
    fallback() external payable {
        address impl = _getImplementation();
        require(impl != address(0), "Implementation not set");

        assembly {
            // Copy msg.data to memory
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())

            // Delegatecall to the implementation
            let result := delegatecall(gas(), impl, ptr, calldatasize(), 0, 0)

            // Copy the returned data
            let size := returndatasize()
            returndatacopy(ptr, 0, size)

            // Handle the result
            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        }
    }

    // Receive function to accept ETH
    receive() external payable {}
}