// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract VotingSystem {
    address public admin;
    uint public proposalCount;
    bool public votingActive;

    struct Proposal {
        uint id;
        string description;
        uint voteCount;
    }

    mapping(address => bool) public hasVoted;
    mapping(uint => Proposal) public proposals;

    event ProposalAdded(uint proposalId, string description);
    event Voted(address voter, uint proposalId);
    event VotingEnded();

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
        votingActive = true;
    }

    function addProposal(string memory _description) external onlyAdmin {
        proposals[proposalCount] = Proposal(proposalCount, _description, 0);
        emit ProposalAdded(proposalCount, _description);
        proposalCount++;
    }

    function vote(uint _proposalId) external {
        require(!hasVoted[msg.sender], "You have already voted");
        require(votingActive, "Voting has ended");
        require(_proposalId < proposalCount, "Invalid proposal ID");

        proposals[_proposalId].voteCount++;
        hasVoted[msg.sender] = true;

        emit Voted(msg.sender, _proposalId);
    }

    function endVoting() external onlyAdmin {
        votingActive = false;
        emit VotingEnded();
    }
}
