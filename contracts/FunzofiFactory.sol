//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import './Funzofi.sol';

contract Factory {
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

    constructor() {
        owner = msg.sender;
    }

    function createGame(string memory _gameName, string memory _description, uint _fee, string[] memory _playersList) public {
        Funzofi game = new Funzofi(
            _gameName,
            _description,
            _fee,
            _playersList
        );
        FunzofiGames.push(game);
        emit GameCreated(
            FunzofiGames.length,
            address(game)
        );
    }

    function startGame(uint _gameIndex) public {
        Funzofi(payable(address(FunzofiGames[_gameIndex]))).startGame();
    }

    function cancelGame(uint _gameIndex) public {
        Funzofi(payable(address(FunzofiGames[_gameIndex]))).cancelGame();
    }

    function endGame(uint _gameIndex) public {
        Funzofi(payable(address(FunzofiGames[_gameIndex]))).endGame();
    }

    function updateScore(uint _gameIndex, Funzofi.player[] memory _data) public {
        Funzofi(payable(address(FunzofiGames[_gameIndex]))).updateScore(_data);
    }

    function declareGameWinner(uint _gameIndex) public {
        Funzofi(payable(address(FunzofiGames[_gameIndex]))).declareWinner();
    }

    function generateWinners(uint _gameIndex) public {
        Funzofi(payable(address(FunzofiGames[_gameIndex]))).getWinnersList();
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function withdrawBalance(uint _amount) public {
        payable(owner).transfer(_amount * 1 wei);
    }

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }
}