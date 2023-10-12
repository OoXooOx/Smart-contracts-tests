// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

contract sample {
    // bytes path = "04fb784d1be2b8e7079d34df3addd8bfcc2f0ccf002710c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2";
    
    function getFirstPool(bytes calldata path) public pure returns (bytes calldata) {
        return path[:23];
        // input - 0x04fb784d1be2b8e7079d34df3addd8bfcc2f0ccf002710c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2
        // result -0x04fb784d1be2b8e7079d34df3addd8bfcc2f0ccf002710
    }

    function skipToken(bytes calldata path) public pure returns (bytes calldata) {
        return path[23:]; // 20+3
        // input - 0x04fb784d1be2b8e7079d34df3addd8bfcc2f0ccf002710c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2
        // result -                                                c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2
    }


}
