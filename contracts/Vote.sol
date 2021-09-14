pragma solidity ^0.5.6;

contract Vote {
    // Mappings
    mapping(uint256 => VoteInfo) public voteInfoes;
    mapping(uint256 => CandidateInfo) public candidateInfoes;

    struct VoteInfo {
        uint256 idx;
        string name;
        uint256[] candidateIdxes;
    }
    struct CandidateInfo {
        uint256 idx;
        string name;
        uint256 voteCnt;
    }

    // prettier-ignore
    function getVote(uint _idx) public view returns (uint256 voteIdx, string memory voteName, uint256[] memory candIdxes) {
        voteIdx = _idx;
        voteName = voteInfoes[_idx].name;
        candIdxes = voteInfoes[_idx].candidateIdxes;
    }

    // prettier-ignore
    function getCandidate(uint256 _idx) public view returns (uint256 candIdx, string memory candName, uint256 voteCnt) {
        candIdx = _idx;
        candName = candidateInfoes[_idx].name;
        voteCnt = candidateInfoes[_idx].voteCnt;
    }

    function addCandidate(uint256 _idx, string memory _name) public {
        candidateInfoes[_idx] = CandidateInfo(_idx, _name, 0);
    }

    // prettier-ignore
    function addVote(uint256 _idx, string memory _name, uint256[] memory candidates) public {
        voteInfoes[_idx] = VoteInfo(_idx, _name, candidates);
    }

    function vote(uint256 _candIdx) public {
        candidateInfoes[_candIdx].voteCnt += 1;
    }
}
