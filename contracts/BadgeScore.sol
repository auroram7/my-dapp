// SPDX-License-Identifier: MIT
event BadgeMinted(uint256 indexed tokenId, uint256 indexed entityId, address owner);


modifier onlyOwner() { require(msg.sender == owner, "only owner"); _; }


constructor() { owner = msg.sender; nextTokenId = 1; }


function scoreOf(uint256 entityId) external view returns (uint256) { return _score[entityId]; }


function increaseScore(uint256 entityId, uint256 delta) external {
require(delta > 0, "delta>0");
uint256 old = _score[entityId];
uint256 nw = old + delta;
_score[entityId] = nw;
emit ScoreIncreased(entityId, old, nw);
// auto-mint badge if threshold crossed and no badge exists for this entity
if (old < badgeThreshold && nw >= badgeThreshold) {
_mintBadge(entityId, msg.sender);
}
}


function _mintBadge(uint256 entityId, address to) internal {
uint256 tokenId = nextTokenId++;
_ownerOf[tokenId] = to;
_balanceOf[to] += 1;
_tokenURI[tokenId] = string(abi.encodePacked("Badge for ", _uint2str(entityId)));
emit BadgeMinted(tokenId, entityId, to);
}


// minimal NFT view functions
function ownerOf(uint256 tokenId) public view returns (address) {
address o = _ownerOf[tokenId]; require(o != address(0), "no owner"); return o;
}
function balanceOf(address owner_) public view returns (uint256) { return _balanceOf[owner_]; }
function tokenURI(uint256 tokenId) public view returns (string memory) { return _tokenURI[tokenId]; }


// admin: set threshold
function setBadgeThreshold(uint256 newThreshold) external onlyOwner { badgeThreshold = newThreshold; }


// helper: uint -> string (small util because no imports)
function _uint2str(uint256 v) internal pure returns (string memory) {
if (v == 0) return "0";
uint256 j = v;
uint256 len;
while (j != 0) { len++; j /= 10; }
bytes memory bstr = new bytes(len);
uint256 k = len;
j = v;
while (j != 0) { k = k-1; uint8 temp = uint8(48 + j % 10); bstr[k] = bytes1(temp); j /= 10; }
return string(bstr);
}
}
