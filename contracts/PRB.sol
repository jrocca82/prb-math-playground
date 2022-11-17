// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@prb/math/contracts/PRBMathUD60x18.sol";
import "hardhat/console.sol";

contract PRBMathTest {
  using PRBMathUD60x18 for uint256;

  uint256 public result;

  constructor() {}

  function prbMultiply(uint256 _a, uint256 _b) public returns (uint256 _result) {
    console.log("PRB MULT CONTRACT", _a.mul(_b));
    result = _a.mul(_b) * 1 ether;
    console.log("TIMES 1 ETHER", result);
    return result;
  }

  function prbAvg(uint256 _a, uint256 _b) public returns(uint256 _result) {
    console.log("PRB AVG CONTRACT", _a.avg(_b));
    result = _a.avg(_b);
    return result;
  }

  function prbDivide(uint256 _a, uint256 _b) public returns(uint256 _result) {
    console.log("PRB DIV CONTRACT", _a.div(_b));
    result = _a.div(_b);
    return result;
  }
}
