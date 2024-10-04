// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


enum ItemType {
    // 0: ETH on mainnet, MATIC on polygon, etc.
    NATIVE,

    // 1: ERC20 items (ERC777 and ERC20 analogues could also technically work)
    ERC20,

    // 2: ERC721 items
    ERC721,

    // 3: ERC1155 items
    ERC1155,

    // 4: ERC721 items where a number of tokenIds are supported
    ERC721_WITH_CRITERIA,

    // 5: ERC1155 items where a number of ids are supported
    ERC1155_WITH_CRITERIA
}

enum OrderType {
    // 0: no partial fills, anyone can execute
    FULL_OPEN,

    // 1: partial fills supported, anyone can execute
    PARTIAL_OPEN,

    // 2: no partial fills, only offerer or zone can execute
    FULL_RESTRICTED,

    // 3: partial fills supported, only offerer or zone can execute
    PARTIAL_RESTRICTED,

    // 4: contract order type
    CONTRACT
}


struct OfferItem {
    ItemType itemType;
    address token;
    uint256 identifierOrCriteria;
    uint256 startAmount;
    uint256 endAmount;
}
struct ConsiderationItem {
    ItemType itemType;
    address token;
    uint256 identifierOrCriteria;
    uint256 startAmount;
    uint256 endAmount;
    address payable recipient;
}
struct OrderParameters {
    address offerer; // 0x00
    address zone; // 0x20
    OfferItem[] offer; // 0x40
    ConsiderationItem[] consideration; // 0x60
    OrderType orderType; // 0x80
    uint256 startTime; // 0xa0
    uint256 endTime; // 0xc0
    bytes32 zoneHash; // 0xe0
    uint256 salt; // 0x100
    bytes32 conduitKey; // 0x120
    uint256 totalOriginalConsiderationItems; // 0x140
    // offer.length                          // 0x160
}
struct Order {
    OrderParameters parameters;
    bytes signature;
}


interface seaportinterface{
//  It is the main function to offer item from the offerer and then transfer it to the bidder

    function fulfillOrder(
        Order calldata order,
        bytes32 fulfillerConduitKey
    ) external payable returns (bool fulfilled);

    
    
}

contract seaport{
    seaportinterface sea;

    constructor(){
        address _sea = 0x0000000000000068F116a894984e2DB1123eB395;
        sea = seaportinterface(_sea);
    }

    function order(
        Order calldata _order,
        bytes32 _fulfillerConduitKey
    ) public payable{
        bool fulfilled = sea.fulfillOrder(_order, _fulfillerConduitKey);
        require(fulfilled, "Order not fulfilled");
    }


}