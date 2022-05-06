//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Funzofi {

    // custom datatype using structs
    struct player {
        string  playerId;
        int     score;
        bool    present;
    }

    enum status {
        NOT_STARTED,
        ON_GOING,
        ENDED
    }

    // all the static variables holding the contract details
    string  public name;
    string  public gameDetails;
    address public owner;

    // all the variables holding the game data
    uint256        counter;
    status  public gameStatus;
    uint256 public prizePool;
    uint256 public entryFee;
    
    mapping(address => uint)                        public  users;          //  the users variable keep track of number of entries from a single account
    mapping(string  => player)                      public  players;        //  the players variable consits of the id od the players and their scores
    mapping(uint    => mapping(address => string[]))        entries;        //  the entries variable consits of the team data formed by the user for a particular entry
    mapping(uint    => int)[]                               gameResult;     //  the gameResult variable consits of the final rank list of the team along with their score in a sorted manner

    // Modifier to give access only to the owner of the contract
    modifier onlyOwner(){
        require(
            msg.sender == owner, 
            "Only the owner has access to this"
        );
        _;
    }

    constructor(string memory gameName, string memory description, uint fee, string[] memory playersList) {
        counter     = 0;
        name        = gameName;
        gameDetails = description;
        entryFee    = fee;
        gameStatus  = status.NOT_STARTED;
        owner       = msg.sender;

        // Loading the players data and initializing with 0 score
        for(uint i=0; i<playersList.length; i++){
            players[playersList[i]] = player(playersList[i], 0, true);
        }
    }

    function enterGame(string[] memory teamList) payable public {
        require(
            gameStatus == status.ON_GOING && users[msg.sender] < 5,
            "Sorry! You have exceeded the number of entries"
        );
        require(
            msg.value == (entryFee * 1 ether),
            "Sorry! Incorrect entry fee"
        );
        users[msg.sender]++;
        for(uint i=0; i<teamList.length; i++){
            if(players[teamList[i]].present){
                entries[counter][msg.sender].push(teamList[i]);
            } else {
                revert();
            }
        }
        counter++;
    }

    function startGame() public onlyOwner {
        gameStatus = status.ON_GOING;
    }

    function cancelGame() public onlyOwner {}

    function endGame() public onlyOwner {
        gameStatus = status.ENDED;
    }

    function updateScore() public onlyOwner {}

    function getWinnersList() public view returns(uint[] memory) {
        // require(
        //     gameStatus == status.ENDED,
        //     "Sorry! The Game hasn't ended yet ended"
        // );
        // uint[] memory list;
        // for(uint i=0; i<gameResult.length; i++ ){
        //     list.push(gameResult[i]);
        // }
        
    }

    function declareWinner() public onlyOwner {}
    
}
