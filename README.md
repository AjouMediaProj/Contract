# Contract

Klaytn Contract Deployer

## Includes

- Truffle
- node.js
- caver-js

## Installation

Truffle v5.0.26 recommended

```
npm install -g truffle@v5.0.26
```

Nodejs v12 recommended

```
nvm use 12
```

Yarn package manager recommended

```
npm install -g yarn
```

Install project dependencies

```
yarn install
```

## Config

Klaytn Account With 1 Klay Required

## Usage

Baobab TestNet

```
truffle deploy --reset --network testnet
```

Cypress MainNet

```
truffle deploy --reset --network mainnet
```

## VS Code Prettier Setting

- Search 'Prettier - Code formatter' in VS Code Extension
- Go to VS Code Setting(ctrl + ,)
- Set Default Formatter to 'prettier-vscode'
- Check 'Format On Save'
- Edit .prettierrc file for detail setting
