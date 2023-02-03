// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract OptimizedContract {
    uint256 public totalHeadCount;
    uint256 public totalBudget;

    struct Department {
        uint256 headCount;
        uint256 budget;
    }

    uint256 constant NUM_DEPTS = 20;

    Department[NUM_DEPTS + 1] departments;

    function setHeadCount(uint256 deptNum, uint256 newCount) external {
        if (deptNum == 0 || deptNum > NUM_DEPTS) revert InvalidDeptNum(deptNum);
        Department storage department = departments[deptNum];
        uint256 oldCount = department.headCount;
        if (newCount != oldCount) {
            department.headCount = newCount;
            totalHeadCount = newCount > oldCount
                ? totalHeadCount + (newCount - oldCount)
                : totalHeadCount - (oldCount - newCount);
        }
    }

    function setBudget(uint256 deptNum, uint256 newBudget) external {
        if (deptNum == 0 || deptNum > NUM_DEPTS) revert InvalidDeptNum(deptNum);
        Department storage department = departments[deptNum];
        uint256 oldBudget = department.budget;
        if (newBudget != oldBudget) {
            department.budget = newBudget;
            totalBudget = newBudget > oldBudget
                ? totalBudget + (newBudget - oldBudget)
                : totalBudget - (oldBudget - newBudget);
        }
    }

    function budgetPerHeadExceedsDept(uint256 deptNum, uint256 budgetPerHead)
        public
        view
        returns (bool)
    {
        if (deptNum == 0 || deptNum > NUM_DEPTS) revert InvalidDeptNum(deptNum);
        Department storage department = departments[deptNum];
        return
            department.headCount > 0 &&
            budgetPerHead > (department.budget / department.headCount);
    }

    function budgetPerHeadExceedsOverall(uint256 budgetPerHead)
        public
        view
        returns (bool)
    {
        return
            totalHeadCount > 0 &&
            budgetPerHead > (totalBudget / totalHeadCount);
    }

    function budgetPerHeadExceedsDeptOrOverall(
        uint256 deptNum,
        uint256 budgetPerHead
    ) external view returns (bool) {
        return
            budgetPerHeadExceedsOverall(budgetPerHead) ||
            budgetPerHeadExceedsDept(deptNum, budgetPerHead);
    }

    error InvalidDeptNum(uint256 deptNum);
}
