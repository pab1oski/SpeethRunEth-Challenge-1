pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

    YourToken public yourToken;

    uint256 public constant tokensPerEth = 100;
    uint256 public amount;

    constructor(address tokenAddress) {
        yourToken = YourToken(tokenAddress);
    }

    // ToDo: create a payable buyTokens() function:
    function buyTokens() public payable {
        amount = msg.value * tokensPerEth;
        yourToken.transfer(msg.sender, amount);
        emit BuyTokens(msg.sender, msg.value, amount);
    }

    // ToDo: create a withdraw() function that lets the owner withdraw ETH
    function withdraw() public onlyOwner {
        uint256 vendorBalance = address(this).balance;
        (bool sent, ) = msg.sender.call{value: vendorBalance}("");
        require(sent, "Failed transaction");
    }

    // ToDo: create a sellTokens(uint256 _amount) function:
    function sellTokens(uint256 _amount) public {
        require(_amount > 0, " Must sell tokens amount greater than 0");

        uint256 userBalance = yourToken.balanceOf(msg.sender);
        require(userBalance >= _amount, "User doent have enougth tokens");

        uint256 amountOfEth = _amount / tokensPerEth;
        uint256 vendorEthBalance = address(this).balance;
        require(vendorEthBalance >= amountOfEth, "Dont have enougth eth");

        bool sent = yourToken.transferFrom(msg.sender, address(this), _amount);
        require(sent, "Fail transfering tokens");
        (bool ethsent, ) = msg.sender.call{value: amountOfEth}("");
        require(ethsent, "Fail transfering eth");
    }
}
