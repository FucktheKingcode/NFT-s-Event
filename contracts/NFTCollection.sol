// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTEventAnniversary is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    uint256 private _nextTokenId;
    uint256 public _maximumMintNFT;

    constructor(address initialOwner, string memory _name, string memory _symbol, uint256 maximumMintNFT)
        ERC721(_name, _symbol)
        Ownable(initialOwner)
        
    {
        _maximumMintNFT = maximumMintNFT;
    }

    function safeMint(address to, string memory uri) public payable {
        if(_maximumMintNFT == 0 || _maximumMintNFT > _nextTokenId){
            uint256 tokenId = _nextTokenId++;
            _safeMint(to, tokenId);
            _setTokenURI(tokenId, uri);
        }else {
            revert("There are no more NFTs");
        }
        
        if(msg.sender != owner()) {
            // Chuyển phí gas cho chủ hợp đồng
            payable(owner()).transfer(msg.value);
        }
        
    }

    function setTokenURI(uint256 tokenId, string memory uri) public onlyOwner {
        _setTokenURI(tokenId, uri);
    }

    
    // The following functions are overrides required by Solidity.


    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}