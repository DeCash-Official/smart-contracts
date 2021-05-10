#!/usr/bin/env bash

for contract in "EURDStorage" "EURDUpgrade" "EURDRole" "EURDToken" "EURDProxy"
do
  npx truffle-flattener contracts/currencies/EURD/$contract.sol > dist/$contract.dist.sol
done
