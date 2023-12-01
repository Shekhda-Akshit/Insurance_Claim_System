// SPDX-License-Identifier: MIT

pragma solidity >=0.4.24;

import "./Actors.sol";

contract FarmerActor {
  using Actors for Actors.Actor;

  event FarmerAdded(address indexed account);
  event FarmerRemoved(address indexed account);

  Actors.Actor private farmers;

  constructor()  {_addFarmer(msg.sender);}

  modifier onlyFarmer() 
	{
	require(isFarmer(msg.sender));
	_;
	}

  function isFarmer(address account) public view returns (bool) {return farmers.has(account);}

  function addFarmer(address account) public onlyFarmer {_addFarmer(account);}

  function removeFarmer() public {_removeFarmer(msg.sender);}

  function _addFarmer(address account) internal 
	{
	farmers.add(account);
	emit FarmerAdded(account);
	}

  function _removeFarmer(address account) internal 
	{
	farmers.remove(account);
	emit FarmerRemoved(account);
	}
}