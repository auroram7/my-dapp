// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TodoList {
    struct Task { string text; bool done; }
    mapping(address => Task[]) private _tasks;

    function addTask(string calldata text) external {
        _tasks[msg.sender].push(Task(text, false));
    }

    function toggleTask(uint256 i) external {
        require(i < _tasks[msg.sender].length, "bad index");
        _tasks[msg.sender][i].done = !_tasks[msg.sender][i].done;
    }

    function getTasks() external view returns (Task[] memory) {
        return _tasks[msg.sender];
    }
}
