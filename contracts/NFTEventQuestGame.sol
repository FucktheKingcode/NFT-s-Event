// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTEventVoteGame is ERC721, Ownable {
    uint256 public totalAddresses = 0;
    string private uri;
    struct AddressInfo {
        bool someValue;
    }

    mapping(address => bool) public addressExists;
    mapping(uint256 => AddressInfo) public addressInfoMapTrue;
    mapping(uint256 => AddressInfo) public addressInfoMapFalse;
    uint256[] public addressKeys;

    event AddressAdded(uint256 indexed tokenId, address indexed addressUser, bool someValue);

    constructor(address initialOwner, string memory _name, string memory _symbol, string memory _uri) 
        ERC721(_name, _symbol)
        Ownable(initialOwner) {
            uri =_uri;
        }

    function pushAddress(bool someValue) external {
        require(!addressExists[msg.sender], "Address already exists");

        uint256 tokenId = totalAddresses;
        addressExists[msg.sender] = true;
        addressKeys.push(tokenId);

        AddressInfo memory newAddressInfo = AddressInfo(someValue);
        (someValue ? addressInfoMapTrue : addressInfoMapFalse)[tokenId] = newAddressInfo;

        totalAddresses++;
        emit AddressAdded(tokenId, msg.sender, someValue);
    }

    function mintNFTs(bool answer) external {
        address[] memory matchingAddresses = getAddressesByValue(answer);

        for (uint256 i = 0; i < matchingAddresses.length; i++) {
            uint256 tokenId = totalAddresses + i;
            _mint(matchingAddresses[i], tokenId);
            emit AddressAdded(tokenId, matchingAddresses[i], true);
        }

        totalAddresses += matchingAddresses.length;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return uri;
    }

    function getAllAddresses() external view returns (bool[] memory) {
        bool[] memory allAddresses = new bool[](totalAddresses);
        mapping(uint256 => AddressInfo) storage selectedMap = addressInfoMapTrue;

        for (uint256 i = 0; i < totalAddresses; i++) {
            allAddresses[i] = selectedMap[addressKeys[i]].someValue;
        }
        return allAddresses;
    }

    function getAddressesByValue(bool desiredValue) public view returns (address[] memory) {
        address[] memory matchingAddresses = new address[](totalAddresses);
        uint256 matchingCount = 0;

        mapping(uint256 => AddressInfo) storage selectedMap = (desiredValue ? addressInfoMapTrue : addressInfoMapFalse);

        for (uint256 i = 0; i < totalAddresses; i++) {
            uint256 tokenId = addressKeys[i];
            if (selectedMap[tokenId].someValue == desiredValue) {
                matchingAddresses[matchingCount++] = ownerOf(tokenId);
            }
        }

        assembly {
            mstore(matchingAddresses, matchingCount)
        }

        return matchingAddresses;
    }
}
