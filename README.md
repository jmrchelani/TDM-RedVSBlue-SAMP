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
> * If you want to add more teams, you have to remove:
```pawn
new Blue[tdata];
new Red[tdata];
```
> and add a dynamic team system:
```pawn
#define MAX_TEAMS 10
enum tdata{
	team vars,
	a,
	b,
	c, 
	....
}
new tData[MAX_TEAMS][tdata];
```
> This way now there are 10 teams each having fixed set of variables!

### For more assistance and queries please hit me up with a DM here or on discord: Milton#0939
