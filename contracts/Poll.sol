// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Poll {
    address public owner;
    string public question;
    string public optionA;
    string public optionB;
    uint256 public votesA;
    uint256 public votesB;
    mapping(address => bool) public voted;

    constructor(string memory _q, string memory _a, string memory _b) {
        owner = msg.sender;
        question = _q;
        optionA = _a;
        optionB = _b;
    }

    function vote(bool forA) external {
        require(!voted[msg.sender], "already voted");
        voted[msg.sender] = true;
        if (forA) { votesA++; } else { votesB++; }
    }
}
