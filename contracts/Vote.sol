pragma solidity ^0.5.6;

contract Vote {
    // Mappings
    mapping(uint => VoteInfo) public voteInfoes;
    mapping(uint => CandidateInfo) public candidateInfoes;
    
    struct VoteInfo {
        uint idx;
        string name;
        uint[] candidateIdxes;
    }
    struct CandidateInfo {
        uint idx;
        string name;
        uint voteCnt;
    }

    function getVote(uint _idx) public view returns (uint voteIdx, string memory voteName, uint[] memory candIdxes) {
      voteIdx = _idx;
      voteName = voteInfoes[_idx].name;
      candIdxes = voteInfoes[_idx].candidateIdxes;
    }
    
    function getCandidate(uint _idx) public view returns (uint candIdx, string memory candName, uint voteCnt) {
      candIdx = _idx;
      candName = candidateInfoes[_idx].name;
      voteCnt = candidateInfoes[_idx].voteCnt;
    }
    
    function addCandidate(uint _idx, string memory _name) public {
        // test commit3
        candidateInfoes[_idx] = CandidateInfo(_idx, _name, 0);
    }
    
    function addVote(uint _idx, string memory _name, uint[] memory candidates) public {
        voteInfoes[_idx] = VoteInfo(_idx, _name, candidates);
    }
    
    function vote(uint _candIdx) public {
        // test commit
        candidateInfoes[_candIdx].voteCnt += 1;
    }
}