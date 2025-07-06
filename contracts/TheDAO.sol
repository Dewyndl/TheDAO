// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol"

contract Token is ERC20 {
    constructor(uint initialSupply) ("DAOToken", "DAO") {
        _mint(address(this), initialSupply);
    }

    function transferFromContract(address payable _target, uint _amount) {
        require(balanceOf(address(this)>= _amount), "Not enough balance!");
        _transfer(address(this), _target, _amount);
    

}

contract TheDAO {
    string public message = "Hello, world!";
    string public title = "Dao";
    uint lastUdedVotingId = 0;

    address[] public members;

    enum ActionType {AddMember, RemoveMember}

    struct Voting {
        uint id;
        ActionType actionType;
        address target;
        uint64 votesFor;
        uint64 votesAgainst;
        bool executed;
        address[] voters;
    }

    mapping (uint => Voting) public votings;
    uint[] public votingIds;

    constructor() {
        members.push(msg.sender);
    }

    function getMembersAmount() public view returns (uint amount) {
        amount = members.length;
    }

    function createVoting(ActionType _actionType, address _target) public {
        Voting memory newVoting;
        newVoting.id = lastUdedVotingId++;
        newVoting.actionType = _actionType;
        newVoting.target = _target;
        votings[newVoting.id] = newVoting;
        votingIds.push(newVoting.id);
    }

    
}
