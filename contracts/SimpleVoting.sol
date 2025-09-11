// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SimpleVoting - lightweight proposal & voting contract
/// @notice Single-file and import-free for easy verification
contract SimpleVoting {
    address public admin;
    uint256 public proposalCount;

    struct Proposal {
        uint256 id;
        string title;
        string description;
        uint256 yes;
        uint256 no;
        uint256 startTs;
        uint256 endTs;
        bool exists;
        mapping(address => bool) voted;
    }

    mapping(uint256 => Proposal) private proposals;

    event ProposalCreated(uint256 indexed id, string title, uint256 startTs, uint256 endTs);
    event Voted(uint256 indexed id, address indexed voter, bool support);

    modifier onlyAdmin() {
        require(msg.sender == admin, "only admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    /// @notice create a proposal with a duration (seconds)
    function createProposal(
        string calldata title,
        string calldata description,
        uint256 durationSeconds
    ) external onlyAdmin returns (uint256) {
        require(durationSeconds >= 60, "min 60s");
        uint256 id = ++proposalCount;
        Proposal storage p = proposals[id];
        p.id = id;
        p.title = title;
        p.description = description;
        p.startTs = block.timestamp;
        p.endTs = block.timestamp + durationSeconds;
        p.exists = true;
        emit ProposalCreated(id, title, p.startTs, p.endTs);
        return id;
    }

    /// @notice vote on a proposal (true = yes, false = no)
    function vote(uint256 id, bool support) external {
        Proposal storage p = proposals[id];
        require(p.exists, "no proposal");
        require(block.timestamp >= p.startTs && block.timestamp <= p.endTs, "not active");
        require(!p.voted[msg.sender], "already voted");

        p.voted[msg.sender] = true;
        if (support) {
            p.yes += 1;
        } else {
            p.no += 1;
        }
        emit Voted(id, msg.sender, support);
    }

    /// @notice read basic proposal data
    function proposalSummary(uint256 id)
        external
        view
        returns (
            uint256 pid,
            string memory title,
            string memory description,
            uint256 yes,
            uint256 no,
            uint256 startTs,
            uint256 endTs
        )
    {
        Proposal storage p = proposals[id];
        require(p.exists, "no proposal");
        return (p.id, p.title, p.description, p.yes, p.no, p.startTs, p.endTs);
    }

    /// @notice check if an address already voted
    function hasVoted(uint256 id, address voter) external view returns (bool) {
        Proposal storage p = proposals[id];
        require(p.exists, "no proposal");
        return p.voted[voter];
    }
}
