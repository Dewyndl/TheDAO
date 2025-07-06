// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.28;

contract VoteToken {
    mapping(address => uint) public balances;

    uint public availableVotesAmount;
    mapping (address=>uint64) public availableVotes;
    address owner;

    constructor(uint initialEmission) {
        balances[msg.sender] = initialEmission;
        owner = msg.sender;
    }

    function getAvailableVotes(address _target) public view returns (uint64 votesAmount) {
        votesAmount = availableVotes[_target];
    }

    function balanceOf(address _target) public view returns (uint balance) {
        return balances[_target];
    }

    function calculateAmountOfVotes(uint _tokensAmount) internal pure returns (uint64 votesAmount) {
        while (_tokensAmount>0) {
            votesAmount ++;
            _tokensAmount = _tokensAmount / 10;
        }
    }

    function reviseAmountOfVotes(address _target) internal {
        if (_target != address(owner)) {
            uint64 newVotesAmount = calculateAmountOfVotes(balanceOf(_target));
            availableVotesAmount += newVotesAmount-availableVotes[_target];
            availableVotes[_target] = newVotesAmount;
        }
    }

    function transferTo(address _target, uint _amount) public {
        require(balances[msg.sender] >= _amount,"You don't have enough tokens");
        balances[msg.sender] -= _amount;
        balances[_target] += _amount;
        reviseAmountOfVotes(_target);
        reviseAmountOfVotes(msg.sender);
    }
}