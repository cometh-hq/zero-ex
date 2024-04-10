// SPDX-License-Identifier: UNLICENSED
pragma solidity <=0.8.13;
pragma experimental ABIEncoderV2;

import "forge-std/Script.sol";
import "src/migrations/InitialMigration.sol";
import "src/ZeroEx.sol";
import "src/features/OwnableFeature.sol";
import "src/features/SimpleFunctionRegistryFeature.sol";
import "src/features/ERC165Feature.sol";
import "src/features/nft_orders/ERC721OrdersFeature.sol";
import "src/IZeroEx.sol";
import "forge-std/console.sol";




contract Deployement is Script {

  address constant WETH = address(0x980B62Da83eFf3D4576C647993b0c1D7faf17c73);
  address constant DEPLOYER = address(0x6e76Fdca84343Fc83DeF060CeA85c7Ab790189d8);
  address constant ZERO_EX_OWNER = address(0xE3198781E730e0E46D6b4Be7Ce09812B29c99233);

  function run() external {
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    vm.startBroadcast(deployerPrivateKey);

    IEtherToken weth = IEtherToken(WETH);

    InitialMigration initMigration = new InitialMigration(
      DEPLOYER
    );
    ZeroEx zeroEx = new ZeroEx(address(initMigration));

    IZeroEx IZERO_EX = IZeroEx(address(zeroEx));

    ERC165Feature erc165 = new ERC165Feature();
    OwnableFeature ownable = new OwnableFeature();
    SimpleFunctionRegistryFeature simpleFunc = new SimpleFunctionRegistryFeature();
    ERC721OrdersFeature erc721Feat = new ERC721OrdersFeature(
      address(zeroEx),
      weth
    );

    initMigration.initializeZeroEx(
      payable(DEPLOYER),
      zeroEx,
      InitialMigration.BootstrapFeatures({
        registry: simpleFunc,
        ownable: ownable
      })
    );

    IZERO_EX.migrate(
      address(erc721Feat),
      abi.encodeWithSelector(0x8fd3ab80),
      DEPLOYER
    );

    IZERO_EX.extend(0x01ffc9a7, address(erc165));

    // IZERO_EX.transferOwnership(
    //   ZERO_EX_OWNER
    // );
    // console.log(IZERO_EX.owner());

    vm.stopBroadcast();
  }
}
