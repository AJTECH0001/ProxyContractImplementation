// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Storage slot definitions for EIP-1967
contract StorageSlot {
    // EIP-1967 implementation slot
    bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    // Get the implementation address from the EIP-1967 slot
    function _getImplementation() internal view returns (address impl) {
        bytes32 slot = _IMPLEMENTATION_SLOT;
        assembly {
            impl := sload(slot)
        }
    }

    // Set the implementation address in the EIP-1967 slot
    function _setImplementation(address newImplementation) internal {
        bytes32 slot = _IMPLEMENTATION_SLOT;
        assembly {
            sstore(slot, newImplementation)
        }
    }
}