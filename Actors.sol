// SPDX-License-Identifier: MIT
// Roles -> Actors, Role -> Actor, role -> actor
pragma solidity >=0.4.24;

library Actors 
{
	struct Actor {mapping (address => bool) bearer;}
	function add(Actor storage actor, address account) internal 
		{
		require(account != address(0));
		require(!has(actor, account));
		actor.bearer[account] = true;
  		}
	function remove(Actor storage actor, address account) internal 
		{
		require(account != address(0));
		require(has(actor, account));
		actor.bearer[account] = false;
		}
	function has(Actor storage actor, address account) internal view returns (bool)
		{
		require(account != address(0));
		return actor.bearer[account];
		}
}