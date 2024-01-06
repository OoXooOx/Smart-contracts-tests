// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;
contract sample {
    
    constructor ( address code) {
       address(code).call(
            abi.encodeWithSignature(
                "enter()" )
        );
    }
    uint x=7;
    function doWork() external {
        x++;
    }
    function getBalance() external view returns(uint balance) {
        balance = address(this).balance;
    }
    receive() external payable { }
}

contract code {
    uint public t;
    function enter () external {
        require(test(msg.sender)==0, "");
        msg.sender.call{value: 1 ether}("");
        t=9;
    }

    function test (address x) public view returns(uint y) {
        y = x.code.length;
        // assembly {
        //     y := extcodesize(x)
        // }
    } 

    receive() external payable { }
}
