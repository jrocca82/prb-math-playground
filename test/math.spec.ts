import chai, { expect } from "chai";
import chaiAsPromised from "chai-as-promised";
import { ethers } from "hardhat";
import { PANIC_CODES } from "@nomicfoundation/hardhat-chai-matchers/panic";
import { Math, Math__factory, PRBMathTest__factory, PRBMathTest, PRBToken__factory, PRBToken, SafeToken__factory, SafeToken } from "../typechain-types";
import { Wallet } from "ethers";

chai.use(chaiAsPromised);
const bnOne = ethers.utils.parseEther("5");
const bnTwo = ethers.utils.parseEther("4");
const bnThree = ethers.utils.parseEther("20");

const setupEnvironment = async () => {
  const mathFactory: Math__factory = await ethers.getContractFactory(
    "Math"
  );

  const math = (await mathFactory.deploy()) as unknown as Math;

  const prbFactory: PRBMathTest__factory = await ethers.getContractFactory(
    "PRBMathTest"
  );

  const prb = (await prbFactory.deploy()) as unknown as PRBMathTest;

  const prbTokenFactory: PRBToken__factory = await ethers.getContractFactory(
    "PRBToken"
  );

  const prbToken = (await prbTokenFactory.deploy()) as unknown as PRBToken;

  const safeTokenFactory: SafeToken__factory = await ethers.getContractFactory(
    "SafeToken"
  );

  const safeToken = (await safeTokenFactory.deploy()) as unknown as SafeToken;

  return { math, prb, prbToken, safeToken };
};

describe("Transfer Tests", () => {
  let math: Math;
  let prb: PRBMathTest;

  before(async () => {
    const env = await setupEnvironment();
    math = env.math;
    prb = env.prb;
  });

  it("Should multiply", async () => {
    await math.multiply(bnOne, bnTwo);
    const math_result = await math.result();

    await prb.prbMultiply(bnOne, bnTwo);
    const prb_result = await prb.result();

    console.log("MATH MULT TEST", Number(ethers.utils.formatEther(math_result)));
    console.log("PRB MULT TEST", Number(ethers.utils.formatEther(prb_result)));
  });

  it("Should divide", async () => {
    await math.divide(bnThree, bnOne);
    const math_result = await math.result();

    await prb.prbDivide(bnThree, bnOne);
    const prb_result = await prb.result();

    console.log("MATH DIV TEST", Number(ethers.utils.formatEther(math_result)));
    console.log("PRB DIV TEST", Number(ethers.utils.formatEther(prb_result)));
  });

  it("Should get average", async () => {
    await math.average(bnThree, bnOne);
    const math_result = await prb.result();

    await prb.prbAvg(bnThree, bnOne);
    const prb_result = await prb.result();

    console.log("MATH AVG TEST", Number(ethers.utils.formatEther(math_result)));
    console.log("PRB AVG TEST", Number(ethers.utils.formatEther(prb_result)));
  });
});

describe("Mint Tests", () => {
  let prbToken: PRBToken;
  let safeToken: SafeToken;
  let bob: Wallet, charlie: Wallet;

  before(async () => {
    const env = await setupEnvironment();
    bob = ethers.Wallet.createRandom();
    charlie = ethers.Wallet.createRandom();
    prbToken = env.prbToken;
    safeToken= env.safeToken;
  });

  it("Should mint 90% to bob, 10% to charlie", async () => {
    const amount = ethers.utils.parseEther("100");

    //Percentage is 90%
    const percentage = ethers.utils.parseEther("0.9");
    await prbToken.prbSplit(bob.address, charlie.address, amount, percentage);
    const bobBalance = await prbToken.balanceOf(bob.address);
    const charlieBalance = await prbToken.balanceOf(charlie.address);

    expect(Number(ethers.utils.formatEther(bobBalance))).to.equal(90);
    expect(Number(ethers.utils.formatEther(charlieBalance))).to.equal(10);
  });

  it("Should be safe math", async () => {
    const amount = ethers.utils.parseEther("100");

    //Percentage is 90%
    const percentage = ethers.utils.parseEther("0.9");
    await expect(safeToken.safeSplit(bob.address, charlie.address, amount, percentage)).to.revertedWithPanic(PANIC_CODES.ARITHMETIC_UNDER_OR_OVERFLOW);
    const bobBalance = await safeToken.balanceOf(bob.address);
    console.log("Safe bob", Number(ethers.utils.formatEther(bobBalance))); // 0
  });

  it("Should overflow with normal math", async () => {
    const amount = ethers.utils.parseEther("100");

    //Percentage is 90%
    const percentage = ethers.utils.parseEther("0.9");
    await expect(prbToken.mathSplit(bob.address, charlie.address, amount, percentage)).to.revertedWithPanic(PANIC_CODES.ARITHMETIC_UNDER_OR_OVERFLOW);
    const bobBalance = await prbToken.balanceOf(bob.address);
    console.log("Math bob", Number(ethers.utils.formatEther(bobBalance))); // 90
  });
});