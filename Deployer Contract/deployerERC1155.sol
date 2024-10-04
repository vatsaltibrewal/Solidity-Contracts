// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

contract withMintable is ERC1155, Ownable, ERC1155Burnable, ERC1155Supply {
    constructor(address initialOwner, string memory _uri, uint [] memory id, uint [] memory value, bytes [] memory data) ERC1155(_uri) Ownable(initialOwner) {
        for(uint i =0;i< id.length; i++){
            _mint(initialOwner, id[i], value[i], data[i]);
        }
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data)
        public
        onlyOwner
    {
        _mint(account, id, amount, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256[] memory ids, uint256[] memory values)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._update(from, to, ids, values);
    }
}

contract withoutMintable is ERC1155, Ownable, ERC1155Burnable, ERC1155Supply {
    constructor(address initialOwner, string memory _uri, uint [] memory id, uint [] memory value, bytes [] memory data) ERC1155(_uri) Ownable(initialOwner) {
        for(uint i =0;i< id.length; i++){
            _mint(initialOwner, id[i], value[i], data[i]);
        }
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256[] memory ids, uint256[] memory values)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._update(from, to, ids, values);
    }
}

contract ERC1155Factory{
    function create(address initialOwner, string memory _uri, uint [] memory id, uint [] memory value, bytes [] memory data) public returns(address){
        ERC1155 token = new withoutMintable(initialOwner, _uri, id, value, data);
        return address(token);
    }
}

contract ERC1155FactoryMintable{
    function create2(address initialOwner, string memory _uri, uint [] memory id, uint [] memory value, bytes [] memory data) public returns(ERC1155){
        return new withMintable(initialOwner, _uri, id, value, data);
    }
}
