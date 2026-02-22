// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test } from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {ERC20Mock} from "../mocks/ERC20Mock.sol";
import {PoolFactory} from "../../src/PoolFactory.sol";
import {TSwapPool} from "../../src/TSwapPool.sol";

contract InvariantTest is StdInvariant, Test {
    // These pools have 2 tokens
    ERC20Mock poolToken;
    ERC20Mock weth;

    int256 constant STARTING_X = 100e18; // Starting ERC20 / poolToken
    int256 constant STARTING_Y = 50e18; // Starting WETH

    // We are gonna need contracts
    PoolFactory factory;
    TSwapPool pool; // poolToken / WETH

    function setUp() public {
       weth = new ERC20Mock();
       poolToken = new ERC20Mock();
       factory = new PoolFactory(address(weth));
       pool = TSwapPool(factory.createPool(address(poolToken)));

       // Create those initil x & y balances
       poolToken.mint(address(this), uint256(STARTING_X));
       weth.mint(address(this), uint256(STARTING_Y));

       poolToken.approve(address(pool), type(uint256).max);
       weth.approve(address(pool), type(uint256).max); 

       // Deposit into the pool, give the startign x & y balances
       pool.deposit(uint256(STARTING_Y), uint256(STARTING_Y), uint256(STARTING_X), uint64(block.timestamp));
    }

    function statefulFuzz_constantProductFormulaStaysTheSame() public {
        // The Change in the pool size in weth should follow this function:
        // ∆x = (β/(1-β)) * x
    }
}