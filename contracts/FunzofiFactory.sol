//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import './Funzofi.sol';

contract FunzofiFactory {

    address public owner;
    Funzofi[] public FunzofiArray;

    constructor() {
        owner = msg.sender;
    }

    function createNewGame(string memory gameName, string memory description, uint fee, string[] memory playersList) public {
        Funzofi game = new Funzofi(
            gameName,
            description,
            fee,
            playersList
        );
        FunzofiArray.push(game);
    }

    

}