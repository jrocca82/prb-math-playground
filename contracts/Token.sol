// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@prb/math/contracts/PRBMathUD60x18.sol";
import "hardhat/console.sol";

contract Token is ERC20, Ownable {
    using PRBMathUD60x18 for uint256;
    constructor() ERC20("Token", "TKN") {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function prbSplit(address _bob, address _charlie, uint256 _amount, uint256 _percentage) public {
        // if _amount = ethers.utils.parseEther("100"), _amount => 100000000000000000000
        // see tests for example
        uint256 bobAmount = _amount.mul(_percentage); //90000000000000000000
        uint256 charlieAmount = _amount - bobAmount; //10000000000000000000
        mint(_bob, bobAmount);
        mint(_charlie, charlieAmount);
        console.log("BOB PRB", this.balanceOf(_bob));
        console.log("CHARLIE PRB", this.balanceOf(_charlie));
    }

    function mathSplit(uint256 _amount, uint256 _percentage) public view {
        // if _amount = ethers.utils.parseEther("100"), _amount => 100000000000000000000
        // see tests for example
        uint256 bobAmount = _amount * _percentage; //9000000000000000000000000000000000000

        //Overflow/underflow error
        //9000000000000000000000000000000000000 - 100000000000000000000 = math is dumb
        uint256 charlieAmount = _amount - bobAmount;
        console.log("CHARLIE MATH", charlieAmount);
    }
}
