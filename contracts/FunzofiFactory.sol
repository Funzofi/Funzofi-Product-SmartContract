//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import './Funzofi.sol';

contract FunzofiFactory {
    Funzofi[] public FunzofiGames;
    address public owner;

    event Received(
        address, 
        uint
    );
    event GameCreated(
        uint id,
        address gameAddress
    );

    modifier onlyOwner(){
        require(
            owner == msg.sender,
            "Sorry the owner can only access"
        );
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createGame(string memory _gameName, string memory _description, uint _fee, Funzofi.player[] memory _playersList) public onlyOwner {
        Funzofi game = new Funzofi(
            _gameName,
            _description,
            _fee,
            _playersList
        );
        FunzofiGames.push(game);
        emit GameCreated(
            FunzofiGames.length - 1,
            address(game)
        );
    }

    function getGames() public view returns(Funzofi[] memory) {
        return FunzofiGames;
    }

    function startGame(uint _gameIndex) public onlyOwner {
        Funzofi(payable(address(FunzofiGames[_gameIndex]))).startGame();
    }

    function cancelGame(uint _gameIndex) public onlyOwner {
        Funzofi(payable(address(FunzofiGames[_gameIndex]))).cancelGame();
    }

    function endGame(uint _gameIndex) public onlyOwner {
        Funzofi(payable(address(FunzofiGames[_gameIndex]))).endGame();
    }

    function updateScore(uint _gameIndex, Funzofi.player[] memory _data) public onlyOwner {
        Funzofi(payable(address(FunzofiGames[_gameIndex]))).updateScore(_data);
    }

    function declareGameWinner(uint _gameIndex) public onlyOwner {
        Funzofi(payable(address(FunzofiGames[_gameIndex]))).declareWinner();
    }

    function generateWinners(uint _gameIndex) public onlyOwner {
        Funzofi(payable(address(FunzofiGames[_gameIndex]))).getWinnersList();
    }

    function getBalance() public onlyOwner view returns(uint) {
        return address(this).balance;
    }

    function withdrawBalance(uint _amount) public onlyOwner {
        payable(owner).transfer(_amount * 1 wei);
    }

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }
}