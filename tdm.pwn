#include <a_samp>
#include <sscanf2>
#include <zcmd>

// -------------------------------------------------------------
new Time, TimeM, TimeS;
new Text:Textdraw0;
//--------------------------------------------------------------

main()
{
	print("\n----------------------------------");
	print(" TDM Gamemode by your name here");
	print("----------------------------------\n");
}

public OnGameModeInit()
{
	// Don't use these lines if it's a filterscript
	SetGameModeText("Blank Script");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	
	Textdraw0 = TextDrawCreate(17.000000, 429.000000, "TIMER");
	TextDrawBackgroundColor(Textdraw0, 65535);
	TextDrawFont(Textdraw0, 1);
	TextDrawLetterSize(Textdraw0, 0.500000, 1.000000);
	TextDrawColor(Textdraw0, 16777215);
	TextDrawSetOutline(Textdraw0, 1);
	TextDrawSetProportional(Textdraw0, 1);

	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

// ----------------------- EVENT--------------------------------

// -------------------------------------------------------------
enum pdata
{
	kill,
	death,
	team[24],
}
new pData[MAX_PLAYERS][pdata];
// -------------------------------------------------------------
enum data
{
	isGoingOn,
	isJoinable,
	time,
	killsLimit,
}
new eData[data];
//--------------------------------------------------------------
enum tdata
{
	players,
	kills,
	deaths,
}
new Red[tdata];
new Blue[tdata];
//--------------------------------------------------------------
new RedSpawn[3] = {123, 122, 11};
new BlueSpawn[3] = {120, 122, 11};

// -------------------------------------------------------------
// ----------------------- Funcs -------------------------------
stock IsPlayerRequiredAdmin(playerid)
{
	if(IsPlayerAdmin(playerid)) return true;
	else return false;
}
stock StartEvent(times, killss)
{
	eData[isGoingOn] = 1;
	eData[isJoinable] = 1;
	eData[time] = times;
	eData[killsLimit] = killss;
	Blue[players] = 0;
	Blue[kills] = 0;
	Blue[deaths] = 0;
	Red[players] = 0;
	Red[kills] = 0;
	Blue[deaths] = 0;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        pData[i][kill] = 0;
	        pData[i][death] = 0;
	        format(pData[i][team], 24, "None");
	    }
	}
	SetTimer("EventJoinAble", 10000, false);
	//SetTimer("TimeOver", times*1000*60, false);
	TimeM = times-1;
	TimeS = 10;
	Time = SetTimer("UpdateTime", 1000, true);
	SendClientMessageToAll(-1, "[EVENT] Event has been started, type /joinevent before joining is closed!");
}
forward UpdateTime();
public UpdateTime()
{
  new Str[34];
  TimeS --;
  if(TimeM == 0 && TimeS == 0)
  {
    KillTimer(Time);
    TimeOver();
  }
  if(TimeS == -1)
  {
    TimeM--;
    TimeS = 59;
  }
  format(Str, sizeof(Str), "%d:%d", TimeM, TimeS);
  TextDrawSetString(Textdraw0, Str);
  return 1;
}

forward TimeOver();
public TimeOver()
{
	if(Blue[kills] > Red[kills])
 	{
 	    SendClientMessageToAll(-1, "[EVENT] Blue Team has won the event as the time limit reached!");
 	}
	else if(Red[kills] > Blue[kills])
 	{
 	    SendClientMessageToAll(-1, "[EVENT] Red Team has won the event as the time limit reached!");
 	}
 	else if(Red[kills] == Blue[kills])
 	{
 	    SendClientMessageToAll(-1, "[EVENT] Event has resulted into a tie!");
 	}
	StopEvent();
}

