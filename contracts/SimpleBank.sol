// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleBank {
    mapping(address => uint256) public balance;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    function deposit() external payable {
        require(msg.value > 0, "no eth");
        balance[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        require(balance[msg.sender] >= amount, "not enough");
        balance[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawn(msg.sender, amount);
    }
}
