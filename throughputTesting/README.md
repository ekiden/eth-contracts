# Dex

# TestEnvironment

This process will setup a docker environement with multiple geth nodes connected to a local ethereum network, create a contract on the local network, and have nodes interact with the contract. This will be monitored using a netstats console to see statistics of the contract and network.

## Setup

To setup the docker environment, use the included submodule from Capgemini docker-ethereum


Then start up an environment with a couple nodes using:

```
cd ethereum-docker
docker-compose up -d
```

Then you can scale up the number of nodes using:

```
docker-compose scale eth=10
```

To connect to a node with a JS console, we can use geth (note address may be different for you):

```
geth attach http://localhost:8545
```

Now we can open a miner on another node using:

```
docker exec -it ethereumdocker_eth_1 geth attach ipc://root/.ethereum/devchain/geth.ipc
```

We start the miner by running:

```
miner.start(1)
```

We can monitor when the miner has started actually mining blocks by checking when 

```
eth.blockNumber
```

is > 0.

Finally, we can open up a netstats monitoring console on http://localhost:3000. This will show you things like the current block number, hashrate of the miner, and other stats that you'd need.

## Creating and running a contract

In the JS console connected to the non-mining node, we can create a contract on the test chain. The contract I'll use is a simple bank contract with deposit, withdraw, balance, etc. The bytecode and the abi are just detailing the contract, you can get these by writing a Solidity contract and putting it into https://ethereum.github.io/browser-solidity/ for compilation.

```
var bytecode = '0x6060604052341561000f57600080fd5b33600160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555061043e8061005f6000396000f300606060405260043610610062576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff1680632e1a7d4d146100725780638da5cb5b146100a9578063b69ef8a8146100fe578063d0e30db014610127575b341561006d57600080fd5b600080fd5b341561007d57600080fd5b6100936004808035906020019091905050610145565b6040518082815260200191505060405180910390f35b34156100b457600080fd5b6100bc6102a9565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b341561010957600080fd5b6101116102cf565b6040518082815260200191505060405180910390f35b61012f610315565b6040518082815260200191505060405180910390f35b6000816000803373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205410151561026357816000803373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600082825403925050819055503373ffffffffffffffffffffffffffffffffffffffff166108fc839081150290604051600060405180830381858888f19350505050151561026257816000803373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600082825401925050819055505b5b6000803373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020549050919050565b600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b60008060003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002054905090565b6000346000803373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600082825401925050819055507fa8126f7572bb1fdeae5b5aa9ec126438b91f658a07873f009d041ae690f3a1933334604051808373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020018281526020019250505060405180910390a16000803373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020549050905600a165627a7a72305820288012312000c95b5b4b1cbc0b0b91747cae0b23b48da40caae1eaa155c02ec80029';

var abi = [{"constant":false,"inputs":[{"name":"withdrawAmount","type":"uint256"}],"name":"withdraw","outputs":[{"name":"remainingBal","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"balance","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"deposit","outputs":[{"name":"","type":"uint256"}],"payable":true,"stateMutability":"payable","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"payable":false,"stateMutability":"nonpayable","type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"accountAddress","type":"address"},{"indexed":false,"name":"amount","type":"uint256"}],"name":"LogDepositMade","type":"event"}];

var contract = eth.contract(abi);

var txDeploy = {from:eth.coinbase, data:bytecode, gas:10000000};

var contractInstance = contract.new(txDeploy);
```

We now have an instance of our contract. Since we have a miner running on another node, this contract should be on-chain when the next block is mined. To make sure it's on-chain, we can check its address to see if it has a valid address.

```
contractInstance.address
```

If it has a valid address, we can now use the contract by interacting with contractInstance!

## Testing the network

Now, we can use this contract and the nodes to test the network and the contract. We can continuously submit deposit transactions using the non-mining node and then using the netstats monitoring page, we can see the stats of the network, such as average propagation time, transactions per block, etc.

To continuously submit deposits, we run a simple javascript command (we increment the amount depositied, as if we use the same amount the transaction will yield the same hash due to implementation details of the network):
```
var i = 0;
while (true) {
    i += 1;
    contractInstance.deposit({from:eth.accounts[0],value:i});
}
```

Now we can just monitor the netstat console to get the stats that we need.

## Cleanup

When you're done, you can stop the network by just closing all the terminals and running 

```
docker-compose stop
docker-compose down 
```

