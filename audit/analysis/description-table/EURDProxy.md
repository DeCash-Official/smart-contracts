## Sūrya's Description Report

### Files Description Table


|  File Name  |  SHA-1 Hash  |
|-------------|--------------|
| dist/EURDProxy.dist.sol | 62d89956c52674c7242851bcf39916e3d63b504f |


### Contracts Description Table


|  Contract  |         Type        |       Bases      |                  |                 |
|:----------:|:-------------------:|:----------------:|:----------------:|:---------------:|
|     └      |  **Function Name**  |  **Visibility**  |  **Mutability**  |  **Modifiers**  |
||||||
| **DeCashProxyInterface** | Interface |  |||
| └ | initialize | External ❗️ | 🛑  |NO❗️ |
| └ | upgrade | External ❗️ | 🛑  |NO❗️ |
||||||
| **Address** | Library |  |||
| └ | isContract | Internal 🔒 |   | |
| └ | sendValue | Internal 🔒 | 🛑  | |
| └ | functionCall | Internal 🔒 | 🛑  | |
| └ | functionCall | Internal 🔒 | 🛑  | |
| └ | functionCallWithValue | Internal 🔒 | 🛑  | |
| └ | functionCallWithValue | Internal 🔒 | 🛑  | |
| └ | functionStaticCall | Internal 🔒 |   | |
| └ | functionStaticCall | Internal 🔒 |   | |
| └ | functionDelegateCall | Internal 🔒 | 🛑  | |
| └ | functionDelegateCall | Internal 🔒 | 🛑  | |
| └ | _verifyCallResult | Private 🔐 |   | |
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
| **Proxy** | Implementation |  |||
| └ | <Receive Ether> | External ❗️ |  💵 |NO❗️ |
| └ | <Fallback> | External ❗️ |  💵 |NO❗️ |
| └ | _delegate | Internal 🔒 | 🛑  | |
| └ | _implementation | Internal 🔒 |   | |
| └ | _fallback | Internal 🔒 | 🛑  | |
| └ | _beforeFallback | Internal 🔒 | 🛑  | |
||||||
| **DeCashProxy** | Implementation | DeCashBase, Proxy |||
| └ | <Constructor> | Public ❗️ | 🛑  | DeCashBase |
| └ | upgrade | Public ❗️ | 🛑  | onlyLatestContract |
| └ | initialize | External ❗️ | 🛑  | onlyOwner |
| └ | _setImplementation | Private 🔐 | 🛑  | |
| └ | _implementation | Internal 🔒 |   | |
||||||
| **EURDProxy** | Implementation | DeCashProxy |||
| └ | <Constructor> | Public ❗️ | 🛑  | DeCashProxy |


### Legend

|  Symbol  |  Meaning  |
|:--------:|-----------|
|    🛑    | Function can modify state |
|    💵    | Function is payable |
