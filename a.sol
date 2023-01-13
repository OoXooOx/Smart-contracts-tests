// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
contract a {
    address public contractB;
    constructor(address _addr){
        contractB = _addr;
    }

    function deposit() public payable {
    }

    function withdraw() public {
        uint bal = 1 ether;
        // payable(contractB).transfer(bal);

        (bool success, ) = address(contractB).call{value: bal}(
            abi.encodeWithSignature(
                "transferFrom(address)",
                msg.sender
            )
        );
        require(success, "Failed to send funds!");
    }
}