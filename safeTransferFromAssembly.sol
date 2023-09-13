
contract test {

    function safeTransferFrom(address token, address from, address to, uint256 amount) external {
        bool success;
        assembly {
            let freeMemoryPointer := mload(0x40)
            mstore(freeMemoryPointer, 0x23b872dd00000000000000000000000000000000000000000000000000000000)
            mstore(add(freeMemoryPointer, 4), from) // Append the "from" argument.
            mstore(add(freeMemoryPointer, 36), to) // Append the "to" argument.
            mstore(add(freeMemoryPointer, 68), amount) // Append the "amount" argument.
            success := and(
                or(and(eq(mload(0), 1), gt(returndatasize(), 31)), iszero(returndatasize())),
                call(gas(), token, 0, freeMemoryPointer, 100, 0, 32)
            )
        }
        require(success, "TRANSFER_FROM_FAILED");

        //transaction cost	60085 gas 




        // (bool success, bytes memory response) = address(token).call(
        //     abi.encodeWithSignature(
        //         "transferFrom(address,address,uint256)",
        //         from,
        //         to,
        //         amount)
        //     );
        // require(success && (response.length == 0 || abi.decode(response, (bool))), "Failed send funds");
             

         //transaction cost 60904 










        // (bool success, bytes memory response) = address(token).call(
        //     abi.encodeWithSignature(
        //         "transferFrom(address,address,uint256)",
        //         from,
        //         to,
        //         amount)
        //     );
        // require(success && abi.decode(response, (bool)), "Failed send funds");
             

         //transaction cost 56077 
    }  
}


