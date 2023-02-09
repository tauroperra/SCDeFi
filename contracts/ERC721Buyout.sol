// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./ERC721BuyoutFactory.sol";

interface IERC721 {
    function safeTransferFrom(address from, address to, uint tokenId) external;
    function transferFrom(address, address, uint) external;
}

contract ERC721Buyout {
    event Start(bool started, uint endAt);
    event CompetingBid(address indexed sender, uint amount);
    event WithdrawCompetingBid(address indexed bidder, uint amount);
    event End(address winner, uint amount);
    ERC721BuyoutFactory bbFactory;
    IERC721 public nft;
    uint public nftId;
    IERC20 public erc20ArtToken;
    address payable public nftDAOAddress;

    mapping(address => mapping(uint => bool)) public NFTandBuyerSet;
    uint public endAt;
    bool public started;
    bool public ended;

    address public factoryAddresss; 
    address public lisaBuyoutAdmin;
    address public thirdPartyBuyer;
    unint public thirdPartyBuyoutPrice;

    address public highestBidder;
    uint public highestBid;
    mapping(address => uint) public bids;

    // Todo: 1) add valid Seller 2) add list of existing erc20ArtToken holders for competing bids 3) faucet/exchange: erc20ArtToken for funds  4) set Factory nft nftId active buyout to false after completion


    constructor(address _factoryAddress, address _lisaBuyoutAdmin, address _nft, uint _nftId) {
        factoryAddresss = _factoryAddress;
        bbFactory = ERC721BuyoutFactory(factoryAddresss);
        lisaBuyoutAdmin = _lisaBuyoutAdmin;
        nft = IERC721(_nft);
        nftId = _nftId;
    }

    function setBuyout(address _thirdPartyBuyer, uint _thirdPartyBuyoutPrice, address _nftDAOAddress, address _erc20ArtToken) external onlyLisaBuyoutAdmin {
        require(!NFTandBuyerSet[nft][nftId], "NFT and Buyer already set in an active buyout period");
        thirdPartyBuyer = _thirdPartyBuyer;
        thirdPartyBuyoutPrice = _thirdPartyBuyoutPrice

        nftDAOAddress = _nftDAOAddress; // set to Faucet address, e.g. =payable(msg.sender)
        erc20ArtToken = _erc20ArtToken;

        NFTandBuyerSet[nft][nftId] = true;
    }

    function startBuyout() external payable onlyThirdPartyBuyer {
        require(NFTandBuyerSet[nft][nftId], "NFT and Third Party Buyout parameters are not set");
        require(!started, "buyback period has already started");
        require(msg.value == thirdPartyBuyoutPrice, "Third party buyer must pay Third Party Buyout Price" );
        
        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;

        //Start Buyback
        nft.transferFrom(msg.sender, address(this), nftId); // transfer NFT into this contract for escrow
        started = true;
        endAt = block.timestamp + 7 days; //Seven day timer
        emit Start(started, endAt);
    }

    // Send in competing bids by other buyers
    function enterCompetingBid() external payable {
        require(started, "buyback period has not started yet");
        require(block.timestamp < endAt, "buyback period has ended");
        require(msg.value > highestBid, "your bid must be larger than third party buyout price"); //Competing bid must be larger than third party offer price

        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;

        emit CompetingBid(msg.sender, msg.value);
    }

    // Withdraw competing bids by other buyers
    function withdrawCompetingBid() external {
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(bal);

        emit WithdrawCompetingBid(msg.sender, bal);
    }

    function endBuyout() external onlyLisaBuybackAdmin {
        require(started, "buyback period has not started yet");
        require(block.timestamp >= endAt, "buyback period is still active");
        require(!ended, "buyback period has already ended");

        ended = true;
        if (highestBidder != address(0)) {
            nft.safeTransferFrom(address(this), highestBidder, nftId); // NFT transferred to the highest buyer
            nftDAOAddress.transfer(highestBid); // NFT DAO owne address receives purchase funds
        } else {
            nft.safeTransferFrom(address(this), nftDAOAddress, nftId); // NFT DAO owner receives NFT back, no purchase funds transferred
        }

        bbFactory.resetActiveNFTBuyout; // Buyout ended, reset the NFT Buyout to false for another buyout
        emit End(highestBidder, highestBid); //Highest bidder gets the NFT, default buyer is the third party bidder. Competing bids must be higher than third party offer price to win. 
    }

    modifier onlyLisaBuybackAdmin() {
        require(msg.sender == lisaBuybackAdmin, "Not Lisa Admin");
        _;
    }

    modifier onlyThirdPartyBuyer() {
        require(msg.sender == thirdPartyBuyer, "Not Verified Third Party Buyer");
        _;
    }
}
