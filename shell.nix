let
  pkgs = import
    (builtins.fetchTarball {
      name = "nixos-unstable-2021-10-01";
      url = "https://github.com/nixos/nixpkgs/archive/d3d2c44a26b693293e8c79da0c3e3227fc212882.tar.gz";
      sha256 = "0vi4r7sxzfdaxzlhpmdkvkn3fjg533fcwsy3yrcj5fiyqip2p3kl";
    })
    { };

  command = pkgs.writeShellScriptBin "command" ''
  '';

  hardhat-node = pkgs.writeShellScriptBin "hardhat-node" ''
    npx hardhat node
  '';

  graph-node = pkgs.writeShellScriptBin "graph-node" ''
    npm run graph-node
  '';

  graph-test = pkgs.writeShellScriptBin "graph-test" ''
    npx hardhat test
  '';

  deploy-subgraph = pkgs.writeShellScriptBin "deploy-subgraph" ''
    ts-node scripts/index.ts
  '';

  init = pkgs.writeShellScriptBin "init" ''
    mkdir -p contracts && cp -r node_modules/@beehiveinnovation/vapour721a/contracts .
    npx hardhat compile
    cp -r artifacts/contracts/Vapour721A.sol/Vapour721A.json ./abis
    cp -r artifacts/contracts/Vapour721AFactory.sol/Vapour721AFactory.json ./abis
  '';
  
in
pkgs.stdenv.mkDerivation {
 name = "shell";
 buildInputs = [
  pkgs.nodejs-16_x
  pkgs.jq
  command
  hardhat-node
  graph-node
  graph-test
  deploy-subgraph
  init
 ];

 shellHook = ''
  export PATH=$( npm bin ):$PATH
  # keep it fresh
  npm install
  init
 '';
}