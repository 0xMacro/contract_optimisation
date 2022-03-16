// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract PartiallyOptimizedContract {
    
    uint public totalHeadCount;
    uint public totalBudget;

    struct Department {
        uint headCount;
        uint budget;
    }

    uint constant NUM_DEPTS = 20;
        
    Department[NUM_DEPTS + 1] departments;

    function setHeadCount(uint deptNum, uint newCount) public {
        require(deptNum > 0 && deptNum <= NUM_DEPTS, "invalid deptNum");
        Department storage department = departments[deptNum];
        department.headCount = newCount;
        departments[deptNum] = department;
        updateTotalHeadCount();
    }

    function setBudget(uint deptNum, uint newBudget) public {
        require(deptNum > 0 && deptNum <= NUM_DEPTS, "invalid deptNum");
        Department storage department = departments[deptNum];
        department.budget = newBudget;
        departments[deptNum] = department;
        updateTotalBudget();
    }

    function updateTotalHeadCount() private {
        totalHeadCount = 0;
        for ( uint deptNum = 1 ; deptNum <= NUM_DEPTS  ; deptNum++) {
            Department storage department = departments[deptNum];
            totalHeadCount += department.headCount; 
        }
    }

    function updateTotalBudget() private {
        totalBudget = 0;
        for ( uint deptNum = 1 ; deptNum <= NUM_DEPTS  ; deptNum++) {
            Department storage department = departments[deptNum];
            totalBudget += department.budget; 
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
        require(deptNum > 0 && deptNum <= NUM_DEPTS, "invalid deptNum");
        return perHeadRateExceedsOverallMean(rate) || perHeadRateExceedsDeptMean(deptNum, rate);
    }

}
