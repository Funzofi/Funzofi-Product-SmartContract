//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Cricket.sol";

contract CricketFactory {
    Cricket[] public CricketGames;
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
        Cricket.player[] memory _playersList
    ) public onlyOwner {
        Cricket game = new Cricket(_gameName, _description, _fee, _playersList);
        CricketGames.push(game);
        emit GameCreated(CricketGames.length - 1, address(game));
    }

    function getGames() public view returns (Cricket[] memory) {
        return CricketGames;
    }

    function startGame(uint256 _gameIndex) public onlyOwner {
        Cricket(payable(address(CricketGames[_gameIndex]))).startGame();
    }

    function cancelGame(uint256 _gameIndex) public onlyOwner {
        Cricket(payable(address(CricketGames[_gameIndex]))).cancelGame();
    }

    function endGame(uint256 _gameIndex) public onlyOwner {
        Cricket(payable(address(CricketGames[_gameIndex]))).endGame();
    }

    function updateScore(uint256 _gameIndex, Cricket.player[] memory _data)
        public
        onlyOwner
    {
        Cricket(payable(address(CricketGames[_gameIndex]))).updateScore(_data);
    }

    function declareGameWinner(uint256 _gameIndex) public onlyOwner {
        Cricket(payable(address(CricketGames[_gameIndex]))).declareWinner();
    }

    function generateWinners(uint256 _gameIndex) public onlyOwner {
        Cricket(payable(address(CricketGames[_gameIndex]))).getWinnersList();
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
