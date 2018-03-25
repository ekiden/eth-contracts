var stateContract = artifacts.require("Lottery.sol");

module.exports = function(deployer) {
    deployer.deploy(stateContract);
}
