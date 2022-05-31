//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import './Funzofi.sol';

contract Factory {
    Funzofi[] public FunzofiGames;
    event GameCreated(
        uint id,
        address gameAddress
    );

    function createGame(string memory _gameName, string memory _description, uint _fee, string[] memory _playersList) external {
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
}