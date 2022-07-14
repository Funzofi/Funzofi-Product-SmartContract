//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Funzofi {

    // custom datatype using structs
    struct player {
        string  playerId;
        string  playerName;
        int     score;
        bool    present;
    }

    struct entry {
        address     userAddress;
        string[]    team;
        int         score;
    }

    enum status {
        NOT_STARTED,
        ON_GOING,
        ENTRY_FREEZED,
        ENDED,
        COMPLETED
    }

    // all the static variables holding the contract details
    string  public name;
    string  public gameDetails;
    address public owner;

    // all the variables holding the game data
    status  public gameStatus;
    uint256 public prizePool    = 0;
    uint256 public entryFee;
    
    mapping(string  => player)  public  players;        //  the players variable consits of the id od the players and their scores
    mapping(address => uint)    public  users;          //  the users variable keep track of number of entries from a single account
    entry[]                     public  entries;        //  the entries variable consits of the team data formed by the user for a particular entry
    entry[]                     public  gameResult;     //  the gameResult variable consits of the final rank list of the team along with their score in a sorted manner

    // Modifier to give access only to the owner of the contract
    modifier onlyOwner(){
        require(
            msg.sender == owner, 
            "Only the owner has access to this"
        );
        _;
    }

    function sort(entry[] memory data) public pure returns(entry[] memory) {
       quickSort(data, int(0), int(data.length - 1));
       return data;
    }

    function quickSort(entry[] memory arr, int left, int right) internal pure {
        int i = left;
        int j = right;
        if (i == j) return;
        int pivot = arr[uint(left + (right - left) / 2)].score;
        while (i <= j) {
            while (arr[uint(i)].score > pivot) i++;
            while (pivot > arr[uint(j)].score) j--;
            if (i <= j) {
                (arr[uint(i)], arr[uint(j)]) = (arr[uint(j)], arr[uint(i)]);
                i++;
                j--;
            }
        }
        if (left < j)
            quickSort(arr, left, j);
        if (i < right)
            quickSort(arr, i, right);
    }

    constructor(string memory gameName, string memory description, uint fee, player[] memory playersList) {
        require(
            fee > 0, 
            "Entry fee should be greater than 0"
        );
        name        = gameName;
        gameDetails = description;
        entryFee    = fee;
        gameStatus  = status.NOT_STARTED;
        owner       = msg.sender;

        // Loading the players data and initializing with 0 score
        for(uint i=0; i<playersList.length; i++){
            players[playersList[i].playerId] = player(playersList[i].playerId, playersList[i].playerName, 0, playersList[i].present);
        }
    }

    function enterGame(string[] memory teamList) payable public {
        require(
            gameStatus == status.ON_GOING && users[msg.sender] < 5,
            "Sorry! You have exceeded the number of entries or Game hasn't started"
        );
        require(
            msg.value == (entryFee * 1 wei),
            "Sorry! Incorrect entry fee"
        );
        bool check = true;
        for(uint i=0; i<teamList.length; i++){
            if(players[teamList[i]].present == false){
                check = false;
                break;
            }
        }
        require(check, "Sorry! Incorrect Team");
        entries.push(entry(msg.sender, teamList, 0));
        users[msg.sender]++;
        prizePool += uint(msg.value);
    }

    function startGame() public onlyOwner {
        require(
            gameStatus == status.NOT_STARTED,
            "Sorry! Either the game has already started or it has ended"
        );
        gameStatus = status.ON_GOING;
    }

    function freezeEntries() public onlyOwner {
        require(
            gameStatus == status.ON_GOING,
            "Sorry! Either the game has already started or it has ended"
        );
        gameStatus = status.ENTRY_FREEZED;
    }

    function cancelGame() public onlyOwner {
        for(uint i=0; i<entries.length; i++){
            payable(entries[i].userAddress).transfer(entryFee * 1 wei);
        }
    }

    function endGame() public onlyOwner {
        require(
            gameStatus == status.ON_GOING,
            "Sorry! Either the game has not already started or it has ended"
        );
        gameStatus = status.ENDED;

        for(uint i=0; i<entries.length; i++){
            string[] memory data = entries[i].team;
            for(uint j=0; j<data.length; j++){
                entries[i].score += players[data[j]].score;
            }
        }

    }

    function updateScore(player[] memory data) public onlyOwner {
        require(
            gameStatus == status.ON_GOING,
            "Sorry! The hasn't started yet"
        );
        for(uint i=0; i<data.length; i++){
            if(players[data[i].playerId].present){
                players[data[i].playerId].score = data[i].score;
            } else {
                revert();
            }
        }
    }

    function getWinnersList() public {
        require(
            gameStatus == status.ENDED,
            "Sorry! The Game hasn't ended yet ended"
        );
        entry[] memory data = sort(entries);
        for(uint i=0; i<data.length; i++){
            gameResult.push(data[i]);
        }
        gameStatus = status.COMPLETED;
    }

    function declareWinner() public onlyOwner {
        require(
            gameStatus == status.COMPLETED,
            "Sorry the winner list generation haven't been completed"
        );
        payable(gameResult[0].userAddress).transfer(prizePool * 1 wei);
    }

    function getResultList() public view returns(entry[] memory) {
        require(
            gameStatus == status.COMPLETED,
            "Sorry the winner list generation haven't been completed"
        );
        return gameResult;
    }

    function getEntriesList() public view returns(entry[] memory) {
        return entries;
    }

    function destroy() public onlyOwner {
        require(msg.sender == owner, "You are not the owner");
        selfdestruct(payable(owner));
    }

    receive() external payable {
        revert();
    }
    
}