forward EventJoinAble();
public EventJoinAble()
{
	for(new i =0 ; i < MAX_PLAYERS; i++)
	{
	    if(strcmp(pData[team], "Blue", true) == 0 || strcmp(pData[team], "Red", true) == 0)
	    {
	          TogglePlayerControllable(i,1);
	    }
	}
	eData[isJoinable] = 0;
	SendClientMessageToAll(-1, "[EVENT] Joining has been ended!");
}
stock AddPlayerToEvent(playerid)
{
	if(Red[players] > Blue[players])
	{
	    SetPlayerPos(playerid, BlueSpawn[0], BlueSpawn[1], BlueSpawn[2]);
	    Blue[players]++;
	    format(pData[playerid][team], 24, "Blue");
	    TextDrawShowForPlayer(playerid, Textdraw0);
     	TogglePlayerControllable(playerid,0);
	}
	else
	{
	    SetPlayerPos(playerid, RedSpawn[0], RedSpawn[1], RedSpawn[2]);
	    Red[players]++;
	    format(pData[playerid][team], 24, "Red");
		TextDrawShowForPlayer(playerid, Textdraw0);
		  TogglePlayerControllable(playerid,0);
	}
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(killerid != INVALID_PLAYER_ID)
	{
	    if(eData[isGoingOn] == 1)
		{
		    pData[killerid][kill]++;
		    pData[playerid][death]++;
			if(strcmp(pData[killerid][team], "Blue", true) == 0)
			{
				Blue[kills]++;
				Red[deaths]++;
			}
			if(strcmp(pData[killerid][team], "Red", true) == 0)
			{
				Red[kills]++;
				Blue[deaths]++;
			}
			CheckForEvent(killerid);
		}
	}
	return 1;
}

stock CheckForEvent(killerid)
{
	if(strcmp(pData[killerid][team], "Blue", true) == 0)
	{
	    if(Blue[kills] >= eData[killsLimit])
	    {
	        StopEvent();
	        SendClientMessageToAll(-1, "[EVENT] Blue team has won the event!");
	    }
	}
	if(strcmp(pData[killerid][team], "Red", true) == 0)
	{
	    if(Red[kills] >= eData[killsLimit])
	    {
	        StopEvent();
	        SendClientMessageToAll(-1, "[EVENT] Red team has won the event!");
	    }
	}
}
stock StopEvent()
{
    eData[isGoingOn] = 0;
	eData[time] = 0;
	eData[killsLimit] = 0;
	Blue[players] = 0;
	Blue[kills] = 0;
	Blue[deaths] = 0;
	Red[players] = 0;
	Red[kills] = 0;
	Blue[deaths] = 0;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(strcmp(pData[team], "Blue", true) == 0 || strcmp(pData[team], "Red", true) == 0)
			{
			    SpawnPlayer(i);
			    TextDrawHideForPlayer(i, Textdraw0);
			}
	        pData[i][kill] = 0;
	        pData[i][death] = 0;
	        format(pData[i][team], 24, "None");
	    }
	}
	KillTimer(Time);
}
// ------------------------ CMDS -------------------------------
CMD:startevent(playerid, params[])
{
	new times, killss;
	if(!IsPlayerRequiredAdmin(playerid)) return SendClientMessage(playerid, -1, "You are not allowed to use this CMD!");
	if(eData[isGoingOn] == 1) return SendClientMessage(playerid, -1, "Event is already going on!");
	if(sscanf(params, "ii", times, killss)) return SendClientMessage(playerid, -1, "[USAGE] /startevent [Time] [Kills]");
	StartEvent(time, kills);
	return 1;
}
CMD:joinevent(playerid, params[])
{
 	if(eData[isGoingOn] == 0) return SendClientMessage(playerid, -1, "[ERROR] No event is going on!");
	if(eData[isJoinable] == 0) return SendClientMessage(playerid, -1, "[EVENT] Joining is closed!");
 	AddPlayerToEvent(playerid);
 	return 1;
}
CMD:stopevent(playerid, params[])
{
	if(!IsPlayerRequiredAdmin(playerid)) return SendClientMessage(playerid, -1, "[ERROR] You arent an admin too stop!");
	if(eData[isGoingOn] == 0) return SendClientMessage(playerid, -1, "NO Event Going on!");
	StopEvent();
	SendClientMessageToAll(-1, "[EVENT] Event has been stopped by an admin!");
	return 1;
}
