// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LuckyDraw {
    address public owner;
    address[] public players;

    event Entered(address indexed player);
    event WinnerPicked(address indexed winner, uint256 prize);

    constructor() {
        owner = msg.sender;
    }

    function enter() external payable {
        require(msg.value == 0.01 ether, "entry = 0.01 ETH");
        players.push(msg.sender);
        emit Entered(msg.sender);
    }

    function pickWinner() external {
        require(msg.sender == owner, "only owner");
        require(players.length > 0, "no players");
        uint256 rand = uint256(
            keccak256(abi.encodePacked(block.timestamp, block.prevrandao, players.length))
        ) % players.length;
        address winner = players[rand];
        uint256 prize = address(this).balance;
        payable(winner).transfer(prize);
        emit WinnerPicked(winner, prize);
        delete players;
    }

    function getPlayers() external view returns (address[] memory) {
        return players;
    }
}
