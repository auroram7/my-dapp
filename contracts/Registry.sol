// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Registry {
    mapping(address => string) public records;

    function setRecord(string calldata data) external {
        records[msg.sender] = data;
    }

    function getRecord(address user) external view returns (string memory) {
        return records[user];
    }
}
