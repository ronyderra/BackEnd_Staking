// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract XpStakingContract {

ERC20 token = ERC20(0x95EC2C05Eb5f1009BE862E3545D858C7857f2E31);
   
    mapping(address=> uint256[]) public quantityOfDeposit;
    mapping(address=>uint256[])public timeCreated;
    mapping(address => uint256[])public maxIntrest;
    mapping(address=>uint256[])public intrestWithdrawTime;

 function deposit(uint256 amount) public payable {
     uint256 depositorBalance = token.balanceOf(msg.sender);
     require(depositorBalance >= amount, "you must have the amout of tokens for deposit");
     token.transferFrom(msg.sender, address(this) ,amount);
     quantityOfDeposit[msg.sender].push(amount);
     timeCreated[msg.sender].push(block.timestamp);
     maxIntrest[msg.sender].push((amount/100)*10);
     intrestWithdrawTime[msg.sender].push(block.timestamp);
     console.log(maxIntrest[msg.sender][0]);
 } 
 
 function withdrawDeposit() public  {
    require(timeLeft() == 0, "Deadline not yet expired");
    token.transfer( msg.sender,quantityOfDeposit[msg.sender][0]);
    quantityOfDeposit[msg.sender][0] = 0;
    maxIntrest[msg.sender][0] = 0;
 }

 function withdrawIntrest() public {
      console.log(maxIntrest[msg.sender][0]);
      require(maxIntrest[msg.sender][0] >= 0 , "There is no intrest to withdraw");
      uint256 timePassed = block.timestamp - intrestWithdrawTime[msg.sender][0];
      uint256 intrestAmountTowithdraw = ((maxIntrest[msg.sender][0] / 525600) / 60) * timePassed;
      maxIntrest[msg.sender][0] -= intrestAmountTowithdraw;
      intrestWithdrawTime[msg.sender][0]=block.timestamp;
      token.transfer(msg.sender,intrestAmountTowithdraw);
 }

 function timeLeft() public view returns (uint256 timeleft) {
        return timeCreated[msg.sender][0] + 300 >= block.timestamp ? (timeCreated[msg.sender][0] + 300 ) - block.timestamp : 0;
    }
}
