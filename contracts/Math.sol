// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "hardhat/console.sol";

contract Math {
  uint256 public result;

  constructor() {}

  function multiply(uint256 _a, uint256 _b) public returns (uint256 _result) {
    console.log("MATH MULT CONTRACT", _a * _b);
    result = (_a * _b);
    return result;
  }

  function divide(uint256 _a, uint256 _b) public returns (uint256 _result) {
    console.log("MATH DIV CONTRACT", _a / _b);
    result = _a / _b;
    return result;
  }

  function average(uint256 _a, uint256 _b) public returns (uint256 _result) {
    console.log("MATH AVG CONTRACT", (_a + _b) / 2);
    result = (_a + _b) / 2;
    return result;
  }
}
