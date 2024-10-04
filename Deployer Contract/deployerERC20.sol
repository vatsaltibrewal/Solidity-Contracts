// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";


contract mintableWithoutPermit is ERC20, ERC20Burnable, Ownable {
    constructor(address initialOwner, string memory _name, string memory _symbol, uint _initialSupply)
        ERC20(_name, _symbol)
        Ownable(initialOwner)
    {
        _mint(initialOwner, _initialSupply * 10 ** 18);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}


contract normal is ERC20 {
    constructor(address initialOwner, string memory _name, string memory _symbol, uint _initialSupply) ERC20(_name, _symbol) {
        _mint(initialOwner, _initialSupply * 10 ** 18);
    }
}



contract mintableWithPermit is ERC20, ERC20Burnable, Ownable, ERC20Permit {
    constructor(address initialOwner, string memory _name, string memory _symbol, uint _initialSupply)
        ERC20(_name, _symbol)
        Ownable(initialOwner)
        ERC20Permit(_name)
    {
        _mint(initialOwner, _initialSupply * 10 ** 18);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}


contract ERC20FactoryOwnable {
    function create(
        address _owner,
        string memory name,
        string memory symbol,
        uint256 initialSupply,
        bool mintable
    ) public returns (address) {
        if(mintable){
            return address(new mintableWithoutPermit(_owner, name, symbol, initialSupply));
        }
        else{
            return address(new normal(_owner, name, symbol, initialSupply));
        }
    }
}

contract ERC20FactoryPermit {
    function create(
        address _owner,
        string memory name,
        string memory symbol,
        uint256 initialSupply,
        bool permit
    ) public returns (address) {
        if(permit){
            return address(new mintableWithPermit(_owner, name, symbol, initialSupply));
        }
        else{
            return address(new mintableWithoutPermit(_owner, name, symbol, initialSupply));
        }
    }
}
