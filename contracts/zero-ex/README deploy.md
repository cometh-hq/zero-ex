

# Setup


1. At the root of the project:
```
yarn
```

2. Install foundry: https://book.getfoundry.sh/getting-started/installation

In the zero ex folder
```
git submodule update --init --recursive
foundryup
```

If you have issues with VS code and the deploy script, try opening only this zero-ex folder.

3. Config

- Add your private key in a new .env file (PRIVATE_KEY)
- Update constants in the deployment script
- Comment the transfer ownership if you are in a test network

4. Running the script

```
forge script scripts/deployment.s.sol --rpc-url https://muster-anytrust.alt.technology --broadcast -vvvv  --slow
forge script scripts/deployment.s.sol --rpc-url https://rpc-amoy.polygon.technology --broadcast -vvvv  --slow -g 200 
```


# Networks configs

## Amoy

WETH: 0x18292606c7e2eEB8A9459DB1A44157679E7338b6
Deployer: 0x6e76Fdca84343Fc83DeF060CeA85c7Ab790189d8
RPC: https://rpc-amoy.polygon.technology

Command: 
```
forge script scripts/deployment.s.sol --rpc-url https://rpc-amoy.polygon.technology --broadcast -vvvv  --slow --legacy --with-gas-price 40000000000
```

Result: 0xcc72984b2ab10a2311dd82986a57823da6c59662

## Artbitrum Sepolia

WETH: 0x980B62Da83eFf3D4576C647993b0c1D7faf17c73
Deployer: 0x6e76Fdca84343Fc83DeF060CeA85c7Ab790189d8
RPC: https://public.stackup.sh/api/v1/node/arbitrum-sepolia

Command: 
```
forge script scripts/deployment.s.sol --rpc-url https://public.stackup.sh/api/v1/node/arbitrum-sepolia --broadcast -vvvv  --slow 
```

Result: 0xdd1de4ff6f558f21ac1a892923999fed87423560