// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.21;
 
interface IAllowanceTransfer {
    struct PermitDetails {
        address token;
        uint160 amount;
        uint48 expiration;
        uint48 nonce;
    }
 
    struct PermitSingle {
        PermitDetails details;
        address spender;
        uint256 sigDeadline;
    }
}
 
contract sample {
 
// input 0x00000000000000000000000004fb784d1be2b8e7079d34df3addd8bfcc2f0ccf000000000000000000000000000000000000000000004c88031c70f8329886ff000000000000000000000000000000000000000000000000000000006542105d0000000000000000000000000000000000000000000000000000000000000009000000000000000000000000ef1c6e67703c7bd7107eed8303fbe6ec2554bf6b000000000000000000000000000000000000000000000000000000006542105d00000000000000000000000000000000000000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000000041284b9995f4ea5f891ffc83c2de04c6df5c4e1f1d0a058f6ac19854116a81df9c2a3cc1d05e13557f6ed8ae4856aeb9094c904114c64476ea905f9a04fe00af6a1c00000000000000000000000000000000000000000000000000000000000000
    function dispatch(bytes calldata inputs)
        public
        pure
        returns (
            IAllowanceTransfer.PermitSingle calldata permitSingle,
            uint256 permitSingle1
        )
    {
        assembly {
            permitSingle1 := inputs.offset 
            permitSingle := inputs.offset
        }
        return (permitSingle, permitSingle1);
    }
}
 
//result :
 
// tuple(tuple(address,uint160,uint48,uint48),address,uint256):
// 0x04fB784D1Be2B8e7079D34Df3addd8BfCC2f0CCf,
// 361408834070410299999999,
// 1698828381,
// 9,
// 0xEf1c6E67703c7BD7107eed8303Fbe6EC2554BF6B,
// 1698828381
 
//1: uint256: permitSingle1 68
