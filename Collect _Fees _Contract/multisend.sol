// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";



contract fees2 {
    function _safeTransferFrom20(
        IERC20 token,
        address sender,
        address recipient,
        uint256 amount
    ) private {
        bool sent = token.transferFrom(sender, recipient, amount);
        require(sent, "Token transfer failed");
    }

    function _safeTransferFrom1155(
        IERC1155 token,
        address sender,
        address recipient,
        uint256 id,
        uint256 amount
    ) private {
        token.safeTransferFrom(sender, recipient, id, amount, "0x0");
    }

    function _safeTransferFrom721(
        IERC721 token,
        address sender,
        address recipient,
        uint256 id
    ) private {
        token.safeTransferFrom(sender, recipient, id);
    }

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

    function transferNative(address [] memory coinAddress, address payable [] memory receiver, uint [] memory amount, uint256 [] memory deadline, uint8 [] memory v, bytes32 [] memory r, bytes32 [] memory s) public {
        require(coinAddress.length == receiver.length && receiver.length == amount.length);
        for(uint i=0; i < amount.length; i++){
            if(coinAddress[i] == address(0)){
                receiver[i].transfer(amount[i]);
            }
            else{
                IERC20 token = IERC20(coinAddress[i]);
                ERC20Permit _token = ERC20Permit(coinAddress[i]);
                _safePermit(_token, address(this), receiver[i], amount[i], deadline[i], v[i], r[i], s[i]);
                _safeTransferFrom20(token, address(this), receiver[i], amount[i]);
            }
        }
    }

    function transfer721(address [] memory coinAddress, address payable [] memory receiver, uint [] memory tokenID) public {
        require(coinAddress.length == receiver.length && receiver.length == tokenID.length);
        for(uint i=0; i< receiver.length; i++){
            IERC721 token = IERC721(coinAddress[i]);
            _safeTransferFrom721(token, address(this), receiver[i], tokenID[i]);
        }
    }

    function transfer1155(address [] memory coinAddress, address payable [] memory receiver, uint [] memory amount, uint [] memory tokenID) public{
        require(coinAddress.length == receiver.length && receiver.length == tokenID.length && receiver.length == amount.length);
        for(uint i=0; i< receiver.length; i++){
            IERC1155 token = IERC1155(coinAddress[i]);
            _safeTransferFrom1155(token, address(this), receiver[i], tokenID[i], amount[i]);
        }
    }

    // In multiTransfer user will input prefernce which will tell the token type(ERC20, ERC721, ERC1155)

    function multiTransfer(uint [] memory prefernce, address [] memory coinAddress, address payable [] memory receiver, uint [] memory amount, uint [] memory tokenID, uint256 [] memory deadline, uint8 [] memory v, bytes32 [] memory r, bytes32 [] memory s) public {
        require(coinAddress.length == receiver.length && receiver.length == tokenID.length && receiver.length == amount.length && receiver.length == prefernce.length);
        for(uint i=0; i<prefernce.length; i++){
            if(prefernce[i]==1){
               if(coinAddress[i] == address(0)){
                    receiver[i].transfer(amount[i]);
                }
                else{
                    IERC20 token = IERC20(coinAddress[i]);
                    ERC20Permit _token = ERC20Permit(coinAddress[i]);
                    _safePermit(_token, address(this), receiver[i], amount[i], deadline[i], v[i], r[i], s[i]);
                    _safeTransferFrom20(token, address(this), receiver[i], amount[i]);
                }  
            }
            else if(prefernce[i] == 2){
                IERC721 token = IERC721(coinAddress[i]);
                _safeTransferFrom721(token, address(this), receiver[i], tokenID[i]);
            }
            else if(prefernce[i] == 3){
                IERC1155 token = IERC1155(coinAddress[i]);
                _safeTransferFrom1155(token, address(this), receiver[i], tokenID[i], amount[i]);
            }
        }
    }
}
