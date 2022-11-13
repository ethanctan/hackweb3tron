// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Surveys {
    
    struct Survey {
        address payable owner;
        address payable[] participants;
        uint256 limit;
        uint256 pool;
    }
    
    Survey[] public surveys; // List of surveys
    uint256 idCount = 0;
    
    function makeSurvey(uint256 surveyLimit) public returns(uint256) {
        
        Survey memory newSurvey = Survey({owner:payable(msg.sender), participants:new address payable[](0), limit:surveyLimit, pool:0});
        surveys.push(newSurvey);
        idCount++;
        return idCount - 1;
    }
    
    function fundSurvey(uint256 id) public payable { // fund reward pool for a survey
    
        require(
            msg.value > 1 trx,
            "You must fund your survey with at least 1 TRX"  
        );
        
        if (payable(msg.sender) == surveys[id].owner){
            surveys[id].pool += msg.value;
        } else {
            revert("You do not own any survey of that id.");
        } 
        
        
    } 
    
    function takeSurvey(uint256 id) public returns(uint256, uint256) { // record participant address in the survey's array. 
        
        for (uint i = 0; i < surveys[id].participants.length; i++) {
            if (msg.sender == surveys[id].participants[i]) {
                revert("You cannot take the same survey twice.");
            }
        }
        
        if (surveys[id].limit == surveys[id].participants.length) {
            revert("This survey's limit has been reached.");
        }
        
        surveys[id].participants.push(payable(msg.sender));
        
        return(surveys[id].participants.length, surveys[id].limit); // To reflect how many people have taken the survey on frontend
    }
    
    function terminateSurvey(uint256 id) public { // distribute survey rewards to current respondents.
        
        if (surveys[id].owner != payable(msg.sender)){ // Make sure only owner can call this function
            revert("You do not own any survey of that id.");
        }

        uint amount = surveys[id].pool / surveys[id].limit;
        uint totalamount = 0;
    
        for (uint i = 0; i < surveys[id].participants.length; i++) { // pay each participant
            surveys[id].participants[i].transfer(amount);
            totalamount = totalamount + amount;
        }
        payable(msg.sender).transfer(surveys[id].pool - totalamount);
        
    }
    
    
}
