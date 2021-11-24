pragma solidity ^0.5.6;

import "./utils/Ownable.sol";

contract Vote is Ownable {
    struct VoteInfo {
        uint256 idx;
        string name;
        uint256[] candidateIdxes;
        uint256 totalVoteCnt;
        uint256 startTime;
        uint256 endTime;
        uint8 status;
    }
    struct CandidateInfo {
        uint256 idx;
        string name;
        uint256 voteCnt;
        uint8 status;
    }

    enum VoteStatus {
        enable,
        disable
    }

    enum CandidateStatus {
        enable,
        disable
    }

    // Mappings
    mapping(uint256 => VoteInfo) private _voteInfoes;
    mapping(uint256 => CandidateInfo) private _candidateInfoes;

    uint256 private _voteIdx = 0;
    uint256 private _candIdx = 0;

    event AddVote(uint256 idx, string name, uint256 startTime, uint256 endTime); // prettier-ignore
    event AddCandidate(uint256 idx, string name);
    event UpdateVote(uint256 idx, string name, uint256 startTime, uint256 endTime, uint8 status); // prettier-ignore
    event UpdateCandidate(uint256 idx, string name, uint8 status);

    function _generateVoteIdx() internal returns (uint256) {
        return ++_voteIdx;
    }

    function _generateCandidateIdx() internal returns (uint256) {
        return ++_candIdx;
    }

    function getVote(uint256 idx)
        external
        view
        returns (
            uint256 voteIdx,
            string memory voteName,
            uint256[] memory candIdxes,
            uint256 totalVoteCnt,
            uint256 startTime,
            uint256 endTime,
            uint8 status
        )
    {
        voteIdx = idx;
        voteName = _voteInfoes[idx].name;
        candIdxes = _voteInfoes[idx].candidateIdxes;
        totalVoteCnt = _voteInfoes[idx].totalVoteCnt;
        startTime = _voteInfoes[idx].startTime;
        endTime = _voteInfoes[idx].endTime;
        status = _voteInfoes[idx].status;
    }

    function getCandidate(uint256 idx)
        external
        view
        returns (
            uint256 candIdx,
            string memory candName,
            uint256 voteCnt,
            uint8 status
        )
    {
        candIdx = idx;
        candName = _candidateInfoes[idx].name;
        voteCnt = _candidateInfoes[idx].voteCnt;
        status = _candidateInfoes[idx].status;
    }

    // prettier-ignore
    function addVote(string calldata name, uint256 startTime, uint256 endTime) external onlyOwner returns (uint256) {
        uint256 idx = _generateVoteIdx();
        uint256[] memory initCands;

        _voteInfoes[idx] = VoteInfo(idx, name, initCands, 0, startTime, endTime, uint8(VoteStatus.enable));

        emit AddVote(idx, name, startTime, endTime);

        return idx;
    }

    function addCandidate(uint256 voteIdx, string calldata name) external onlyOwner returns (uint256) {
        require(keccak256(bytes(_voteInfoes[voteIdx].name)) != keccak256(""), "Invalid Vote Index");

        // create candidateInfo
        uint256 idx = _generateCandidateIdx();
        _candidateInfoes[idx] = CandidateInfo(idx, name, 0, uint8(VoteStatus.enable));

        // add idx into voteInfo
        _voteInfoes[voteIdx].candidateIdxes.push(idx);

        emit AddCandidate(idx, name);

        return idx;
    }

    function _validVoteStatus(uint256 voteIdx) internal view returns (bool) {
        bool isValid = false;

        if (_voteInfoes[voteIdx].status == uint8(VoteStatus.enable)) {
            isValid = true;
        }

        return isValid;
    }

    function _validVoteTime(uint256 voteIdx) internal view returns (bool) {
        bool isValid = false;

        if (now >= _voteInfoes[voteIdx].startTime && now <= _voteInfoes[voteIdx].endTime) {
            isValid = true;
        }

        return isValid;
    }

    function _validVoteCandidate(uint256 voteIdx, uint256 candIdx) internal view returns (bool) {
        bool isValid = false;

        for (uint256 i = 0; i < _voteInfoes[voteIdx].candidateIdxes.length; i++) {
            if (_voteInfoes[voteIdx].candidateIdxes[i] == candIdx) {
                isValid = true;
                break;
            }
        }

        return isValid;
    }

    function _validCandidateStatus(uint256 candIdx) internal view returns (bool) {
        bool isValid = false;

        if (_candidateInfoes[candIdx].status == uint8(CandidateStatus.enable)) {
            isValid = true;
        }

        return isValid;
    }

    // prettier-ignore
    function vote(uint256 voteIdx, uint256 candIdx, bool renounce) external onlyOwner {
        require(_validVoteStatus(voteIdx) == true, "invalid vote status");
        require(_validCandidateStatus(candIdx) == true, "invalid candidate status");
        require(_validVoteTime(voteIdx) == true, "invalid vote time");
        if (!renounce) {
            require(_validVoteCandidate(voteIdx, candIdx) == true, "voteIdx & candIdx missmatch");
        }

        _voteInfoes[voteIdx].totalVoteCnt += 1;
        if (!renounce) {
            _candidateInfoes[candIdx].voteCnt += 1;
        }
    }

    // prettier-ignore
    function updateVote(uint256 voteIdx, string calldata name, uint256 startTime, uint256 endTime, uint8 status) external onlyOwner returns (bool) {
        require(keccak256(bytes(_voteInfoes[voteIdx].name)) != keccak256(""), "Invalid Vote Index");

        _voteInfoes[voteIdx].name = name;
        _voteInfoes[voteIdx].startTime = startTime;
        _voteInfoes[voteIdx].endTime = endTime;
        _voteInfoes[voteIdx].status = status;

        emit UpdateVote(voteIdx, name, startTime, endTime, status);

        return true;
    }

    // prettier-ignore
    function updateCandidate(uint256 voteIdx, uint256 candIdx, string calldata name, uint8 status) external onlyOwner returns (bool) {
        require(keccak256(bytes(_voteInfoes[voteIdx].name)) != keccak256(""), "Invalid Vote Index");
        require(keccak256(bytes(_candidateInfoes[candIdx].name)) != keccak256(""), "Invalid Candidate Index");

        _candidateInfoes[candIdx].name = name;
        _candidateInfoes[candIdx].status = status;

        // remove candidate index in voteInfo
        if (status == uint8(CandidateStatus.disable)) {
            for (uint256 i = 0; i < _voteInfoes[voteIdx].candidateIdxes.length; i++) {
                if (_voteInfoes[voteIdx].candidateIdxes[i] == candIdx) {
                    _voteInfoes[voteIdx].candidateIdxes[i] = _voteInfoes[voteIdx].candidateIdxes[_voteInfoes[voteIdx].candidateIdxes.length - 1];
                    _voteInfoes[voteIdx].candidateIdxes.pop();
                    break;
                }
            }
        }

        emit UpdateCandidate(candIdx, name, status);

        return true;
    }
}
