// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.24;

import "./Actors.sol";

contract BankActor {
  using Actors for Actors.Actor;

  event BankAdded(address indexed account);
  event BankRemoved(address indexed account);

  Actors.Actor private Banks;

  constructor() {_addBank(msg.sender);}

  modifier onlyBank() 
	{
	require(isBank(msg.sender));
	_;
	}

  function isBank(address account) public view returns (bool) {return Banks.has(account);}

  function addBank(address account) public onlyBank {_addBank(account);}

  function removeBank() public {_removeBank(msg.sender);}

  function _addBank(address account) internal 
	{
	Banks.add(account);
	emit BankAdded(account);
	}

  function _removeBank(address account) internal 
	{
	Banks.remove(account);
	emit BankRemoved(account);
	}
}