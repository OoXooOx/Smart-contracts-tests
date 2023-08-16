contract encodeDecode {
    string public a;
    bytes public x;
    //deposit
    //0x000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000076465706f73697400000000000000000000000000000000000000000000000000
    function encode(string calldata _str) external {
       x= abi.encode(_str);
    }
    function set(bytes calldata data) external  {
        a = abi.decode(data, (string));   
    }
    //0x6465706f736974
}
