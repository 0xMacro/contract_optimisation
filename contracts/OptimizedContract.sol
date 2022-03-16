// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract OptimizedContract {
    
    uint public totalHeadCount;
    uint public totalBudget;

    struct Department {
        uint headCount;
        uint budget;
    }
        
    uint constant NUM_DEPTS = 20;
        
    Department[NUM_DEPTS + 1] departments;

    function setHeadCount(uint deptNum, uint newCount) external {
        require(deptNum > 0 && deptNum <= NUM_DEPTS, "invalid deptNum");
        Department storage department = departments[deptNum];
        uint oldCount = department.headCount;
        if (newCount != oldCount) {
            department.headCount = newCount;
            totalHeadCount = newCount > oldCount ?
                totalHeadCount + (newCount - oldCount) :
                totalHeadCount - (oldCount - newCount);
        }
    }

    function setBudget(uint deptNum, uint newBudget) external {
        require(deptNum > 0 && deptNum <= NUM_DEPTS, "invalid deptNum");
        Department storage department = departments[deptNum];
        uint oldBudget = department.budget;
        if (newBudget != oldBudget) {
            department.budget = newBudget;
            totalBudget = newBudget > oldBudget ?
                totalBudget + (newBudget - oldBudget) :
                totalBudget - (oldBudget - newBudget);
        }
    }

    function perHeadRateExceedsDeptMean(uint deptNum, uint rate) public view returns (bool)
    {
        require(deptNum > 0 && deptNum <= NUM_DEPTS, "invalid deptNum");
        Department storage department = departments[deptNum];
        return department.headCount > 0 && rate > ( department.budget / department.headCount );
    }
    
    function perHeadRateExceedsOverallMean(uint rate) public view returns (bool)
    {
        return totalHeadCount > 0 && rate > ( totalBudget / totalHeadCount );
    }
    
    function perHeadRateExceedsDeptOrOverallMean(uint deptNum, uint rate) external view returns (bool) {
        return perHeadRateExceedsDeptMean(deptNum, rate) || perHeadRateExceedsOverallMean(rate);
    }

}
