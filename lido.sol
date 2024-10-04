// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// This Interface is for Ethereum Mainchain not for Polygon
// Polygon has different address and different functions

struct PermitInput {
    uint256 value;
    uint256 deadline;
    uint8 v;
    bytes32 r;
    bytes32 s;
}

interface Ilido{
    function submit(address _referral) external payable returns (uint256);

}

interface Ilido2 {
    function requestWithdrawalsWithPermit(uint256[] calldata _amounts, address _owner, PermitInput calldata _permit)
        external returns (uint256[] memory requestIds);

    function requestWithdrawalsWstETHWithPermit(
        uint256[] calldata _amounts,
        address _owner,
        PermitInput calldata _permit
    ) external returns (uint256[] memory requestIds);

    function claimWithdrawal(uint256 _requestId) external;
}

contract lidoContract{
    Ilido lido;
    Ilido2 lido2;

    constructor(){
        address _ld = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84;
        address _ld2 = 0x889edC2eDab5f40e902b864aD4d7AdE8E412F9B1;
        lido = Ilido(_ld);
        lido2 = Ilido2(_ld2);
    }

    function deposit(address _referral) public payable returns(uint256){
        return lido.submit(_referral);
    }

    function withdrawRequeststETH(uint256[] calldata _amounts, address _owner, PermitInput calldata _permit) public returns(uint256[] memory requestIds){
        return lido2.requestWithdrawalsWithPermit(_amounts, _owner, _permit);
    }

    function withdrawRequestsWstEth(
            uint256[] calldata _amounts,
            address _owner,
            PermitInput calldata _permit) 
        public returns(uint256[] memory requestIds){
            return lido2.requestWithdrawalsWstETHWithPermit(_amounts, _owner, _permit);
        }

    function claimRequest(uint256 _requestId) public{
        return lido2.claimWithdrawal(_requestId);
    }

}