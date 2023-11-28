// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

interface LocationProvider {
    function getLocation(address owner) external view returns (string memory);
}

contract ArtistDynamicNFT is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(uint256 => string) private _tokenLocations;
    mapping(uint256 => string) private _ConceptLocations;
    mapping(address => bool) private _participants;
    string private _uri;

    event LocationUpdated(uint256 indexed tokenId, string newLocation);
    event EventParticipation(uint256 indexed tokenId, address participant);
    event URIBatchUpdated(uint256[] tokenIds, string newURI);

    constructor(string memory name, string memory symbol, string memory uri) ERC721(name, symbol) Ownable() {
        _uri = uri;
    }

    function _mintNFT() internal onlyOwner returns (uint256) {
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();
        _mint(owner(), tokenId);
        _setTokenURI(tokenId, _uri);
        return tokenId;
    }

    function addLocation(string memory location) external onlyOwner {
        uint256 tokenId = mintNFT();
        _tokenLocations[tokenId] = location;
        emit LocationUpdated(tokenId, location);
    }

    function getLatestLocation() external view returns (string memory) {
        require(_tokenIds.current() > 0, "No locations available");
        return _tokenLocations[_tokenIds.current()];
    }

    function updateLocation(uint256 tokenId) external payable {
        require(ownerOf(tokenId) == msg.sender, "Not the owner");
        string memory newLocation = _baseURI;
        _participants[msg.sender] = true;

        if (msg.value > 0) {
            // Owner bears the gas cost
            (bool success, ) = owner().call{value: msg.value}("");
            require(success, "Transfer failed");
        }

        _tokenLocations[tokenId] = newLocation;
        emit LocationUpdated(tokenId, newLocation);
        if (!_participants[msg.sender]) {
            _participants[msg.sender] = true;
            emit EventParticipation(tokenId, msg.sender);
        }
    }

    function compareLocations(uint256 tokenId) external view returns (bool) {
        require(ownerOf(tokenId) == msg.sender, "Not the owner");
        require(_participants[msg.sender], "Not a participant");

        string memory latestLocation = _tokenLocations[_tokenIds.current()];
        string memory ownerLocation = _tokenLocations[tokenId];

        // Perform your location comparison logic here
        // For simplicity, let's assume locations are equal
        return keccak256(abi.encodePacked(latestLocation)) == keccak256(abi.encodePacked(ownerLocation));
    }

    function updateURIBatch(uint256[] calldata tokenIds, string calldata newURI) external onlyOwner {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            _tokenLocations[tokenIds[i]] = newURI;
        }
    emit URIBatchUpdated(tokenIds, newURI);
}

    function setBaseURI(string memory newBaseURI) external onlyOwner {
        _baseURI = newBaseURI;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

}