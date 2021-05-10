#!/usr/bin/env bash

for contract in "EURDStorage" "EURDUpgrade" "EURDRole" "EURDToken" "EURDProxy"
do
  npx surya inheritance dist/$contract.dist.sol | dot -Tpng > audit/analysis/inheritance-tree/$contract.png

  npx surya graph dist/$contract.dist.sol | dot -Tpng > audit/analysis/control-flow/$contract.png

  npx surya mdreport audit/analysis/description-table/$contract.md dist/$contract.dist.sol

  npx sol2uml dist/$contract.dist.sol -o audit/analysis/uml/$contract.svg
done
