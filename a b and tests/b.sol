// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;


contract b {
    uint public count;
    fallback() external payable {
        if (msg.sender!=address(0)){
            count++;
        }
    }
    receive () external payable {
        if (count<=5) {
            count++;
        }
    }
}