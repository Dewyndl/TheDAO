// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

library ArraysPlus {
    function removeByValue(address[] storage array, address _target) public {
        for (uint i= 0; i<array.length; i++) {
            if (_target==array[i]) {
                array[i] = array[array.length-1];
                array.pop();
            }
        }
    }
}

import "./VoteToken.sol";

contract TheDAO {
    using ArraysPlus for address[];
    uint lastUdedVotingId = 0;
    uint tokenCost;

    address[] public members;

    enum ActionType {AddMember, RemoveMember}

    VoteToken voteToken = new VoteToken(10**9);

    struct Voting {
        uint id;
        ActionType actionType;
        address target;
        uint64 votesFor;
        uint64 votesAgainst;
        bool executed;
        mapping (address => bool) voteState;
    }

    mapping (uint => Voting) public votings;
    uint[] public votingIds;

    constructor(uint _tokenCost) {
        tokenCost = _tokenCost; 
        members.push(msg.sender);
    }

    function getMembersAmount() public view returns (uint amount) {
        amount = members.length;
    }

    function createVoting(ActionType _actionType, address _target) public {
        Voting storage newVoting = votings[lastUdedVotingId++];
        newVoting.id = lastUdedVotingId;
        newVoting.actionType = _actionType;
        newVoting.target = _target;
        votingIds.push(newVoting.id);
    }

    function executeVoting(uint _votingId) internal {
        Voting storage _voting = votings[_votingId];
        _voting.executed = true;
        if (_voting.actionType == ActionType.AddMember) {
            members.push(_voting.target);
        } else {
            members.removeByValue(_voting.target);
        }
    }

    function vote(uint _votingId, bool voteFor) public {
        Voting storage voting = votings[_votingId];
        require(!voting.voteState[msg.sender], "You've already voted");
        voting.voteState[msg.sender] = true;
        if (voteFor) {
            voting.votesFor+=voteToken.getAvailableVotes(msg.sender);
        } else {
            voting.votesAgainst+=voteToken.getAvailableVotes(msg.sender);
        }

        if (voting.votesFor >= voteToken.availableVotesAmount()) {
            executeVoting(_votingId);
        }
    
    }

    function buyTokens() public payable {
        voteToken.transferTo(msg.sender, msg.value/tokenCost);
        payable(msg.sender).transfer(msg.value % tokenCost);
    }

    function sellTokens(uint _amount) public payable {
        require(_amount>0 && _amount<=voteToken.balanceOf(msg.sender));
        voteToken.transferTo(address(this), _amount);
        payable(msg.sender).transfer(_amount*tokenCost);
    }

    function getAvailableVotesAmount() external view returns(uint) {
        return voteToken.availableVotesAmount();
    }
}