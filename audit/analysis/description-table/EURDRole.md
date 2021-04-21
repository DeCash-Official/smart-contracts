## Sūrya's Description Report

### Files Description Table


|  File Name  |  SHA-1 Hash  |
|-------------|--------------|
| dist/EURDRole.dist.sol | 958ba852cde0723a508b8eb2bf6fb966f2d24e2b |


### Contracts Description Table


|  Contract  |         Type        |       Bases      |                  |                 |
|:----------:|:-------------------:|:----------------:|:----------------:|:---------------:|
|     └      |  **Function Name**  |  **Visibility**  |  **Mutability**  |  **Modifiers**  |
||||||
| **DeCashRoleInterface** | Interface |  |||
| └ | transferOwnership | External ❗️ | 🛑  |NO❗️ |
| └ | addRole | External ❗️ | 🛑  |NO❗️ |
| └ | removeRole | External ❗️ | 🛑  |NO❗️ |
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
| **DeCashBase** | Implementation |  |||
| └ | <Constructor> | Public ❗️ | 🛑  |NO❗️ |
| └ | isOwner | External ❗️ |   |NO❗️ |
| └ | isAdmin | External ❗️ |   |NO❗️ |
| └ | isSuperUser | External ❗️ |   |NO❗️ |
| └ | isDelegator | External ❗️ |   |NO❗️ |
| └ | isFeeRecipient | External ❗️ |   |NO❗️ |
| └ | isBlacklisted | External ❗️ |   |NO❗️ |
| └ | _getContractAddress | Internal 🔒 |   | |
| └ | _getContractName | Internal 🔒 |   | |
| └ | _roleHas | Internal 🔒 |   | |
| └ | _isOwner | Internal 🔒 |   | |
| └ | _isAdmin | Internal 🔒 |   | |
| └ | _isSuperUser | Internal 🔒 |   | |
| └ | _isDelegator | Internal 🔒 |   | |
| └ | _isFeeRecipient | Internal 🔒 |   | |
| └ | _isBlacklisted | Internal 🔒 |   | |
| └ | _getAddress | Internal 🔒 |   | |
| └ | _getUint | Internal 🔒 |   | |
| └ | _getString | Internal 🔒 |   | |
| └ | _getBytes | Internal 🔒 |   | |
| └ | _getBool | Internal 🔒 |   | |
| └ | _getInt | Internal 🔒 |   | |
| └ | _getBytes32 | Internal 🔒 |   | |
| └ | _getAddressS | Internal 🔒 |   | |
| └ | _getUintS | Internal 🔒 |   | |
| └ | _getStringS | Internal 🔒 |   | |
| └ | _getBytesS | Internal 🔒 |   | |
| └ | _getBoolS | Internal 🔒 |   | |
| └ | _getIntS | Internal 🔒 |   | |
| └ | _getBytes32S | Internal 🔒 |   | |
| └ | _setAddress | Internal 🔒 | 🛑  | |
| └ | _setUint | Internal 🔒 | 🛑  | |
| └ | _setString | Internal 🔒 | 🛑  | |
| └ | _setBytes | Internal 🔒 | 🛑  | |
| └ | _setBool | Internal 🔒 | 🛑  | |
| └ | _setInt | Internal 🔒 | 🛑  | |
| └ | _setBytes32 | Internal 🔒 | 🛑  | |
| └ | _setAddressS | Internal 🔒 | 🛑  | |
| └ | _setUintS | Internal 🔒 | 🛑  | |
| └ | _setStringS | Internal 🔒 | 🛑  | |
| └ | _setBytesS | Internal 🔒 | 🛑  | |
| └ | _setBoolS | Internal 🔒 | 🛑  | |
| └ | _setIntS | Internal 🔒 | 🛑  | |
| └ | _setBytes32S | Internal 🔒 | 🛑  | |
| └ | _deleteAddress | Internal 🔒 | 🛑  | |
| └ | _deleteUint | Internal 🔒 | 🛑  | |
| └ | _deleteString | Internal 🔒 | 🛑  | |
| └ | _deleteBytes | Internal 🔒 | 🛑  | |
| └ | _deleteBool | Internal 🔒 | 🛑  | |
| └ | _deleteInt | Internal 🔒 | 🛑  | |
| └ | _deleteBytes32 | Internal 🔒 | 🛑  | |
| └ | _deleteAddressS | Internal 🔒 | 🛑  | |
| └ | _deleteUintS | Internal 🔒 | 🛑  | |
| └ | _deleteStringS | Internal 🔒 | 🛑  | |
| └ | _deleteBytesS | Internal 🔒 | 🛑  | |
| └ | _deleteBoolS | Internal 🔒 | 🛑  | |
| └ | _deleteIntS | Internal 🔒 | 🛑  | |
| └ | _deleteBytes32S | Internal 🔒 | 🛑  | |
||||||
| **DeCashRole** | Implementation | DeCashBase, DeCashRoleInterface |||
| └ | <Constructor> | Public ❗️ | 🛑  | DeCashBase |
| └ | transferOwnership | External ❗️ | 🛑  | onlyLatestContract onlyOwner |
| └ | addRole | External ❗️ | 🛑  | onlyLatestContract onlySuperUser |
| └ | removeRole | External ❗️ | 🛑  | onlyLatestContract onlySuperUser |
||||||
| **EURDRole** | Implementation | DeCashRole |||
| └ | <Constructor> | Public ❗️ | 🛑  | DeCashRole |


### Legend

|  Symbol  |  Meaning  |
|:--------:|-----------|
|    🛑    | Function can modify state |
|    💵    | Function is payable |
