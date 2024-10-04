// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";



contract withMintable is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    uint256 private _nextTokenId;

    constructor(address initialOwner, string memory name, string memory symbol, uint tokenID)
        ERC721(name, symbol)
        Ownable(initialOwner)
    {
        _mint(initialOwner, tokenID);
    }

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
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

contract withMintableWithoutIncrement is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    constructor(address initialOwner, string memory name, string memory symbol, uint tokenID)
        ERC721(name, symbol)
        Ownable(initialOwner)
    {
        _mint(initialOwner, tokenID);
    }

    function safeMint(address to, uint256 tokenId, string memory uri)
        public
        onlyOwner
    {
        _safeMint(to, tokenId);
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

contract withoutMintable is ERC721, ERC721URIStorage, ERC721Burnable {
    constructor(address initialOwner, string memory name, string memory symbol, uint tokenID) ERC721(name, symbol) {
        _mint(initialOwner, tokenID);
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



contract ERC721Factory {
    function create(
        address initialOwner, string memory name, string memory symbol, uint tokenID
    ) public returns (ERC721){
        return new withMintableWithoutIncrement(initialOwner, name, symbol, tokenID);
    }
}

contract ERC721Factory2{
    function create(
        address initialOwner, string memory name, string memory symbol, uint tokenID
    ) public returns (ERC721){
        return new withMintable(initialOwner, name, symbol, tokenID);
    }
}

contract ERC721Factory3{
    function create(
        address initialOwner, string memory name, string memory symbol, uint tokenID
    ) public returns (ERC721){
        return new withoutMintable(initialOwner, name, symbol, tokenID);
    }
}