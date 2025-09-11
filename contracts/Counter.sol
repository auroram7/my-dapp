// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Counter {
    uint256 public count;

    function inc() external { count += 1; }
    function dec() external { require(count > 0, "underflow"); count -= 1; }
}
