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
  function run() external {
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    vm.startBroadcast(deployerPrivateKey);

    IEtherToken weth = IEtherToken(
      address(0x869Bf8814d77106323745758135b999D34C79a87)
    );

    InitialMigration initMigration = new InitialMigration(
      address(0xF851b22255d30FA024433AAd8c9c0d32De413159)
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
      payable(address(0xF851b22255d30FA024433AAd8c9c0d32De413159)),
      zeroEx,
      InitialMigration.BootstrapFeatures({
        registry: simpleFunc,
        ownable: ownable
      })
    );

    IZERO_EX.migrate(
      address(erc721Feat),
      abi.encodeWithSelector(0x8fd3ab80),
      address(0xF851b22255d30FA024433AAd8c9c0d32De413159)
    );

    IZERO_EX.extend(0x01ffc9a7, address(erc165));

    IZERO_EX.transferOwnership(
      address(0xE3198781E730e0E46D6b4Be7Ce09812B29c99233)
    );
    console.log(IZERO_EX.owner());

    vm.stopBroadcast();
  }
}
