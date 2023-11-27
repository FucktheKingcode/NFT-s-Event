// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NFTCollection {
    // Địa chỉ của chủ sở hữu hợp đồng
    address public owner;
    uint256 totalURIs = 0;

    struct KeyValuePair {
        uint256 tokenId;
        string uri;
    }
    
    // Mapping để lưu trữ các URI được đẩy lên
    mapping(uint256 => string) public uris;

    // Sự kiện được kích hoạt khi một URI mới được đẩy lên
    event URIAdded(uint256 indexed tokenId, string uri);

    // Xây dựng hợp đồng, chỉ chủ sở hữu mới có thể gọi các hàm quản lý
    constructor() {
        owner = msg.sender;
    }

    // Hàm modifier để đảm bảo chỉ có chủ sở hữu mới có thể gọi được
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    // Hàm để đẩy lên một URI mới
    function pushURI(uint256 tokenId, string memory uri) external onlyOwner {
        uris[tokenId] = uri;
        totalURIs++;
        emit URIAdded(tokenId, uri);
    }

    // Hàm để chuyển quyền sở hữu hợp đồng
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid new owner address");
        owner = newOwner;
    }

    // Hàm để đọc tất cả các URI có trong mapping
    function getAllURIs() external view returns (KeyValuePair[] memory) {
        KeyValuePair[] memory allURIs = new KeyValuePair[](totalURIs);
        for (uint256 i = 0; i < totalURIs; i++) {
            allURIs[i] = KeyValuePair(i, uris[i]);
        }
        return allURIs;
    }

    
}