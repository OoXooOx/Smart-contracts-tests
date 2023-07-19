// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;


library Counters {
    struct Counter {
        uint _value;
    }
    function current(Counter storage counter) internal view returns (uint) {
        return counter._value;
    }
    function increment(Counter storage counter) internal {
        unchecked {counter._value += 1;}
    }
}

library Strings {
    function toString(uint value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint temp = value;
        uint digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _transferOwnership(_msgSender());
    }

    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "not an owner");
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

abstract contract ERC165 is IERC165 {
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

interface IERC20 {
    function name () external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals () external pure returns (uint);
    function totalSupply () external view returns (uint);
    function balanceOf (address account)  external view returns (uint);
    function transfer (address to, uint amount)  external;
    function allowance (address _owner, address spender)external view returns (uint);
    function approve (address spender, uint amount) external;
    function transferFrom (address sender, address recipient, uint amount) external;
    event Transfer (address indexed from, address indexed to, uint amount);
    event Approve (address indexed owner, address indexed to, uint amount);
}

interface IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owner) external view returns (uint balance);
    function ownerOf(uint tokenId) external view returns (address owner);
    function safeTransferFrom(address from, address to, uint tokenId, bytes calldata data) external;
    function safeTransferFrom(address from, address to, uint tokenId) external;
    function transferFrom(address from, address to, uint tokenId) external;
    function approve(address to, uint tokenId) external;
    function setApprovalForAll(address operator, bool _approved) external;
    function getApproved(uint tokenId) external view returns (address operator);
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}

interface IERC721Metadata is IERC721 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function tokenURI(uint tokenId) external view returns (string memory);
}

contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
    using Strings for uint;

    string private _name;
    string private _symbol;
    mapping(uint => address) private _owners;
    mapping(address => uint) private _balances;
    mapping(uint => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function balanceOf(address owner) public view virtual override returns (uint) {
        require(owner != address(0), "zero address");
        return _balances[owner];
    }

    function ownerOf(uint tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];
        return owner;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function tokenURI(uint tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId);
        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length > 0
                ? string.concat(baseURI, tokenId.toString(), ".json")
                : "";
    }

    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    function approve(address to, uint tokenId) public virtual override {
        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "owner");
        require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),"owner/operator");
        _approve(to, tokenId);
    }

    function getApproved(uint tokenId) public view virtual override returns (address) {
        _requireMinted(tokenId);
        return _tokenApprovals[tokenId];
    }

    function setApprovalForAll(address operator, bool approved) public virtual override {
        _setApprovalForAll(_msgSender(), operator, approved);
    }

    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool){
        return _operatorApprovals[owner][operator];
    }

    function transferFrom(address from, address to, uint tokenId) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "owner/approve");
        _transfer(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint tokenId) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(address from, address to, uint tokenId, bytes memory data) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "owner/approve");
        _safeTransfer(from, to, tokenId, data);
    }

    function _safeTransfer(address from, address to,uint tokenId, bytes memory data) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, data),"nonERC721Receiver");
    }

    function _exists(uint tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }

    function _isApprovedOrOwner(address spender, uint tokenId) internal view virtual returns (bool) {
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
    }

    function _mint(address to, uint tokenId) internal virtual {
        require(to != address(0), "zero address");
        require(!_exists(tokenId), "already exists");
        _beforeTokenTransfer(address(0), to, tokenId);
        _balances[to] += 1;
        _owners[tokenId] = to;
        emit Transfer(address(0), to, tokenId);
        _afterTokenTransfer(address(0), to, tokenId);
    }

    function _burn(uint tokenId) internal virtual {
        address owner = ERC721.ownerOf(tokenId);
        _beforeTokenTransfer(owner, address(0), tokenId);
        _approve(address(0), tokenId);
        _balances[owner] -= 1;
        delete _owners[tokenId];
        emit Transfer(owner, address(0), tokenId);
        _afterTokenTransfer(owner, address(0), tokenId);
    }

    function _transfer(address from, address to, uint tokenId) internal virtual {
        require(ERC721.ownerOf(tokenId) == from,"owner err");
        require(to != address(0), "zero address");
        _beforeTokenTransfer(from, to, tokenId);
        _approve(address(0), tokenId);
        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;
        emit Transfer(from, to, tokenId);
        _afterTokenTransfer(from, to, tokenId);
    }

    function _approve(address to, uint tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
    }

    function _setApprovalForAll(address owner, address operator, bool approved) internal virtual {
        require(owner != operator, "owner");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    function _requireMinted(uint tokenId) internal view virtual {
        require(_exists(tokenId), "err tokenID");
    }

    function _checkOnERC721Received(address from, address to, uint tokenId, bytes memory data) private returns (bool) {
        if (to.code.length > 0) {
            try
                IERC721Receiver(to).onERC721Received(_msgSender(),from,tokenId,data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("nonERC721Receiver");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    function _beforeTokenTransfer(address from, address to, uint tokenId) internal virtual {}
    function _afterTokenTransfer(address from, address to, uint tokenId) internal virtual {}
}

contract MY_NFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenSupply;
    IERC20  public immutable USDT;
    address[2] beneficiars=[
        0x5B38Da6a701c568545dCfcB03FcB875f56beddC4,
        0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2]; //main wallet
    struct Stake {
        uint32 startAt;
        uint32 endAt;
        uint32 withdraw;
        uint160 rewardValue;
    }
    mapping(uint=>Stake) public stakedNFTs;
    mapping(address=>uint) public tokensStakedByAddress;
    mapping(uint=>uint) public lastTransferTimestamp;
    mapping(uint=>uint) public rewards;
    uint[5] public rewards_=[30,60,90,180,365];
    uint constant SEC_IN_DAY=86400;
    uint constant DAYS_IN_YEAR=365;
    uint constant public maxSupply = 1000; 
    uint constant public price = 1000*10**6;
    uint public withdrawFunds;
    uint public totalTokensStaked;
    uint private trigger;
    string public baseTokenURI;

    event deposit(uint tokenId, address staker, uint32 endAt);
    event withdrawal(uint tokenId, address claimer);

    constructor(
        IERC20 _USDT,
        string memory name_,
        string memory symbol_,
        string memory _baseTokenURI
        ) ERC721(name_, symbol_) {
            setBaseTokenURI(_baseTokenURI);
            USDT=_USDT;
            rewards[30]=60;
            rewards[60]=70;
            rewards[90]=80;
            rewards[180]=90;
            rewards[365]=100; 
    // 1 year - 100%  6 month - 90%   3 month - 80%  2 month - 70%  1 month - 60%
    }

    function mint(uint _amount) external {
        require(_amount + totalSupply() <= maxSupply, "MaxSupply");
        require(_amount!=0 && _amount<21, "can mint 1-20 NFT");
        uint mintValue = price * _amount;
        (bool success,) = address(USDT).call(
            abi.encodeWithSignature(
                "transferFrom(address,address,uint256)",
                _msgSender(),
                address(this),
                mintValue)
            );
        require(success, "Failed send funds");
        for (uint i = 0; i < _amount;) {
            _tokenSupply.increment();
            uint _tokenId = _tokenSupply.current();
            lastTransferTimestamp[_tokenId]=block.timestamp;
            _mint(_msgSender(), _tokenId);
            unchecked{ ++i; }
        }
        if(trigger==1){
           withdrawFunds+=mintValue*6/10;  
           // 60% from income goes to offline fonds
           // 40% from income will be lock as collateral
        }
    }

    function batchStakeNFT(uint[] calldata _tokenIds, uint _timeInDays) external {
        uint length = _tokenIds.length;
        for(uint i = 0; i < length;) {
            stakeNFT(_tokenIds[i], _timeInDays);    
            unchecked{ ++i; }
        }
    }

    function stakeNFT(uint _tokenId, uint _timeInDays) public {
        require(_timeInDays>29, "30 days min");
        require(_isApprovedOrOwner(_msgSender(), _tokenId), "owner/approve");
        Stake storage newStake = stakedNFTs[_tokenId];
        require(block.timestamp>newStake.endAt,  "NFT staking time are not expired yet"); 
        newStake.startAt=uint32(block.timestamp); 
        newStake.endAt=uint32(block.timestamp+getSecInDays(_timeInDays));
        newStake.withdraw=0;
        uint length = rewards_.length;
        uint rewardTime;
        for (uint i=0; i<length;){
            if (_timeInDays>=rewards_[i]) {
                rewardTime = rewards_[i];  
            }
            unchecked{ ++i; }
        }   
        newStake.rewardValue=uint160(price*rewards[rewardTime]*_timeInDays/DAYS_IN_YEAR/100);
        unchecked{ 
            tokensStakedByAddress[_msgSender()]++;
            totalTokensStaked++;
        }
        emit deposit(_tokenId, _msgSender(), newStake.endAt);
    }

    function batchClaim(uint[] calldata _tokenIds) external {
        uint length = _tokenIds.length;
        uint amount;
        for(uint i = 0; i < length;) {
            amount+=calcReward(_tokenIds[i]);    
            unchecked{++i;}
        }
        (bool success,) = address(USDT).call(
            abi.encodeWithSignature(
                "transfer(address,uint256)",
                _msgSender(),
                amount)
            );
        require(success, "Failed send funds");
    }

    function claim(uint _tokenId) external {
        uint amount = calcReward(_tokenId);
        (bool success,) = address(USDT).call(
            abi.encodeWithSignature(
                "transfer(address,uint256)",
                _msgSender(),
                amount)
            );
        require(success, "Failed send funds");
    }

    function calcReward(uint _tokenId) internal returns(uint) {
        Stake storage newStake = stakedNFTs[_tokenId];
        require(newStake.rewardValue!=0, "nothing claim");
        require(block.timestamp>newStake.endAt, "too early");
        require(newStake.withdraw==0, "already received");
        require(_isApprovedOrOwner(_msgSender(), _tokenId), "owner/approve");
        newStake.withdraw=1;
        unchecked{
            tokensStakedByAddress[_msgSender()]--;
            totalTokensStaked--;
        } 
        emit withdrawal(_tokenId, _msgSender());
        return newStake.rewardValue;
    }

    function _transfer(address from, address to, uint tokenId) internal override  {
        require(block.timestamp>(lastTransferTimestamp[tokenId] + 30 days), "30 days not expired");
        require(block.timestamp>stakedNFTs[tokenId].endAt, "NFT staking time are not expired yet");
        lastTransferTimestamp[tokenId]=block.timestamp;
        super._transfer(from, to, tokenId);
    }
    
    //↓↓↓↓↓↓// Withdraw functions //↓↓↓↓↓↓
    //////////////////////////////////////
    function withdraw() external {
        require(trigger==1,"");
        uint amount=withdrawFunds;
        withdrawFunds-=amount;
        for(uint i=0;i<beneficiars.length;){
            uint _amount;
            if(i==0) {
                _amount=amount*5/100;
            } else {
                _amount=amount*95/100;
            }
            (bool success, ) = address(USDT).call(
            abi.encodeWithSignature(
                "transfer(address,uint256)",
                beneficiars[i],
                _amount)
            );
            require(success, "Failed to send funds!");  
            unchecked{ ++i; }
        }
    }

    function withdrawF10() external {
        require(trigger==0 && totalSupply()>9,"");
        for(uint i=0;i<beneficiars.length;){
            (bool success, ) = address(USDT).call(
            abi.encodeWithSignature(
                "transfer(address,uint256)",
                beneficiars[i],
                price*5)
            );
            require(success, "Failed to send funds!");
            unchecked{ ++i; }
        }
        trigger=1;
        uint remainBalance = getBalanceUSDT();
        withdrawFunds+=remainBalance*6/10;   
    }

    //↓↓↓↓↓↓// SETTER //↓↓↓↓↓↓
    ////////////////////////////
    function setBaseTokenURI(string memory _baseTokenURI) public onlyOwner {
        require(bytes(_baseTokenURI).length > 0, "Invalid");
        baseTokenURI = _baseTokenURI;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    //↓↓↓↓↓↓// GETTER //↓↓↓↓↓↓
    ////////////////////////////

    function getSecInDays (uint _timeInDays) internal pure returns (uint){
        return _timeInDays*SEC_IN_DAY;
    }

    function getDaysFromSec (uint _timeInSec) internal pure returns (uint) {
        return _timeInSec/SEC_IN_DAY;
    }

    function totalSupply() public view returns (uint) {
        return _tokenSupply.current();
    }

    function getBalanceUSDT() public view returns (uint) {
        return USDT.balanceOf(address(this));
    }

    function getStakedNFTbyAddress(address _owner) public view returns (uint[] memory tokenIds) {
        uint[] memory ownedTokenIds = getNFTbyOwner(_owner);
        uint length = ownedTokenIds.length;
        for (uint i = 0; i < length;) {
            uint tokenId = ownedTokenIds[i];
            if (stakedNFTs[tokenId].endAt > block.timestamp) {
                tokenIds = addToken(tokenIds, tokenId);
            }
            unchecked{++i;}
        }
    }

    function addToken(uint[] memory arr, uint element) internal pure returns (uint[] memory newArr) {
        uint length = arr.length;
        newArr = new uint[](length+ 1);
        for (uint i = 0; i < length; ) {
            newArr[i] = arr[i];
            unchecked{++i;}
        }
        newArr[length] = element;
    }

    function getNFTbyOwner(address _owner) public view returns (uint[] memory) {
        uint ownerTokenCount = balanceOf(_owner); 
        uint[] memory ownedTokenIds = new uint[](ownerTokenCount); 
        uint currentTokenId = 1;
        uint ownedTokenIndex = 0;
        while (ownedTokenIndex < ownerTokenCount &&  currentTokenId < maxSupply) {
            if (ownerOf(currentTokenId) == _owner) { 
                ownedTokenIds[ownedTokenIndex] = currentTokenId; 
                unchecked{ ownedTokenIndex++; }
            }
            unchecked{ currentTokenId++; }
        }
        return ownedTokenIds;
    } 

    fallback() external payable {
        revert ("don't do this");
    }

    receive() external payable {
        revert ("don't do this");
    }   
}
