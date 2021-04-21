## Sūrya's Description Report

### Files Description Table


|  File Name  |  SHA-1 Hash  |
|-------------|--------------|
| dist/EURDToken.dist.sol | a640610cac4212a93dc9baf2522a4473c9e8da25 |


### Contracts Description Table


|  Contract  |         Type        |       Bases      |                  |                 |
|:----------:|:-------------------:|:----------------:|:----------------:|:---------------:|
|     └      |  **Function Name**  |  **Visibility**  |  **Mutability**  |  **Modifiers**  |
||||||
| **ERC20** | Interface |  |||
| └ | balanceOf | External ❗️ |   |NO❗️ |
| └ | allowance | External ❗️ |   |NO❗️ |
| └ | transfer | External ❗️ | 🛑  |NO❗️ |
| └ | transferFrom | External ❗️ | 🛑  |NO❗️ |
| └ | transferMany | External ❗️ | 🛑  |NO❗️ |
| └ | approve | External ❗️ | 🛑  |NO❗️ |
| └ | mint | External ❗️ | 🛑  |NO❗️ |
| └ | burn | External ❗️ | 🛑  |NO❗️ |
| └ | burnFrom | External ❗️ | 🛑  |NO❗️ |
||||||
| **SafeMath** | Library |  |||
| └ | add | Internal 🔒 |   | |
| └ | sub | Internal 🔒 |   | |
| └ | sub | Internal 🔒 |   | |
| └ | mul | Internal 🔒 |   | |
| └ | div | Internal 🔒 |   | |
| └ | div | Internal 🔒 |   | |
| └ | mod | Internal 🔒 |   | |
| └ | mod | Internal 🔒 |   | |
||||||
| **Signature** | Library |  |||
| └ | hexToString | Internal 🔒 |   | |
| └ | requireSignature | Internal 🔒 | 🛑  | |
| └ | calculateManySig | Internal 🔒 |   | |
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
| **DeCashMultisignature** | Implementation |  |||
| └ | cancelOperation | External ❗️ | 🛑  |NO❗️ |
| └ | _checkMultiSignature | Internal 🔒 | 🛑  | |
| └ | _deleteOperation | Internal 🔒 | 🛑  | |
||||||
| **DeCashToken** | Implementation | DeCashBase, DeCashMultisignature, ERC20 |||
| └ | <Constructor> | Public ❗️ | 🛑  | DeCashBase |
| └ | initialize | Public ❗️ | 🛑  | onlyOwner |
| └ | isPaused | Public ❗️ |   |NO❗️ |
| └ | changeRequiredSigners | External ❗️ | 🛑  | onlySuperUser onlyLastest |
| └ | name | External ❗️ |   |NO❗️ |
| └ | symbol | External ❗️ |   |NO❗️ |
| └ | decimals | External ❗️ |   |NO❗️ |
| └ | totalSupply | External ❗️ |   |NO❗️ |
| └ | pause | External ❗️ | 🛑  | onlySuperUser onlyLastest whenNotPaused |
| └ | unpause | External ❗️ | 🛑  | onlySuperUser onlyLastest whenPaused |
| └ | balanceOf | External ❗️ |   |NO❗️ |
| └ | allowance | External ❗️ |   |NO❗️ |
| └ | transfer | External ❗️ | 🛑  | onlyLastest whenNotPaused |
| └ | transferMany | External ❗️ | 🛑  | onlyLastest whenNotPaused |
| └ | transferFrom | External ❗️ | 🛑  | onlyLastest whenNotPaused |
| └ | approve | External ❗️ | 🛑  | onlyLastest whenNotPaused |
| └ | burn | External ❗️ | 🛑  | onlyLastest whenNotPaused |
| └ | burnFrom | External ❗️ | 🛑  | onlyLastest whenNotPaused |
| └ | mint | External ❗️ | 🛑  | onlySuperUser onlyLastest whenNotPaused onlyMultiSignature |
| └ | transferViaSignature | External ❗️ | 🛑  | onlyLastest |
| └ | transferManyViaSignature | External ❗️ | 🛑  | onlyLastest |
| └ | approveViaSignature | External ❗️ | 🛑  | onlyLastest |
| └ | transferFromViaSignature | External ❗️ | 🛑  | onlyLastest |
| └ | _getTotalSupply | Internal 🔒 |   | |
| └ | _setTotalSupply | Internal 🔒 | 🛑  | |
| └ | _addTotalSupply | Internal 🔒 | 🛑  | |
| └ | _subTotalSupply | Internal 🔒 | 🛑  | |
| └ | _getAllowed | Internal 🔒 |   | |
| └ | _setAllowed | Internal 🔒 | 🛑  | |
| └ | _addAllowed | Internal 🔒 | 🛑  | |
| └ | _subAllowed | Internal 🔒 | 🛑  | |
| └ | _getBalance | Internal 🔒 |   | |
| └ | _setBalance | Internal 🔒 | 🛑  | |
| └ | _addBalance | Internal 🔒 | 🛑  | |
| └ | _subBalance | Internal 🔒 | 🛑  | |
| └ | _getReqSign | Internal 🔒 |   | |
| └ | _getSignGeneration | Internal 🔒 |   | |
| └ | _getUsedSigIds | Internal 🔒 |   | |
| └ | _setReqSign | Internal 🔒 | 🛑  | |
| └ | _setSignGeneration | Internal 🔒 | 🛑  | |
| └ | _setUsedSigIds | Internal 🔒 | 🛑  | |
| └ | _burn | Internal 🔒 | 🛑  | |
| └ | _transfer | Internal 🔒 | 🛑  | |
| └ | _transferMany | Internal 🔒 | 🛑  | |
| └ | _transferFrom | Internal 🔒 | 🛑  | |
| └ | _approve | Internal 🔒 | 🛑  | |
| └ | _calculateTotal | Internal 🔒 |   | |
| └ | _validateViaSignatureParams | Internal 🔒 |   | |
| └ | _burnSigId | Internal 🔒 | 🛑  | |
||||||
| **EURDToken** | Implementation | DeCashToken |||
| └ | <Constructor> | Public ❗️ | 🛑  | DeCashToken |


### Legend

|  Symbol  |  Meaning  |
|:--------:|-----------|
|    🛑    | Function can modify state |
|    💵    | Function is payable |
