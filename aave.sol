// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./fees.sol";

interface aaveInterface{

    function supply(
        address asset,
        uint256 amount,
        address onBehalfOf,
        uint16 referralCode
    ) external;

  function supplyWithPermit(
        address asset,
        uint256 amount,
        address onBehalfOf,
        uint16 referralCode,
        uint256 deadline,
        uint8 permitV,
        bytes32 permitR,
        bytes32 permitS
    ) external;

  function withdraw(
        address asset,
        uint256 amount,
        address to
    ) external returns(uint256);

    function borrow(
        address asset,
        uint256 amount,
        uint256 interestRateMode,
        uint16 referralCode,
        address onBehalfOf
    ) external;

    function repayWithPermit(
        address asset,
        uint256 amount,
        uint256 interestRateMode,
        address onBehalfOf,
        uint256 deadline,
        uint8 permitV,
        bytes32 permitR,
        bytes32 permitS
    ) external returns(uint256);

}

interface wrappedETH{

    function depositETH(
    address,
    address onBehalfOf,
    uint16 referralCode
  ) external payable;

  function withdrawETH(
    address,
    uint256 amount,
    address to
  ) external;

  function repayETH(
    address,
    uint256 amount,
    uint256 rateMode,
    address onBehalfOf
  ) external payable;

  function borrowETH(
    address,
    uint256 amount,
    uint256 interestRateMode,
    uint16 referralCode
  ) external;

  function withdrawETHWithPermit(
    address,
    uint256 amount,
    address to,
    uint256 deadline,
    uint8 permitV,
    bytes32 permitR,
    bytes32 permitS
  ) external;

}

contract aaveContract{

    aaveInterface aave;
    wrappedETH weth;


    constructor(){
        // This is testnet address, different address for different mainnet
        address _aa = 0x6Ae43d3271ff6888e7Fc43Fd7321a503ff738951;
        address _we = 0x387d311e47e80b498169e6fb51d3193167d89F7D;
        aave = aaveInterface(_aa);
        weth = wrappedETH(_we);
    }

    function deposit(
        address pool,
        address onBehalfOf,
        uint16 referralCode
    ) public payable {
        weth.depositETH{value: msg.value}(pool, onBehalfOf, referralCode);
    }

    function giveWithoutPermission(
        address asset,
        uint256 amount,
        address onBehalfOf,
        uint16 referralCode
    ) public{
        return aave.supply(asset, amount, onBehalfOf, referralCode);
    }

    function giveWithPermission(
        address asset,
        uint256 amount,
        address onBehalfOf,
        uint16 referralCode,
        uint256 deadline,
        uint8 permitV,
        bytes32 permitR,
        bytes32 permitS) public{
            return aave.supplyWithPermit(asset, amount, onBehalfOf, referralCode, deadline, permitV, permitR, permitS);
    }

    function withdrawI(
        address asset,
        uint256 amount,
        address to
    ) public returns (uint256){
        return aave.withdraw(asset, amount, to);
    }

    function borrowI(
        address asset,
        uint256 amount,
        uint256 interestRateMode,
        uint16 referralCode,
        address onBehalfOf
    ) public{
        return aave.borrow(asset, amount, interestRateMode, referralCode, onBehalfOf);
    }

    function repayI(
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
}