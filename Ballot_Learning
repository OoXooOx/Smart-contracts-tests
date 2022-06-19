// SPDX-License-Identifier: MTI

pragma solidity >=0.7.0 <0.9.0;

contract Ballotlearning {
    address owner = msg.sender;
    
    struct Voter {
        string FirstName;
        string LastName;
        uint age;
    }  

    mapping (address => Voter)  Voters;

    address []  public addrVoters;
    address []  public addrVoteAlready;

    function addVoter (address _addrVoter, string memory _FirstName, string memory _LastName, uint _age) public returns (string memory) {
        require (msg.sender == owner, "you are not an owner!");
        for (uint i = 0; i < addrVoters.length; i ++){
            if (_addrVoter == addrVoters[i]) {
                return "This address already add!";
            }
        }

        // Voter storage newVoter = Voters[_addrVoter];
        // newVoter.FirstName = _FirstName;
        // newVoter.LastName = _LastName;
        // newVoter.age = _age; // FIRST METHOD

        Voters [_addrVoter] = Voter ({
            FirstName: _FirstName,
            LastName: _LastName,
            age: _age
        }); //        SECOND METHOD
        addrVoters.push(_addrVoter);
        return "Succes add voter!";
    }

    function getVoterInfo (address _addrVoter) public view returns (string memory, string memory, uint) {
        require (msg.sender == owner, "you are not an owner!");
        return (Voters[_addrVoter].FirstName, Voters[_addrVoter].LastName, Voters[_addrVoter].age);
    }

    string  [] public Proposals;


    
    // function addProposal (string memory Proposal_1, string memory Proposal_2,string memory Proposal_3,string memory Proposal_4,
    // string memory Proposal_5,string memory Proposal_6,string memory Proposal_7,string memory Proposal_8,string memory Proposal_9,
    // string memory Proposal_10)  public {
    //     require (msg.sender == owner, "you are not an owner!");
    //     Proposals [0] = Proposal_1; Proposals [1] = Proposal_2; Proposals [2] = Proposal_3; Proposals [3] = Proposal_4;
    //     Proposals [4] = Proposal_5; Proposals [5] = Proposal_6; Proposals [6] = Proposal_7; Proposals [7] = Proposal_8;
    //     Proposals [8] = Proposal_9; Proposals [9] = Proposal_10;
    // }
    
    function addProposal (string [] memory ProposalsNames) public {
       require (msg.sender == owner, "you are not an owner!");
       for (uint i=0; i < ProposalsNames.length; i++) {
           Proposals.push(ProposalsNames[i]);
        }
    } // ["do","see", "look", "come", "want", "give","use", "find","tell","ask","work"]


    mapping (address => uint) public VoteMap;

    uint public voteNumber;
    uint [] VotesforProposal1;    uint [] VotesforProposal2;    uint [] VotesforProposal3;
    uint [] VotesforProposal4;    uint [] VotesforProposal5;    uint [] VotesforProposal6;
    uint [] VotesforProposal7;    uint [] VotesforProposal8;    uint [] VotesforProposal9;
    uint [] VotesforProposal10;
       

    function size() public view returns(uint, uint, uint,uint,uint,uint,uint,uint,uint,uint) {
            return (VotesforProposal1.length,  VotesforProposal2.length, VotesforProposal3.length, VotesforProposal4.length,
            VotesforProposal5.length,  VotesforProposal6.length, VotesforProposal7.length, VotesforProposal8.length, 
            VotesforProposal9.length, VotesforProposal10.length);
    }

    function addVote (uint _numberProposal) internal { 
        if (_numberProposal-1 == 0) {
                VotesforProposal1.push(_numberProposal);
            }
        if (_numberProposal-1 == 1) {
                VotesforProposal2.push(_numberProposal);
            }
        if (_numberProposal-1 == 2) {
                VotesforProposal3.push(_numberProposal);
            }
        if (_numberProposal-1 == 3) {
                VotesforProposal4.push(_numberProposal);
            }
        if (_numberProposal-1 == 4) {
                VotesforProposal5.push(_numberProposal);
            }
        if (_numberProposal-1 == 5) {
                VotesforProposal6.push(_numberProposal);
            }
        if (_numberProposal-1 == 6) {
                VotesforProposal7.push(_numberProposal);
            }
        if (_numberProposal-1 == 7) {
                VotesforProposal8.push(_numberProposal);
            }
        if (_numberProposal-1 == 8) {
                VotesforProposal9.push(_numberProposal);
            }
        if (_numberProposal-1 == 9) {
                VotesforProposal10.push(_numberProposal);
            }       
    }

    function vote (uint _numberProposal) internal returns (string memory) {
        for (uint i = 0; i < addrVoteAlready.length; i ++){
            if (msg.sender == addrVoteAlready[i]) {
                return "You have already voted!";
            }             
        }
        require (_numberProposal <= Proposals.length -1, "There is no such Proposal!");
        require (_numberProposal > 0, "There is no such Proposal!");
        addrVoteAlready.push(msg.sender);
        VoteMap [msg.sender] = _numberProposal;
        addVote(_numberProposal);
        
    }

    function makeVote (uint _numberProposal) public returns (string memory) {
    for (uint i = 0; i < addrVoters.length; i ++){
        if (msg.sender == addrVoters[i]) {
            vote(_numberProposal);
            return "succes!";
            }          
        }
        return "You do not have the right to vote!";
    }

    function sizeAddrVoters () public view returns (uint){
        return addrVoters.length;
    }
    
 
} 
