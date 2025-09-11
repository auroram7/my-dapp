// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


/// @title Guestbook - simple on-chain public messages
/// @notice Single-file contract for Remix deployment and easy verification
contract Guestbook {
struct Entry { address author; uint256 timestamp; string message; }


Entry[] private _entries;
event NewEntry(uint256 indexed index, address indexed author, uint256 timestamp, string message);


/// @notice leave a short message (max ~1024 chars)
function sign(string calldata message) external {
require(bytes(message).length <= 1024, "message too long");
_entries.push(Entry({author: msg.sender, timestamp: block.timestamp, message: message}));
emit NewEntry(_entries.length - 1, msg.sender, block.timestamp, message);
}


/// @notice read an entry by index
function entryAt(uint256 idx) external view returns (address author, uint256 timestamp, string memory message) {
require(idx < _entries.length, "out of range");
Entry storage e = _entries[idx];
return (e.author, e.timestamp, e.message);
}


/// @notice total number of entries
function totalEntries() external view returns (uint256) { return _entries.length; }
