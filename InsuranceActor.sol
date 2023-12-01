// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.24;

import "./Actors.sol";

contract InsuranceActor {
  using Actors for Actors.Actor;

  event InsuranceAdded(address indexed account);
  event InsuranceRemoved(address indexed account);

  Actors.Actor private Insurances;

  constructor()  {_addInsurance(msg.sender);}

  modifier onlyInsurance() 
	{
	require(isInsurance(msg.sender));
	_;
	}

  function isInsurance(address account) public view returns (bool) {return Insurances.has(account);}

  function addInsurance(address account) public onlyInsurance {_addInsurance(account);}

  function removeInsurance() public {_removeInsurance(msg.sender);}

  function _addInsurance(address account) internal 
	{
	Insurances.add(account);
	emit InsuranceAdded(account);
	}

  function _removeInsurance(address account) internal 
	{
	Insurances.remove(account);
	emit InsuranceRemoved(account);
	}
}