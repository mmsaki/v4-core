// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Hooks} from "../libraries/Hooks.sol";
import {IHooks} from "../interfaces/IHooks.sol";
import {ModifyLiquidityParams, SwapParams} from "../types/PoolOperation.sol";
import {PoolKey} from "../types/PoolKey.sol";
import {BalanceDelta, BalanceDeltaLibrary} from "../types/BalanceDelta.sol";
import {PoolId} from "../types/PoolId.sol";
import {BeforeSwapDelta, BeforeSwapDeltaLibrary} from "../types/BeforeSwapDelta.sol";

contract MockHooks is IHooks {
    using Hooks for IHooks;

    bytes public beforeInitializeData;
    bytes public afterInitializeData;
    bytes public beforeAddLiquidityData;
    bytes public afterAddLiquidityData;
    bytes public beforeRemoveLiquidityData;
    bytes public afterRemoveLiquidityData;
    bytes public beforeSwapData;
    bytes public afterSwapData;
    bytes public beforeDonateData;
    bytes public afterDonateData;

    mapping(bytes4 => bytes4) public returnValues;

    mapping(PoolId => uint16) public lpFees;

    function beforeInitialize(address, PoolKey calldata, uint160) external override returns (bytes4) {
        beforeInitializeData = new bytes(123);
        bytes4 selector = MockHooks.beforeInitialize.selector;
        return returnValues[selector] == bytes4(0) ? selector : returnValues[selector];
    }

    function afterInitialize(address, PoolKey calldata, uint160, int24) external override returns (bytes4) {
        afterInitializeData = new bytes(123);
        bytes4 selector = MockHooks.afterInitialize.selector;
        return returnValues[selector] == bytes4(0) ? selector : returnValues[selector];
    }

    function beforeAddLiquidity(address, PoolKey calldata, ModifyLiquidityParams calldata, bytes calldata hookData)
        external
        override
        returns (bytes4)
    {
        beforeAddLiquidityData = hookData;
        bytes4 selector = MockHooks.beforeAddLiquidity.selector;
        return returnValues[selector] == bytes4(0) ? selector : returnValues[selector];
    }

    function afterAddLiquidity(
        address,
        PoolKey calldata,
        ModifyLiquidityParams calldata,
        BalanceDelta,
        BalanceDelta,
        bytes calldata hookData
    ) external override returns (bytes4, BalanceDelta) {
        afterAddLiquidityData = hookData;
        bytes4 selector = MockHooks.afterAddLiquidity.selector;
        return (returnValues[selector] == bytes4(0) ? selector : returnValues[selector], BalanceDeltaLibrary.ZERO_DELTA);
    }

    function beforeRemoveLiquidity(address, PoolKey calldata, ModifyLiquidityParams calldata, bytes calldata hookData)
        external
        override
        returns (bytes4)
    {
        beforeRemoveLiquidityData = hookData;
        bytes4 selector = MockHooks.beforeRemoveLiquidity.selector;
        return returnValues[selector] == bytes4(0) ? selector : returnValues[selector];
    }

    function afterRemoveLiquidity(
        address,
        PoolKey calldata,
        ModifyLiquidityParams calldata,
        BalanceDelta,
        BalanceDelta,
        bytes calldata hookData
    ) external override returns (bytes4, BalanceDelta) {
        afterRemoveLiquidityData = hookData;
        bytes4 selector = MockHooks.afterRemoveLiquidity.selector;
        return (returnValues[selector] == bytes4(0) ? selector : returnValues[selector], BalanceDeltaLibrary.ZERO_DELTA);
    }

    function beforeSwap(address, PoolKey calldata, SwapParams calldata, bytes calldata hookData)
        external
        override
        returns (bytes4, BeforeSwapDelta, uint24)
    {
        beforeSwapData = hookData;
        bytes4 selector = MockHooks.beforeSwap.selector;
        return (
            returnValues[selector] == bytes4(0) ? selector : returnValues[selector],
            BeforeSwapDeltaLibrary.ZERO_DELTA,
            0
        );
    }

    function afterSwap(address, PoolKey calldata, SwapParams calldata, BalanceDelta, bytes calldata hookData)
        external
        override
        returns (bytes4, int128)
    {
        afterSwapData = hookData;
        bytes4 selector = MockHooks.afterSwap.selector;
        return (returnValues[selector] == bytes4(0) ? selector : returnValues[selector], 0);
    }

    function beforeDonate(address, PoolKey calldata, uint256, uint256, bytes calldata hookData)
        external
        override
        returns (bytes4)
    {
        beforeDonateData = hookData;
        bytes4 selector = MockHooks.beforeDonate.selector;
        return returnValues[selector] == bytes4(0) ? selector : returnValues[selector];
    }

    function afterDonate(address, PoolKey calldata, uint256, uint256, bytes calldata hookData)
        external
        override
        returns (bytes4)
    {
        afterDonateData = hookData;
        bytes4 selector = MockHooks.afterDonate.selector;
        return returnValues[selector] == bytes4(0) ? selector : returnValues[selector];
    }

    function setReturnValue(bytes4 key, bytes4 value) external {
        returnValues[key] = value;
    }

    function setlpFee(PoolKey calldata key, uint16 value) external {
        lpFees[key.toId()] = value;
    }
}
