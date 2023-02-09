// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 *
 */
contract ERC721Buyback is Context, ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    // Art NFT
    IERC721 private erc721Token;
    // Art DAO ERC20 Token
    IERC20 private erc20Token;

    // Buyer Wallet Address
    address payable private buyerWallet;
    // Buybac Amount
    uint256 private bbAmount;

    // Competing bidders
    address[] private cbAddresses;
    // Competing bidder index
    uint256 private cbIndex;
    mapping(uint256=>address) private cbIndexToAddress;
    event BuybackLaunched(address indexed erc721Token,  uint256 bbAmount, address indexed buyerWallet, address indexed erc20Token);

    constructor (uint256 _bbAmount, address payable _buyerWallet, IERC721 _erc721Token, IERC20 _erc20Token) {
        require(_bbAmount > 0, "Buyback amount must be larger than 0");
        require(_buyerWallet != address(0), "Buyer: wallet can not be zero address");
        require(address(_erc721Token) != address(0), "NFT: can not be zero address");
        require(address(_erc20Token) != address(0), "ERC20 Art DAO Token: can not be zero address");

        erc721Token = _erc721Token;
        erc20Token = _erc20Token;
        buyerWallet = _buyerWallet;
        bbAmount = _bbAmount;
    }

    // Fall back function - do not override
    receive() external payable {
    enterCompetingBid(_msgSender());
    }

    // Get ERC721 Art NFT token address
    function getErc721Token() public view returns (IERC721) {
        return erc721Token;
    }

    // Get ERC20 Art DAO token address
    function getErc20Token() public view returns (IERC20) {
        return erc20Token;
    }

    // Get Third Party Buyer address
    function getBuyerWallet() public view returns (address payable) {
        return buyerWallet;
    }

    // Get Buyback amount
    function getBbAmount() public view returns (uint256) {
        return bbAmount;
    }

    // Get Competing bidders
    function getCompetingBids() public view returns (uint256) {
        return _weiRaised;
    }

    // Store competing bidders
    function enterCompetingBids(address compBidder) virtual public nonReentrant payable {
        // add
        cbAddresses.push(msg.sender);
        cbIndex++;
        // Store in a mapping
        cbIndexToAddress[cbIndex]=msg.sender;
    }

    // Todo: modify this function to get allowance from bidders
    function enterCompetingBidToBePrelaced(address beneficiary) virtual public nonReentrant payable {
        uint256 weiAmount = msg.value;
        _preValidatePurchase(beneficiary, weiAmount);

        // calculate token amount to be created
        uint256 tokens = _getTokenAmount(weiAmount);

        // update state
        _weiRaised = _weiRaised.add(weiAmount);

        _processPurchase(beneficiary, tokens);
        emit TokensPurchased(_msgSender(), beneficiary, weiAmount, tokens);

        _updatePurchasingState(beneficiary, weiAmount);

        _forwardFunds();
        _postValidatePurchase(beneficiary, weiAmount);
    }

    //
    function _preValidatePurchase(address beneficiary, uint256 weiAmount) virtual internal view {
        require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
        require(weiAmount != 0, "Crowdsale: weiAmount is 0");
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
    }

    //
    function _postValidatePurchase(address beneficiary, uint256 weiAmount) virtual internal view {
        // solhint-disable-previous-line no-empty-blocks
    }

    //
    function _deliverTokens(address beneficiary, uint256 tokenAmount) virtual internal {
        _token.safeTransfer(beneficiary, tokenAmount);
    }

    //
    function _processPurchase(address beneficiary, uint256 tokenAmount) virtual internal {
        _deliverTokens(beneficiary, tokenAmount);
    }

    //
    function _updatePurchasingState(address beneficiary, uint256 weiAmount) virtual internal {
        // solhint-disable-previous-line no-empty-blocks
    }

    //
    function _getTokenAmount(uint256 weiAmount) virtual internal view returns (uint256) {
        return weiAmount.mul(_rate);
    }

    //
    function _forwardFunds() internal {
        _wallet.transfer(msg.value);
    }
}