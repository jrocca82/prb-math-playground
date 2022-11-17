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
        uint256 bobAmount = _amount.mul(_percentage);
        uint256 charlieAmount = _amount - bobAmount;
        mint(_bob, bobAmount);
        mint(_charlie, charlieAmount);
        console.log("CONTRACT BOB", this.balanceOf(_bob));
        console.log("CONTRACT CHARLIE", this.balanceOf(_charlie));
    }

    // Gives underflow/overflow error
    function mathSplit(address _bob, address _charlie, uint256 _amount, uint256 _percentage) public {
        uint256 bobAmount = _amount * _percentage;
        uint256 charlieAmount = _amount - bobAmount;
        mint(_bob, bobAmount);
        mint(_charlie, charlieAmount);
        console.log("CONTRACT BOB", this.balanceOf(_bob));
        console.log("CONTRACT CHARLIE", this.balanceOf(_charlie));
    }
}
