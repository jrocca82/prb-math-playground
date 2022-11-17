import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  
  const contract = await deploy("PRBMathTest", {
    from: deployer,
    log: true
  });
  console.log(`Contract deployed to ${contract.address}`)
};

export default func;
func.tags = ["testbed", "_prbMathTest"];