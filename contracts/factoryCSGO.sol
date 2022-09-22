//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./CSGO.sol";

contract CSGOFactory {
    CSGO[] public CSGOGames;
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

    function createGame(
        string memory _gameName,
        string memory _description,
        uint256 _fee,
        CSGO.player[] memory _playersList
    ) public onlyOwner {
        CSGO game = new CSGO(_gameName, _description, _fee, _playersList);
        CSGOGames.push(game);
        emit GameCreated(CSGOGames.length - 1, address(game));
    }

    function getGames() public view returns (CSGO[] memory) {
        return CSGOGames;
    }

    function startGame(uint256 _gameIndex) public onlyOwner {
        CSGO(payable(address(CSGOGames[_gameIndex]))).startGame();
    }

    function cancelGame(uint256 _gameIndex) public onlyOwner {
        CSGO(payable(address(CSGOGames[_gameIndex]))).cancelGame();
    }

    function endGame(uint256 _gameIndex) public onlyOwner {
        CSGO(payable(address(CSGOGames[_gameIndex]))).endGame();
    }

    function updateScore(uint256 _gameIndex, CSGO.player[] memory _data)
        public
        onlyOwner
    {
        CSGO(payable(address(CSGOGames[_gameIndex]))).updateScore(_data);
    }

    function declareGameWinner(uint256 _gameIndex) public onlyOwner {
        CSGO(payable(address(CSGOGames[_gameIndex]))).declareWinner();
    }

    function generateWinners(uint256 _gameIndex) public onlyOwner {
        CSGO(payable(address(CSGOGames[_gameIndex]))).getWinnersList();
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
