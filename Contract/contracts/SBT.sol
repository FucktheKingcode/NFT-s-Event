// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@klaytn/contracts/KIP/token/KIP17/KIP17.sol";
import "@klaytn/contracts/utils/Counters.sol";
import "@klaytn/contracts/access/Ownable.sol";

contract SoulBoundToken is KIP17, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    constructor() KIP17("SoulBoundToken", "SBT") {}

    // Lưu trữ mapping giữa tokenId với URI
    mapping(uint256 => string) private _tokenURIs; 

    // Hàm set lại URI
    function setTokenURI(uint256 tokenId, string memory uri) public onlyOwner {
    _tokenURIs[tokenId] = uri;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
    require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

    return _tokenURIs[tokenId];
    }

    // Internal function để lấy URI từ mapping
    function _tokenURI(uint256 tokenId) internal view returns (string memory) {
    return tokenURI(tokenId);
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }


    function _beforeTokenTransfer(address from, address to, uint256) pure override internal {
        require(from == address(0) || to == address(0), "This a Soulbound token. It cannot be transferred.");
    }

    function _burn(uint256 tokenId) internal override(KIP17) {
        super._burn(tokenId);
    }
}