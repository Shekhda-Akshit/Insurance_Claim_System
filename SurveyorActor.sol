// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.24;

import "./Actors.sol";

contract SurveyorActor {
  using Actors for Actors.Actor;

  event SurveyorAdded(address indexed account);
  event SurveyorRemoved(address indexed account);

  Actors.Actor private Surveyors;

  constructor()  {_addSurveyor(msg.sender);}

  modifier onlySurveyor() 
	{
	require(isSurveyor(msg.sender));
	_;
	}

  function isSurveyor(address account) public view returns (bool) {return Surveyors.has(account);}

  function addSurveyor(address account) public onlySurveyor {_addSurveyor(account);}

  function removeSurveyor() public {_removeSurveyor(msg.sender);}

  function _addSurveyor(address account) internal 
	{
	Surveyors.add(account);
	emit SurveyorAdded(account);
	}

  function _removeSurveyor(address account) internal 
	{
	Surveyors.remove(account);
	emit SurveyorRemoved(account);
	}
}