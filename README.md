# TDM Red VS Blue SAMP
How to modify?

> * To modify the admin level for /startevent:
```pawn
stock IsPlayerRequiredAdmin(playerid)
{
	if(IsPlayerAdmin(playerid)) return true; // CHANGE HERE
	else return false;
}
```
