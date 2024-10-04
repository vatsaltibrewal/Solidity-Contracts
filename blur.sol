// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

struct ERC20Details {
        address[] tokenAddrs;
        uint256[] amounts;
}

struct ERC1155Details {
        address tokenAddr;
        uint256[] ids;
        uint256[] amounts;
}

struct ERC721Details {
        address tokenAddr;
        address[] to;
        uint256[] ids;
}

struct TradeDetails {
        uint256 marketId;
        uint256 value;
        bytes tradeData;
}

interface blurInterface{


//    For Offering the NFT to the Contract
    function _transferFromHelper(
        ERC20Details memory erc20Details,
        ERC721Details[] memory erc721Details,
        ERC1155Details[] memory erc1155Details
    ) external ;


// For executing the trade of nft in market
    function _trade(
        TradeDetails[] memory tradeDetails
    ) external;
}

contract main{

    blurInterface blur;

    constructor(){
        address _bluraddress = 0x39da41747a83aeE658334415666f3EF92DD0D541;
        blur = blurInterface(_bluraddress);
    }

    function OfferNft(ERC20Details memory _erc20Details,
        ERC721Details[] memory _erc721Details,
        ERC1155Details[] memory _erc1155Details) public {
            return blur._transferFromHelper(
                _erc20Details,
                _erc721Details,
                _erc1155Details
            ); 
    }

    function trade(TradeDetails[] memory _tradeDetails) public{
        return blur._trade(_tradeDetails);
    }

    
}