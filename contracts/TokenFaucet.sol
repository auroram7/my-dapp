// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TokenFaucet {
    string public name = "FaucetToken";
    string public symbol = "FAU";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => bool) private claimed;

    function claim() external {
        require(!claimed[msg.sender], "already claimed");
        claimed[msg.sender] = true;
        uint256 amount = 100 * (10 ** uint256(decimals));
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
    }
}
