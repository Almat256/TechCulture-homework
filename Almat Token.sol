// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Almat {
    string public name = "Almat token";
    string public symbol = "ATK";
    uint8 public decimals = 18;
    uint256 public totalSupply = 1000000 * (10 ** uint256(decimals));
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor() {
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(_to != address(0), "Invalid address");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        uint256 fee = (_value * 5) / 100;
        uint256 amount = _value - fee;

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += amount;
        balanceOf[owner] += fee;

        emit Transfer(msg.sender, _to, amount);
        emit Transfer(msg.sender, owner, fee);

        return true;
    }

    function approve(
        address _spender,
        uint256 _value
    ) public returns (bool success) {
        require(_spender != address(0), "Invalid address");

        allowance[msg.sender][_spender] = _value;

        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(_from != address(0), "Invalid address");
        require(_to != address(0), "Invalid address");
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(
            allowance[_from][msg.sender] >= _value,
            "Insufficient allowance"
        );

        uint256 fee = (_value * 5) / 100;
        uint256 amount = _value - fee;

        balanceOf[_from] -= _value;
        balanceOf[_to] += amount;
        balanceOf[owner] += fee;

        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, amount);
        emit Transfer(_from, owner, fee);

        return true;
    }
}
