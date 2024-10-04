// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract fees {
    address manager = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    address admin;

    modifier isManager(){
        require(msg.sender == manager,"Not Manager");
        _;
    }

    modifier isPeople(){
        require(msg.sender != address(0), "Address is Zero");
        _;
    }

//For ERC20 Transfer
    function _safeTransferFrom(
        IERC20 token,
        address sender,
        address recipient,
        uint256 amount
    ) private {
        bool sent = token.transferFrom(sender, recipient, amount);
        require(sent, "Token transfer failed");
    }

//For ERC20 Permit
    function _safePermit(
        ERC20Permit token,
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) private {
        token.permit(owner, spender, value, deadline, v, r, s);
    }

    constructor(address _admin) isManager{
        admin = payable(_admin);
    }

    mapping (address => uint) integratorCut;

// here integrator's address is associated with a mapping of ERC token addresses to balances
    mapping (address => mapping (address => uint)) balance;

//This just defines cut for the integrators
    function addIntegrators(address payable _integrator, uint _cut) public isManager {
        integratorCut[_integrator] = _cut;
    }

    function checkBalance(address coinAddress) public view returns(uint){
        return balance[msg.sender][coinAddress];
    }

    function changeAdmin(address payable _admin) public isManager {
        admin = _admin;
    }

    uint baseCut = 5;
    uint denominator = 10000;

    function changeFeeCut(uint _baseCut) public isManager {
        baseCut = _baseCut;
    }

    function changeFeeCut(uint _baseCut , uint _denominator) public isManager{
        baseCut = _baseCut;
        denominator = _denominator;
    }

    function collectFeesNative(uint amount, address _integrator) public payable isPeople returns(uint) {
        require(amount > 0 && integratorCut[_integrator] > 0);
        require(msg.value == amount, "Incorrect amount sent");
        uint adminFee = (amount * baseCut)/denominator;
        uint integratorFee = (amount * integratorCut[_integrator])/denominator;
        balance[admin][address(0)] += adminFee;
        balance[_integrator][address(0)] += integratorFee;
        uint totalTransfer = amount - adminFee - integratorFee;
        return totalTransfer;
    }

    function collectFeesERC20(address coinAddress, uint amount, address _integrator, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public payable isPeople returns(uint) {
        require(amount > 0 && integratorCut[_integrator] > 0);
        IERC20 token = IERC20(coinAddress);
        ERC20Permit _token = ERC20Permit(coinAddress);
        uint adminFee = (amount * baseCut)/denominator;
        uint integratorFee = (amount * integratorCut[_integrator])/denominator;
        uint totalTransferFee = adminFee + integratorFee;
        _safePermit(_token, msg.sender, address(this), totalTransferFee, deadline, v, r, s);
        _safeTransferFrom(token, msg.sender, address(this), totalTransferFee);
        balance[admin][coinAddress] += adminFee;
        balance[_integrator][coinAddress] += integratorFee;
        return amount-totalTransferFee;
    }

    function collectFeesTotalNative(uint amount, address _integrator) public payable isPeople {
        require(amount > 0 && integratorCut[_integrator] > 0);
        require(msg.value == amount, "Incorrect amount sent");
        uint integratorFee = (amount * integratorCut[_integrator])/denominator;
        uint adminFee = amount - integratorFee;
        balance[_integrator][address(0)] += integratorFee;
        balance[admin][address(0)] += adminFee;
    }

    function collectFeesTotalERC20(address coinAddress, uint amount, address _integrator, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public payable isPeople {
        require(amount > 0 && integratorCut[_integrator] > 0);
        IERC20 token = IERC20(coinAddress);
        ERC20Permit _token = ERC20Permit(coinAddress);
        _safePermit(_token, msg.sender, address(this), amount, deadline, v, r, s);
        _safeTransferFrom(token, msg.sender, address(this), amount);
        uint integratorFee = (amount * integratorCut[_integrator])/denominator;
        uint adminFee = amount - integratorFee;
        balance[_integrator][coinAddress] += integratorFee;
        balance[admin][coinAddress] += adminFee;
    }

    function withdrawFee(address coinAddress, address payable toPay, uint amount) public payable isPeople {
        require(balance[msg.sender][coinAddress] >= amount && msg.sender == toPay);
        if(coinAddress == address(0)){
           toPay.transfer(amount);
           balance[toPay][coinAddress] -= amount; 
        }
        else{
            IERC20 token = IERC20(coinAddress);
            _safeTransferFrom(token, address(this), toPay, amount);
            balance[toPay][coinAddress] -= amount;
        } 
    }
}