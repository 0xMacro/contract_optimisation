const { expect } = require("chai")

describe("optimization comparison", function () {

  let Unoptimized
  let PartiallyOptimized
  let Optimized

  const headCounts = [5, 6, 8, 3, 24, 67, 34, 4, 21, 87, 22, 3, 11, 46, 2, 44, 87, 12, 45, 21]
  const budgets = ["3.5", "4.6", "12", "0.3", "1.1", "29.5", "234", "23", "16", "7", "19", "6", "4", "4", "2.4", "45", "12", "78", "2", "0.5"]

  beforeEach(async function () {
    const OptimizedFactory = await ethers.getContractFactory("OptimizedContract")
    const PartiallyOptimizedFactory = await ethers.getContractFactory("PartiallyOptimizedContract")
    const UnoptimizedFactory = await ethers.getContractFactory("UnoptimizedContract")
    Optimized = await OptimizedFactory.deploy()
    PartiallyOptimized = await PartiallyOptimizedFactory.deploy()
    Unoptimized = await UnoptimizedFactory.deploy()
    await Optimized.deployed()
    await PartiallyOptimized.deployed()
    await Unoptimized.deployed()
    for (let deptNum = 1; deptNum < 21; deptNum++) {
      await Optimized.setHeadCount(deptNum, 1)
      await Optimized.setBudget(deptNum, ethers.utils.parseEther("1"))
      await PartiallyOptimized.setHeadCount(deptNum, 1)
      await PartiallyOptimized.setBudget(deptNum, ethers.utils.parseEther("1"))
      await Unoptimized.setHeadCount(deptNum, 1)
      await Unoptimized.setBudget(deptNum, ethers.utils.parseEther("1"))
    }
  })

  it("should start with head count of 20", async function () {
    expect(await Optimized.totalHeadCount()).to.equal(20)
    expect(await PartiallyOptimized.totalHeadCount()).to.equal(20)
    expect(await Unoptimized.totalHeadCount()).to.equal(20)
  })

  it("perform a longer series of ops", async function () {
    for (let deptNum = 1; deptNum < 21; deptNum++) {
      await Optimized.setHeadCount(deptNum, headCounts[deptNum - 1])
      await Optimized.setBudget(deptNum, ethers.utils.parseEther(budgets[deptNum - 1]))
      await PartiallyOptimized.setHeadCount(deptNum, headCounts[deptNum - 1])
      await PartiallyOptimized.setBudget(deptNum, ethers.utils.parseEther(budgets[deptNum - 1]))
      await Unoptimized.setHeadCount(deptNum, headCounts[deptNum - 1])
      await Unoptimized.setBudget(deptNum, ethers.utils.parseEther(budgets[deptNum - 1]))
    }
  }) 

})
