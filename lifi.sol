// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

struct LibSwap_SwapData{
  address callTo;
        address approveTo;
        address sendingAssetId;
        address receivingAssetId;
        uint256 fromAmount;
        bytes callData;
        bool requiresDeposit;
}

interface LIFIInterface {
    function swapTokensGeneric(
        bytes32 _transactionId,
        string calldata _integrator,
        string calldata _referrer,
        address payable _receiver,
        uint256 _minAmount,
        LibSwap_SwapData[] calldata _swapData
    ) external payable;
}

contract YourContract {
    LIFIInterface LIFI;

    constructor() {
        address _LIFIAddress = 0x1231DEB6f5749EF6cE6943a275A1D3E7486F4EaE;
        LIFI = LIFIInterface(_LIFIAddress);
    }
    function useAnotherContractFunction(bytes32 _transactionId,
        string calldata _integrator,
        string calldata _referrer,
        address payable _receiver,
        uint256 _minAmount,
        LibSwap_SwapData[] calldata _swapData) public payable{
        return LIFI.swapTokensGeneric(
            _transactionId,
            _integrator,
            _referrer,
            _receiver,
            _minAmount,
            _swapData
    );
    }
}
