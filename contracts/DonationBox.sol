// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DonationBox {
    mapping(address => uint256) public donated;
    uint256 public total;

    event Donated(address indexed from, uint256 amount);

    function donate() external payable {
        require(msg.value > 0, "no eth");
        donated[msg.sender] += msg.value;
        total += msg.value;
        emit Donated(msg.sender, msg.value);
    }

    function myDonation() external view returns (uint256) {
        return donated[msg.sender];
    }
}
