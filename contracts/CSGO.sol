//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract CSGO {
    // to store the pleyer information
    struct player {
        string playerId;
        int256 kills;
        int256 deaths;
        bool present;
    }

    // to store the users address , their team selection and their score
    struct entry {
        address userAddress;
        string[] team;
        int256 score;
    }

    // to store the status of match
    enum status {
        NOT_STARTED,
        ON_GOING,
        ENDED,
        COMPLETED
    }

    // all the static variables holding the contract details
    string public gameName;
    string public matchID;
    address public owner;

    // all the variables holding the match data
    status public matchStatus;
    uint256 public prizePool = 0;
    uint256 public entryFee;

    mapping(string => player) public players; //  the players variable consists of the id of the players and, their kills, assists and mvps
    mapping(address => uint256) public users; //  the users variable keep track of the number of entries from a single account
    entry[] public entries; //  the entries variable consits of the team data formed by the user for a particular entry
    entry[] public matchResult; //  the matchResult variable consits of the final rank list of the team along with their score in a sorted manner

    // Modifier to give access only to the owner of the contract
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner has access to this");
        _;
    }

    function sort(entry[] memory data) public pure returns (entry[] memory) {
        quickSort(data, int256(0), int256(data.length - 1));
        return data;
    }

    function quickSort(
        entry[] memory arr,
        int256 left,
        int256 right
    ) internal pure {
        int256 i = left;
        int256 j = right;
        if (i == j) return;
        int256 pivot = arr[uint256(left + (right - left) / 2)].score;
        while (i <= j) {
            while (arr[uint256(i)].score > pivot) i++;
            while (pivot > arr[uint256(j)].score) j--;
            if (i <= j) {
                (arr[uint256(i)], arr[uint256(j)]) = (
                    arr[uint256(j)],
                    arr[uint256(i)]
                );
                i++;
                j--;
            }
        }
        if (left < j) quickSort(arr, left, j);
        if (i < right) quickSort(arr, i, right);
    }

    constructor(
        string memory _gameName,
        string memory _matchID,
        uint256 fee,
        player[] memory playersList
    ) {
        gameName = _gameName;
        matchID = _matchID;
        entryFee = fee;
        matchStatus = status.NOT_STARTED;
        owner = msg.sender;

        // Loading the players data and initializing with 0 kills, 0 assists, 0 mvps
        for (uint256 i = 0; i < playersList.length; i++) {
            players[playersList[i].playerId] = player(
                playersList[i].playerId,
                0,
                0,
                playersList[i].present
            );
        }
    }

    function enterGame(string[] memory teamList) public payable {
        require(
            matchStatus == status.ON_GOING && users[msg.sender] < 5,
            "Sorry! You have exceeded the number of entries or Game hasn't started"
        );
        require(msg.value == (entryFee * 1 wei), "Sorry! Incorrect entry fee");
        bool check = true;
        for (uint256 i = 0; i < teamList.length; i++) {
            if (players[teamList[i]].present == false) {
                check = false;
                break;
            }
        }
        require(check, "Sorry! Incorrect Team");
        entries.push(entry(msg.sender, teamList, 0));
        users[msg.sender]++;
        prizePool += uint256(msg.value);
    }

    function startGame() public onlyOwner {
        require(
            matchStatus == status.NOT_STARTED,
            "Sorry! Either the game has already started or it has ended"
        );
        matchStatus = status.ON_GOING;
    }

    function cancelGame() public onlyOwner {
        for (uint256 i = 0; i < entries.length; i++) {
            payable(entries[i].userAddress).transfer(entryFee * 1 wei);
        }
    }

    function endGame() public onlyOwner {
        require(
            matchStatus == status.ON_GOING,
            "Sorry! Either the game has not already started or it has ended"
        );
        matchStatus = status.ENDED;

        for (uint256 i = 0; i < entries.length; i++) {
            string[] memory data = entries[i].team;
            for (uint256 j = 0; j < data.length; j++) {
                entries[i].score +=
                    (players[data[j]].kills * 2) -
                    players[data[j]].deaths;
            }
        }
    }

    function updateScore(player[] memory data) public onlyOwner {
        require(
            matchStatus == status.ON_GOING,
            "Sorry! The hasn't started yet"
        );
        for (uint256 i = 0; i < data.length; i++) {
            if (players[data[i].playerId].present) {
                players[data[i].playerId].kills = data[i].kills;
                players[data[i].playerId].deaths = data[i].deaths;
            } else {
                revert();
            }
        }
    }

    function getWinnersList() public {
        require(
            matchStatus == status.ENDED,
            "Sorry! The Game hasn't ended yet ended"
        );
        entry[] memory data = sort(entries);
        for (uint256 i = 0; i < data.length; i++) {
            matchResult.push(data[i]);
        }
        matchStatus = status.COMPLETED;
    }

    function declareWinner() public onlyOwner {
        require(
            matchStatus == status.COMPLETED,
            "Sorry the winner list generation haven't been completed"
        );
        payable(matchResult[0].userAddress).transfer(prizePool * 1 wei);
    }

    function destroy() public onlyOwner {
        require(msg.sender == owner, "You are not the owner");
        selfdestruct(payable(owner));
    }

    receive() external payable {
        revert();
    }
}
