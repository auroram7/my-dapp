// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


/// @title Marketplace - minimal ETH-based listing & buying
/// @notice Single-file contract: list items and accept ETH purchases
contract Marketplace {
struct Listing { address seller; uint256 priceWei; string name; bool active; }
uint256 public listingCount;
mapping(uint256 => Listing) public listings;
event Listed(uint256 indexed id, address indexed seller, uint256 priceWei, string name);
event Bought(uint256 indexed id, address indexed buyer, uint256 priceWei);
event Cancelled(uint256 indexed id, address indexed seller);


/// @notice create a listing with a price (wei)
function createListing(string calldata name, uint256 priceWei) external returns (uint256) {
require(priceWei > 0, "price>0");
uint256 id = ++listingCount;
listings[id] = Listing({seller: msg.sender, priceWei: priceWei, name: name, active: true});
emit Listed(id, msg.sender, priceWei, name);
return id;
}


/// @notice buy an active listing by paying exact price (or more, refunds extra)
function buy(uint256 id) external payable {
Listing storage l = listings[id];
require(l.active, "not active");
require(msg.value >= l.priceWei, "insufficient");
l.active = false;
// transfer to seller
(bool ok, ) = payable(l.seller).call{value: l.priceWei}("");
require(ok, "transfer failed");
// refund extra
if (msg.value > l.priceWei) payable(msg.sender).transfer(msg.value - l.priceWei);
emit Bought(id, msg.sender, l.priceWei);
}


/// @notice seller cancels a listing
function cancelListing(uint256 id) external {
Listing storage l = listings[id];
require(l.seller == msg.sender, "only seller");
require(l.active, "not active");
l.active = false;
emit Cancelled(id, msg.sender);
}
}
