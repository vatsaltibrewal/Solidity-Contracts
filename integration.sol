// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./fees.sol";
import "./aave.sol";

contract integration is fees(address(0)){
    aaveInterface aave;
    wrappedETH WETH;

    address _aa = 0x6Ae43d3271ff6888e7Fc43Fd7321a503ff738951;
    address _we = 0x387d311e47e80b498169e6fb51d3193167d89F7D;

    constructor(address _admin){
        // This is testnet address, different address for different mainnet
        aave = aaveInterface(_aa);
        WETH = wrappedETH(_we);
        admin = payable(_admin);
    }

    function collectERC20(
            address asset,
            uint256 amount,
            address onBehalfOf,
            uint16 referralCode,
            uint256 deadline,
            uint8 permitV,
            bytes32 permitR,
            bytes32 permitS,
            address _integrator
        )public payable{

        uint _amount = collectFeesERC20(asset, amount, _integrator, deadline, permitV, permitR, permitS);
         
        aave.supplyWithPermit(asset, _amount, onBehalfOf, referralCode, deadline, permitV, permitR, permitS);
    }

    function collectETH(
        address _integrator,
        address onBehalfOf,
        uint16 referralCode
    ) public payable {
        uint amount = collectFeesNative(msg.value, _integrator);

        WETH.depositETH{value: amount}(_aa, onBehalfOf, referralCode);
    }

    function withdrawERC20(
        address asset,
        uint256 amount,
        address to
    ) public returns (uint256){
        return aave.withdraw(asset, amount, to);
    }

    function withdrawETH(
        uint256 amount,
        address to
    ) public {
        return WETH.withdrawETH(_aa, amount, to);
    }

    function borrowERC20(
        address asset,
        uint256 amount,
        uint256 interestRateMode,
        uint16 referralCode,
        address onBehalfOf
    ) public{
        return aave.borrow(asset, amount, interestRateMode, referralCode, onBehalfOf);
    }

    function borrowETH(
        address payable toPay,
        uint256 amount,
        uint256 interestRateMode,
        uint16 referralCode
    ) public {
        require(msg.sender == toPay);
        WETH.borrowETH(_aa, amount, interestRateMode, referralCode);
        toPay.transfer(amount);
    }

    function repayERC20(
        address asset,
        uint256 amount,
        uint256 interestRateMode,
        address onBehalfOf,
        uint256 deadline,
        uint8 permitV,
        bytes32 permitR,
        bytes32 permitS
    ) public returns(uint256){
        return aave.repayWithPermit(asset, amount, interestRateMode, onBehalfOf, deadline, permitV, permitR, permitS);
    }

    function repayETH(
        uint256 amount,
        uint256 rateMode,
        address onBehalfOf
    ) public payable {
        WETH.repayETH{value: msg.value}(_aa, amount, rateMode, onBehalfOf);
    }

}