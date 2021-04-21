## Sūrya's Description Report

### Files Description Table


|  File Name  |  SHA-1 Hash  |
|-------------|--------------|
| dist/EURDStorage.dist.sol | d87e3d0bbd8d9c88d206258ef994b99365aa7f39 |


### Contracts Description Table


|  Contract  |         Type        |       Bases      |                  |                 |
|:----------:|:-------------------:|:----------------:|:----------------:|:---------------:|
|     └      |  **Function Name**  |  **Visibility**  |  **Mutability**  |  **Modifiers**  |
||||||
| **DeCashStorageInterface** | Interface |  |||
| └ | getAddress | External ❗️ |   |NO❗️ |
| └ | getUint | External ❗️ |   |NO❗️ |
| └ | getString | External ❗️ |   |NO❗️ |
| └ | getBytes | External ❗️ |   |NO❗️ |
| └ | getBool | External ❗️ |   |NO❗️ |
| └ | getInt | External ❗️ |   |NO❗️ |
| └ | getBytes32 | External ❗️ |   |NO❗️ |
| └ | setAddress | External ❗️ | 🛑  |NO❗️ |
| └ | setUint | External ❗️ | 🛑  |NO❗️ |
| └ | setString | External ❗️ | 🛑  |NO❗️ |
| └ | setBytes | External ❗️ | 🛑  |NO❗️ |
| └ | setBool | External ❗️ | 🛑  |NO❗️ |
| └ | setInt | External ❗️ | 🛑  |NO❗️ |
| └ | setBytes32 | External ❗️ | 🛑  |NO❗️ |
| └ | deleteAddress | External ❗️ | 🛑  |NO❗️ |
| └ | deleteUint | External ❗️ | 🛑  |NO❗️ |
| └ | deleteString | External ❗️ | 🛑  |NO❗️ |
| └ | deleteBytes | External ❗️ | 🛑  |NO❗️ |
| └ | deleteBool | External ❗️ | 🛑  |NO❗️ |
| └ | deleteInt | External ❗️ | 🛑  |NO❗️ |
| └ | deleteBytes32 | External ❗️ | 🛑  |NO❗️ |
||||||
| **DeCashStorage** | Implementation | DeCashStorageInterface |||
| └ | <Constructor> | Public ❗️ | 🛑  |NO❗️ |
| └ | getAddress | External ❗️ |   |NO❗️ |
| └ | getUint | External ❗️ |   |NO❗️ |
| └ | getString | External ❗️ |   |NO❗️ |
| └ | getBytes | External ❗️ |   |NO❗️ |
| └ | getBool | External ❗️ |   |NO❗️ |
| └ | getInt | External ❗️ |   |NO❗️ |
| └ | getBytes32 | External ❗️ |   |NO❗️ |
| └ | setAddress | External ❗️ | 🛑  | onlyLatestDeCashNetworkContract |
| └ | setUint | External ❗️ | 🛑  | onlyLatestDeCashNetworkContract |
| └ | setString | External ❗️ | 🛑  | onlyLatestDeCashNetworkContract |
| └ | setBytes | External ❗️ | 🛑  | onlyLatestDeCashNetworkContract |
| └ | setBool | External ❗️ | 🛑  | onlyLatestDeCashNetworkContract |
| └ | setInt | External ❗️ | 🛑  | onlyLatestDeCashNetworkContract |
| └ | setBytes32 | External ❗️ | 🛑  | onlyLatestDeCashNetworkContract |
| └ | deleteAddress | External ❗️ | 🛑  | onlyLatestDeCashNetworkContract |
| └ | deleteUint | External ❗️ | 🛑  | onlyLatestDeCashNetworkContract |
| └ | deleteString | External ❗️ | 🛑  | onlyLatestDeCashNetworkContract |
| └ | deleteBytes | External ❗️ | 🛑  | onlyLatestDeCashNetworkContract |
| └ | deleteBool | External ❗️ | 🛑  | onlyLatestDeCashNetworkContract |
| └ | deleteInt | External ❗️ | 🛑  | onlyLatestDeCashNetworkContract |
| └ | deleteBytes32 | External ❗️ | 🛑  | onlyLatestDeCashNetworkContract |
||||||
| **EURDStorage** | Implementation | DeCashStorage |||


### Legend

|  Symbol  |  Meaning  |
|:--------:|-----------|
|    🛑    | Function can modify state |
|    💵    | Function is payable |
