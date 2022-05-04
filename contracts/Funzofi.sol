//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Funzofi {

    // all the static variables holding the contract details
    string public name;
    string public gameDetails;
    address public owner;

    // all the variables holding the game data
    uint256 counter = 0;
    uint256 public prizePool;
    uint256 public entryFee;
    
    mapping(address => uint) users;                         //  the users variable keep track of number of entries from a single account
    mapping(string => int) public players;                  //  the players variable consits of the id od the players and their scores
    mapping(uint => mapping(address => string)) entries;    //  the entries variable consits of the team data formed by the user for a particular entry
    mapping(uint => int)[] public gameResult;               // the gameResult variable consits of the final rank list of the team along with their score in a sorted manner

    constructor(string memory gameName, string memory description) {
        name = gameName;
        gameDetails = description;
        // players = [];
        owner = msg.sender;
    }

    
}
