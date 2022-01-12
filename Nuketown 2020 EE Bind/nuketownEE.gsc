/*
    How to use:

    self.pers["customEETime"] can be setup to whatever time you'd like. You may define it on PlayerConnnect.
        - This is the time for the EE to teleport you back to your position.
        - If you would like it to set your it back to your Original Player angles, you may use
    
    self.isEEing = false; may be called OnSpawn or on PlayerConnect.

    adjustEESpeed must be used as such:
        - ::adjustEESpeed, 0.5, true); adds 0.5 to the time.
        - ::adjustEESpeed, 0.5); subtracts 0.5 to the time.

    wowWaitFrame(); = wait 0.05 for normal waitframe since GSC loaders have a tendency to error out.
    
    self thread nuketownEaster(); will initiate the EE function. You may use whatever bind system you'd like in order to initiate it.

    This was ripped directly from mp_nuketown_2020.gsc and partially modified to allow it to be used anytime and place you back at your original position.
        - You may modify this in anyway to your liking.
    
*/

wowWaitFrame()
{
	wait 0.05;
}

adjustEESpeed(amount, speed)
{
    value = self.pers["customEETime"];
	if(isDefined(speed))
	{
		value = value + amount;
        self.pers["customEETime"] = value;
	}	
	else
	{
		value = value - amount;
        self.pers["customEETime"] = value;
	}
	self iPrintLn("Return to EE Origin set to: ^2" + value);
}

nuketownEaster()
{
    if(!self.isEEing)
    {
        self.isEEing = true;
        originalArea = self getorigin();
        wowWaitFrame();
        tvPlacement = getent( "player_tv_position", "targetname" );
        self.prevWeapon = self getcurrentweapon();
        self giveweapon( "vcs_controller_mp" );
        self switchtoweapon( "vcs_controller_mp" );
        moveMyTV = spawn( "script_model", self.origin );
        self linkto( moveMyTV );
        moveMyTV moveto( tvPlacement.origin, 0.5, 0.05, 0.05 );
        self enableinvulnerability();
        self openmenu( "vcs" );
        wait self.pers["customEETime"];
        myOriginBolt = spawn( "script_model", originalArea );
        self linkto( myOriginBolt );
        myOriginBolt moveto(level.origCord, 0.5, 0.05, 0.05);
        self disableinvulnerability();
        self takeweapon( "vcs_controller_mp" );
        self switchtoweapon( self.prevWeapon );
        self closeInGameMenu();
        wowWaitFrame();
        moveMyTV delete();
        myOriginBolt delete();
        self unlink();
        self.isEEing = false;
    }
}