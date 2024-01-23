// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

contract SimpleTrick {
    function _setImplementation(address newImplementation) public {
        getAddressSlot(
            0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
        ).value = newImplementation;
    }

    struct AddressSlot {
        address value;
    }

    function getAddressSlot(bytes32 slot)
        internal
        pure
        returns (AddressSlot storage r)
    {
        assembly {
            r.slot := slot
        }
    }

    function _implementation() public view virtual returns (address impl) {
        return _getImplementation();
    }

    function _getImplementation() internal view returns (address) {
        return
            getAddressSlot(
                0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
            ).value;
    }
    mapping(uint=>AddressSlot) public slots;

    function set() external {
        slots[1] = getAddressSlot(0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc);
    }
}
