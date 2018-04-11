# Referenced from https://medium.com/@WWWillems/how-to-set-up-a-private-ethereum-testnet-blockchain-using-geth-and-homebrew-1106a27e8e1e


geth --identity "TestNet" --nodiscover 1999 --datadir . init CustomGenesis.json

# Persistent storage for the testnet
geth account new --datadir test-net-store

# Start the geth console
geth --identity "TestNet" --datadir test-net-store --nodiscover --networkid 1999 console


