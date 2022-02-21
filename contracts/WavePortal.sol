// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
    uint256 private seed;

    

    /**
    * Declares a new event
    */
    event NewWave(address indexed from, uint256 timestamp, string message);

    /**
    * Creates a new struct to store wave
    */
    struct Wave {
        address from;       
        string message;
        uint256 timestamp;
    }

    /*
     * This is an address => uint mapping, meaning I can associate an address with a number!
     * In this case, I'll be storing the address with the last time the user waved at us.
     */
    mapping(address => uint256) public lastWavedAt;
    
    Wave[] waves;

    constructor() payable {
        console.log("Yeah, this is a cool smart contract");

        /*
         * Set the initial seed
         */
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {
        /*
         * We need to make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored
         */
        require(
            lastWavedAt[msg.sender] + 30 seconds < block.timestamp,
            "Must wait 30 seconds before waving again."
        );

        /*
         * Update the current timestamp we have for the user
         */
        lastWavedAt[msg.sender] = block.timestamp;

        // console.log("last waved", lastWavedAt[msg.sender] + 15 minutes);
        // console.log("timestamp", block.timestamp);
        
        totalWaves++;

        // saves the waver address in wavers array
        waves.push(Wave({from:msg.sender, message:_message, timestamp: block.timestamp}));
        console.log("%s just waved at you! saying %s", msg.sender, _message);

        /*
         * Generate a new seed for the next user that sends a wave
         */
        seed = (block.difficulty + block.timestamp + seed) % 100;

        console.log("Random # generated: %d", seed);

        /*
         * Give a 50% chance that the user wins the prize.
         */
        if (seed <= 50) {
            console.log("%s won!", msg.sender);

            /*
             * The same code we had before to send the prize.
             */
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        // emits a NewWave event to notify client that a new wave has been created
        emit NewWave(msg.sender, block.timestamp, _message);

    }

// Get total waves
    function getTotalWaves() public view returns (uint256) {
        console.log("The total number of waves we have received so far is %s", totalWaves);
        return totalWaves;
    }

// Get all the people that waved
    function getListOfWavers() public view returns (Wave[] memory) {
        console.log("The list of wavers are");
        return waves;
    }
}