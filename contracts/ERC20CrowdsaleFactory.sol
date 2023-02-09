// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20Crowdsale.sol";
//import "./ERC721Token.sol";
//import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
//import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
//import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
//import "@openzeppelin/contracts/access/Ownable.sol";
//import "@openzeppelin/contracts/utils/Counters.sol";

contract ERC20CrowdsaleFactory {
    event ERC20CrowdsaleCreated(address crowdsaleAddress, address tokenAddress);
    //event ERC721TokenCreated(address tokenAddress);

    function deployNewERC20Crowdsale(
        uint256 rate,
        address payable wallet,
        IERC20 token
    ) public returns (address) {
        ERC20Crowdsale t = new ERC20Crowdsale(
            rate,
            wallet,
            token
        );
        emit ERC20CrowdsaleCreated(address(t), address(token));

        return address(t);
    }

}