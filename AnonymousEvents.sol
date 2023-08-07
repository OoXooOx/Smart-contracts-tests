//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract Lock {
//     Note that for LOG* operations gas is paid per byte of data (not per word).

// Terms:

//     num_topics: the * of the LOG* op. e.g. LOG0 has num_topics = 0, LOG4 has num_topics = 4
//     data_size: size of the data to log in bytes (len in the stack representation).
//     mem_expansion_cost: the cost of any memory expansion required (see A0-1)

// Gas Calculation:

//     gas_cost = 375 + 375 * num_topics + 8 * data_size + mem_expansion_cost



    // difference in Remix 359 gas * 20gwei*1800$(price ETH)= 0.0129 USDT
    event DataStoredNonAnonymous(address admin, uint256 indexed data);
    event DataStoredAnonymous(address admin, uint256 indexed data) anonymous;
   
    uint256 x;
    uint256 y;
   
    function storeDataNonAnonymous(uint256 _data) external {
      x = _data;
      emit DataStoredNonAnonymous(msg.sender, _data);
    }

    function storeDataAnonymous(uint256 _data) external {
      y = _data;
      emit DataStoredAnonymous(msg.sender, _data);
    }

}
