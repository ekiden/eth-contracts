pragma solidity ^0.4.19;

contract StateContract {

  struct Contract {
    string contract;
    string publicKey;
    string initialState;
    string attestation;
    string proofAtt;
    Contract next;
  }

  function StateContract() {
    // empty for now, potential for creating a genesis block?
  }

  /* essentially acts as a consensus node
  *
  */
  function uploadContract(
    string contract,
    string publicKey,
    string initialState,
    string attestation,
    string proofAtt) {
      // TODO: evaluate if it's possible to verify on chain
      // alternatively, give power to verify / upload only to consensus nodes
    }
}
