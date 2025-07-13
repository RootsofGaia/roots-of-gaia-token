// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

interface ERC20Interface {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint balance);
    function allowance(address owner, address spender) external view returns (uint remaining);
    function transfer(address recipient, uint amount) external returns (bool success);
    function approve(address spender, uint amount) external returns (bool success);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool success);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract RootsOfGaiaToken is ERC20Interface {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint private _totalSupply;

    mapping(address => uint) private balances;
    mapping(address => mapping(address => uint)) private allowances;

    constructor() {
        name = "Roots Of Gaia";
        symbol = "ROG";
        decimals = 18;
        _totalSupply = 1_000_000_001 * 10 ** uint(decimals); // 1,000,000,001 tokens
        address deployer = 0x2D145b61935cDdEc18EDc8B238B875EAfB4a997c;
        balances[deployer] = _totalSupply;
        emit Transfer(address(0), deployer, _totalSupply);
    }

    function totalSupply() external view override returns (uint) {
        return _totalSupply - balances[address(0)];
    }

    function balanceOf(address account) external view override returns (uint balance) {
        return balances[account];
    }

    function allowance(address owner, address spender) external view override returns (uint remaining) {
        return allowances[owner][spender];
    }

    function transfer(address recipient, uint amount) external override returns (bool success) {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint amount) external override returns (bool success) {
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint amount) external override returns (bool success) {
        require(balances[sender] >= amount, "Insufficient balance");
        require(allowances[sender][msg.sender] >= amount, "Allowance exceeded");
        balances[sender] -= amount;
        allowances[sender][msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }
}