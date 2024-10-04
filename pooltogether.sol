// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface PoolTogetherInterface {
    
    function startRngRequest(address _rewardRecipient) external;
    function isAuctionOpen() external view returns (bool);
}

contract YourContract {
    PoolTogetherInterface poolTogether;

    constructor() {
        address _poolTogetherAddress = 0x1A188719711d62423abF1A4de7D8aA9014A39D73;
        poolTogether = PoolTogetherInterface(_poolTogetherAddress);
    }
    function useAnotherContractFunction() public view returns (bool) {
        return poolTogether.isAuctionOpen();
    }

}
