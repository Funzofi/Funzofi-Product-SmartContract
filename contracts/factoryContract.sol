//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Cricket.sol";
import "./CSGO.sol";

contract FunzofiFactory {
    //to store various gamses of various kinds
    Cricket[] public cricketGames; //for Cricket games
    CSGO[] public csgoGames; //for CSGO games
    address public owner;

    event Received(address, uint256);
    event GameCreated(uint256 id, address gameAddress);

    modifier onlyOwner() {
        require(owner == msg.sender, "Sorry the owner can only access");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    //create a game for Cricket
    function createCricketGame(
        string memory _gameName,
        string memory _description,
        uint256 _fee,
        Cricket.player[] memory _playersList
    ) public onlyOwner {
        Cricket game = new Cricket(_gameName, _description, _fee, _playersList);
        cricketGames.push(game);
        emit GameCreated(cricketGames.length - 1, address(game));
    }

    //create a game for CSGO
    function createCsgoGame(
        string memory _gameName,
        string memory _description,
        uint256 _fee,
        CSGO.player[] memory _playersList
    ) public onlyOwner {
        CSGO game = new CSGO(_gameName, _description, _fee, _playersList);
        csgoGames.push(game);
        emit GameCreated(csgoGames.length - 1, address(game));
    }

    //to compare two strings
    function compareStrings(string memory a, string memory b)
        public
        pure
        returns (bool)
    {
        return (keccak256(abi.encodePacked((a))) ==
            keccak256(abi.encodePacked((b))));
    }

    //to get all the Cricket games
    function getCricketGames() public view returns (Cricket[] memory) {
        return cricketGames;
    }

    //to get all the CSGO games
    function getCsgoGames() public view returns (CSGO[] memory) {
        return csgoGames;
    }

    //to start a game
    function startGame(uint256 _gameIndex, string memory _gameName)
        public
        onlyOwner
    {
        if (compareStrings(_gameName, "Cricket"))
            Cricket(payable(address(cricketGames[_gameIndex]))).startGame();
        else if (compareStrings(_gameName, "CSGO"))
            CSGO(payable(address(csgoGames[_gameIndex]))).startGame();
    }

    //to cancel a game
    function cancelGame(uint256 _gameIndex, string memory _gameName)
        public
        onlyOwner
    {
        if (compareStrings(_gameName, "Cricket"))
            Cricket(payable(address(cricketGames[_gameIndex]))).cancelGame();
        else if (compareStrings(_gameName, "CSGO"))
            CSGO(payable(address(csgoGames[_gameIndex]))).cancelGame();
    }

    //to end a game
    function endGame(uint256 _gameIndex, string memory _gameName)
        public
        onlyOwner
    {
        if (compareStrings(_gameName, "Cricket"))
            Cricket(payable(address(cricketGames[_gameIndex]))).endGame();
        else if (compareStrings(_gameName, "CSGO"))
            CSGO(payable(address(csgoGames[_gameIndex]))).endGame();
    }

    //to update scores for the Cricket game of the given index
    function updateCricketScore(
        uint256 _gameIndex,
        Cricket.player[] memory _data
    ) public onlyOwner {
        Cricket(payable(address(cricketGames[_gameIndex]))).updateScore(_data);
    }

    //to update scores for the CSGO game of the given index
    function updateCsgoScore(uint256 _gameIndex, CSGO.player[] memory _data)
        public
        onlyOwner
    {
        CSGO(payable(address(csgoGames[_gameIndex]))).updateScore(_data);
    }

    //to declare the winner of a game
    function declareGameWinner(uint256 _gameIndex, string memory _gameName)
        public
        onlyOwner
    {
        if (compareStrings(_gameName, "Cricket"))
            Cricket(payable(address(cricketGames[_gameIndex]))).declareWinner();
        else if (compareStrings(_gameName, "CSGO"))
            CSGO(payable(address(csgoGames[_gameIndex]))).declareWinner();
    }

    //to get the ranking list according to the score
    function generateWinners(uint256 _gameIndex, string memory _gameName)
        public
        onlyOwner
    {
        if (compareStrings(_gameName, "Cricket"))
            Cricket(payable(address(cricketGames[_gameIndex])))
                .getWinnersList();
        else if (compareStrings(_gameName, "CSGO"))
            CSGO(payable(address(csgoGames[_gameIndex]))).getWinnersList();
    }

    function getBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    function withdrawBalance(uint256 _amount) public onlyOwner {
        payable(owner).transfer(_amount * 1 wei);
    }

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }
}
