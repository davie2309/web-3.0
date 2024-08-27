// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GroupProject {

    struct Member {
        address memberAddress;
        uint256 contribution; // Represents contribution as a percentage (e.g., 50 for 50%)
        bool hasContributed;
    }

    address public instructor;
    mapping(address => Member) public members;
    address[] public memberAddresses;
    bool public gradingComplete;

    modifier onlyInstructor() {
        require(msg.sender == instructor, "Only the instructor can perform this action");
        _;
    }

    modifier onlyMember() {
        require(members[msg.sender].memberAddress != address(0), "Only a member can perform this action");
        _;
    }

    modifier gradingNotComplete() {
        require(!gradingComplete, "Grading is already complete");
        _;
    }

    event ContributionRecorded(address member, uint256 contribution);
    event GradesDistributed();

    constructor(address[] memory _members) {
        instructor = msg.sender;
        for (uint256 i = 0; i < _members.length; i++) {
            members[_members[i]] = Member({
                memberAddress: _members[i],
                contribution: 0,
                hasContributed: false
            });
            memberAddresses.push(_members[i]);
        }
    }

    function recordContribution(uint256 _contribution) public onlyMember gradingNotComplete {
        require(_contribution <= 100, "Contribution cannot exceed 100%");
        require(!members[msg.sender].hasContributed, "Contribution already recorded");

        members[msg.sender].contribution = _contribution;
        members[msg.sender].hasContributed = true;

        emit ContributionRecorded(msg.sender, _contribution);
    }

    function distributeGrades(uint256 _totalGrade) public onlyInstructor gradingNotComplete {
        require(_totalGrade <= 100, "Total grade cannot exceed 100%");
        
        for (uint256 i = 0; i < memberAddresses.length; i++) {
            address memberAddr = memberAddresses[i];
            uint256 memberContribution = members[memberAddr].contribution;
            uint256 memberGrade = (_totalGrade * memberContribution) / 100;
            
            // Here you would implement logic to distribute the grade to the member
            // For example, updating a member's record in a grading system
        }

        gradingComplete = true;
        emit GradesDistributed();
    }

    function getMemberContribution(address _member) public view returns (uint256) {
        return members[_member].contribution;
    }

    function hasMemberContributed(address _member) public view returns (bool) {
        return members[_member].hasContributed;
    }

    function isGradingComplete() public view returns (bool) {
        return gradingComplete;
    }
}
