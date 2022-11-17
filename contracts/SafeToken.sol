// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "hardhat/console.sol";

contract SafeToken is ERC20, Ownable {
  using SafeMath for uint256;

  constructor() ERC20("Token", "TKN") {}

  function mint(address to, uint256 amount) public onlyOwner {
    _mint(to, amount);
  }

  function safeSplit(
    address _bob,
    address _charlie,
    uint256 _amount,
    uint256 _percentage
  ) public {
    // if _amount = ethers.utils.parseEther("100"), _amount => 100000000000000000000
    // see tests for example
    uint256 bobAmount = _amount.mul(_percentage); // 90000000000000000000000000000000000000
    mint(_bob, bobAmount);
    console.log("BOB SAFE", this.balanceOf(_bob)); //90000000000000000000000000000000000000

    // Panic because 90000000000000000000000000000000000000 - 100000000000000000000
    uint256 charlieAmount = _amount - bobAmount; 
    

    // Unreachable Code
    mint(_charlie, charlieAmount);
  }
}
