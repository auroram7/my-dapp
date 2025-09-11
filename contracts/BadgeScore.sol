// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title BadgeScore - score registry that mints simple ERC-721-like badges
/// @notice Single-file combined scoring + NFT badge minting. No dependencies.
contract BadgeScore {
    address public owner;
    uint256 public nextTokenId;
    uint256 public badgeThreshold = 100; // points needed to mint badge

    mapping(uint256 => uint256) private _score; // entityId => score

    // NFT storage (minimal)
    mapping(uint256 => address) private _ownerOf;
    mapping(address => uint256) private _balanceOf;
    mapping(uint256 => string) private _tokenURI;

    event ScoreIncreased(uint256 indexed entityId, uint256 oldScore, uint256 newScore);
    event BadgeMinted(uint256 indexed tokenId, uint256 indexed entityId, address owner);

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        nextTokenId = 1;
    }

    function scoreOf(uint256 entityId) external view returns (uint256) {
        return _score[entityId];
    }

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

    // minimal NFT vie
