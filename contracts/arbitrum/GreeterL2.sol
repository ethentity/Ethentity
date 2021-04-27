// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.7.3;

import "./Arbsys.sol";
import "../Greeter.sol";

contract GreeterL2 is Greeter {
    ArbSys constant arbsys = ArbSys(100);
    address l1Target;

    event L2ToL1TxCreated(uint256 indexed withdrawalId);

    constructor(
        string memory _greeting,
        address _l1Target
    ) 
    public Greeter(_greeting) {
        l1Target = _l1Target;
    }

    function setGreetingInL1(string memory _greeting) public returns (uint256) {
        bytes memory data = abi.encodeWithSelector(Greeter.setGreeting.selector, _greeting);

        uint256 withdrawalId = arbsys.sendTxToL1(l1Target, data);

        emit L2ToL1TxCreated(withdrawalId);
        return withdrawalId;
    }

    /// @notice only l1Target can update greeting
    function setGreeting(string memory _greeting) public override {
        require(msg.sender == l1Target, "Greeting only updateable by L1");
        Greeter.setGreeting(_greeting);
    }
}
