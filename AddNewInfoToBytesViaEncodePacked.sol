// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

contract sample {

    function _makeBeaconDeposits(address _withdrawalCredentialsAddress) public pure returns (bytes memory _bytes)  {
            _bytes = abi.encodePacked(
                hex'010000000000000000000000',
                _withdrawalCredentialsAddress
            ); 
    }
}
