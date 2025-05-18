// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/Proxy.sol";
import "../src/Logic.sol";
import "../src/Storage.sol";

contract ProxyTest is Test {
    Proxy proxy;
    Logic logic;
    address owner;
    address nonOwner;

    function setUp() public {
        owner = address(this);
        nonOwner = address(0x123);

        // Deploy implementation contract
        logic = new Logic();

        // Deploy proxy contract
        proxy = new Proxy(address(logic));
    }

    function testDelegateCall() public {
        // Interact with proxy as if it were the Logic contract
        Logic proxyAsLogic = Logic(address(proxy));

        // Initialize value
        proxyAsLogic.initialize(42);

        // Verify value
        assertEq(proxyAsLogic.getValue(), 42);

        // Update value
        proxyAsLogic.setValue(100);
        assertEq(proxyAsLogic.getValue(), 100);
    }

    function testUpgrade() public {
        // Deploy new implementation
        Logic newLogic = new Logic();

        // Upgrade to new implementation
        proxy.upgradeTo(address(newLogic));

        // Interact with proxy
        Logic proxyAsLogic = Logic(address(proxy));
        proxyAsLogic.initialize(200);
        assertEq(proxyAsLogic.getValue(), 200);
    }

    function testOnlyOwnerCanUpgrade() public {
        // Deploy new implementation
        Logic newLogic = new Logic();

        // Attempt upgrade from non-owner
        vm.prank(nonOwner);
        vm.expectRevert("Ownable: caller is not the owner");
        proxy.upgradeTo(address(newLogic));
    }

    function testImplementationSlot() public {
        // Verify initial implementation
        bytes32 slot = bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1);
        address storedImpl = address(uint160(uint256(vm.load(address(proxy), slot))));
        assertEq(storedImpl, address(logic));
    }
}