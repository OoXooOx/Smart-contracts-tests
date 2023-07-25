// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.19;
contract sample{
    mapping(address => address[]) public referralList;
    //refer=>referrals

    function addRefer(address refer) external {
        uint256 found;
        uint256 length = referralList[refer].length;
        uint i;
        // we looking for match address, if our array of refferals already include it,
        // then we do nothing
        while (i < length && found == 0) {
            if (referralList[refer][i] == msg.sender) {
                found = 1;
            }
            unchecked {
                ++i;
            }
        }
        // if we NOT found match address in array, only then we add it
        // for certain refer
        if (found == 0) {
            referralList[refer].push(msg.sender);
        }
    }
}
