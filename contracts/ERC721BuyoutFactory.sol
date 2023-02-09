// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721Buyout.sol";
//import "./ERC721Token.sol";
//import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
//import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
//import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
//import "@openzeppelin/contracts/access/Ownable.sol";
//import "@openzeppelin/contracts/utils/Counters.sol";

contract ERC721BuyoutFactory {
    address public lisaBuyoutAdmin;
    mapping(address => mapping(uint => bool)) public activeNFTBuyoutList;

    event ERC721BuyoutCreated(address boAddress, address lisaBuyoutAdmin);

    constructor(address _lisaBuyoutAdmin) {
        lisaBuyoutAdmin = _lisaBuyoutAdmin;
    }

    function deployNewERC721Buyout(address _nft, uint _nftId) public onlyLisaBuyoutAdmin returns (address) {
        require(!activeNFTBuyoutList[_nft][_nftId], "This NFT is currently in another buyout period. Can not launch another buyout");
        ERC721Buyout boAddress = new ERC721Buyout(address(this), lisaBuyoutAdmin, _nft, _nftId);
        emit ERC721BuyoutCreated(address(boAddress), address(lisaBuyoutAdmin));
        activeNFTBuyoutList[_nft][_nftId] = true;
        return address(boAddress);
    }

    function resetActiveNFTBuyout() public onlyLisaBuyoutAdmin {
        require(activeNFTBuyoutList, "This NFT is NOT in any active buyout");
        activeNFTBuyoutList[_nft][_nftId] = false;
    }

    modifier onlyLisaBuyoutAdmin() {
        require(msg.sender == lisaBuyoutAdmin, "Not Lisa Buyout Admin");
        _;
    }

}