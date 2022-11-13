// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Survey {
    
    address payable public owner;
    address payable[] public participants;
    uint256 limit;
    
    constructor(uint initialLimit) {
        owner = payable(msg.sender);
        limit = initialLimit;
    }
    
    function fundPool() public payable onlyOwner { // fund reward pool
        require(
            msg.value > 1 trx,
            "You must fund your survey with at least 1 TRX"  
        );
    } 
    
    function takeSurvey() public { // record participant address in the array
        bool repeatCheck = false;
        
        for (uint i = 0; i < participants.length; i++) {
            if (msg.sender == participants[i]) {
                repeatCheck = true;
            }
        }
        
        if (repeatCheck == false) {
            participants.push(payable(msg.sender));
        } else {
            revert("You cannot take the same survey twice.");
        }
        
    }
    
    function terminateSurvey() public onlyOwner { // distribute survey rewards to current respondents
        for (uint i = 0; i < participants.length; i++) { // pay each participant
            participants[i].transfer(address(this).balance / limit);
        }
        
        owner.transfer(address(this).balance);
    }
    
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }
    
}
