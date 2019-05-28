local module = {}

function module:GetNotice(noticeName)
	local coreNotices = {
	
	WelcomeRank = {
		"HD Admin",
		"Your rank is '%s'! Click to view the commands.", -- (rankName)
		{"ShowSpecificPage", "Commands", "Commands"}
		};
	
	WelcomeDonor = {
		"HD Admin",
		"Your're a Donor! Click to view Donor Commands.",
		{"ShowSpecificPage", "Special", "Donor"}
		};
	
	SetRank = {
		"HD Admin",
		"You've been %sed to '%s'!" -- (rankType, rankName)
		};
	
	UnlockRank = {
		"HD Admin",
		"You've unlocked the rank '%s'!" -- (rankName)
		};
	
	UnRank = {
		"HD Admin",
		"You've been unranked!"
		};
	
	ParserInvalidCommandRank = {
		"HD Admin",
		"'%s' is not a valid command! Try '%srank plr %s' instead." -- (commandName, prefix, rankName)
		};
	
	ParserInvalidCommandNormal = {
		"HD Admin",
		"'%s' is not a valid command!", -- (commandName)
		""
		};
	
	ParserInvalidPrefix = {
		"HD Admin",
		"Invalid prefix! Try '%s%s' instead.", -- (correctedPrefix, commandName)
		};
	
	ParserInvalidVipServer = {
		"HD Admin",
		"You cannot use '%s' in VIP Servers.", -- (commandName)
		};
	
	ParserInvalidDonor = {
		"HD Admin",
		"You must be a Donor to use that command!",
		};
	
	ParserInvalidLoop = {
		"HD Admin",
		"You do not have permission to use Loop commands!",
		};
	
	ParserInvalidRank = {
		"HD Admin",
		"You do not have permission to use '%s'", -- (commandName)
		};
	
	ParserCommandBlock = {
		"HD Admin",
		"Commands are temporarily disabled.'",
		};
	
	ParserInvalidRigType = {
		"HD Admin",
		"%s must be %s to use that command.",  -- (playerName, rigType)
		};
	
	ParserPlayerRankBlocked = {
		"HD Admin",
		"You do not have the permissions to use '%s' on %s!",  -- (commandName, playerName)
		};
	
	ParserSpeakerRank = {
		"HD Admin",
		"You %sed %s to '%s'", -- (commandName, playersRanked, rankName)
		};
	
	ParserSpeakerUnrank = {
		"HD Admin",
		"You unranked %s", -- (amount of players unranked)
		};
	
	ParserPlrPunished = {
		"HD Admin",
		"%s must be unpunished to use that command.",  -- (playerName)
		};
	
	ReceivedPM = {
		"HD Admin",
		"You have a message from %s! Click to open.", -- (playerName)
		};
	
	RemovePermRank = {
		"HD Admin",
		"Successfully unranked %s!", -- (playerName)
		};
	
	BroadcastSuccessful = {
		"HD Admin",
		"Broadcast successful! Your announcement will appear shortly.",
		};
	
	BroadcastFailed = {
		"HD Admin",
		"Broadcast failed to send.",
		};
	
	InformPrefix = {
		"HD Admin",
		"The server prefix is '%s'", -- (prefix)
		};
	
	GetSoundSuccess = {
		"HD Admin",
		"The ID of the sound playing is: %s", -- (soundId)
		};
	
	GetSoundFail = {
		"HD Admin",
		"No sound is playing!",
		};
	
	UnderControl = {
		"HD Admin",
		"You're being controlled by %s!", -- (playerName)
		};
	
	ClickToTeleport = {
		"Teleport",
		"Click to teleport to '%s' [%s]", -- (placeName, placeId)
		};
	
	BanSuccess = {
		"HD Admin",
		"Successfully banned %s! Click to view the Banland.", -- (playerName)
		{"ShowSpecificPage", "Admin", "Banland"}
		};
	
	UnBanSuccess = {
		"HD Admin",
		"Successfully unbanned %s!", -- (playerName)
		};
	
	QualifierLimitToSelf = {
		"HD Admin",
		"'%ss' can only use commands on theirself!" -- (rankName)
		};
	
	QualifierLimitToOnePerson = {
		"HD Admin",
		"'%ss' can only use commands on one person at a time!" -- (rankName)
		};
	
	ScaleLimit = {
		"HD Admin",
		"The ScaleLimit is: %s | Rank required to exceed ScaleLimit: '%s'" -- (scaleLimit, rankName)
		};
	
	RequestsLimit = {
		"HD Admin",
		"You're sending requests too fast!"
		};
	
	AlertFail = {
		"HD Admin",
		"Alert failed to send."
		};
	
	PollFail = {
		"HD Admin",
		"Poll failed to send."
		};
	
	GearBlacklist = {
		"HD Admin",
		"Cannot insert gear: %s. This item has been blacklisted.", -- (gearId)
		};
	
	BanFailLength = {
		"HD Admin",
		"%sBan Length must be greater than 0!" -- (Predefined message)
		};
	
	BanFailVIPServer = {
		"HD Admin",
		"%s'permBan' is prohibited on VIP Servers!" -- (Predefined message)
		};
	
	BanFailAllServers = {
		"HD Admin",
		"You do not have permission to ban players from 'all servers'."
		};
	
	BanFailAlreadyBanned = {
		"HD Admin",
		"%splayer has already been banned!" -- (Predefined message)
		};
	
	RestoreDefaultSettings = {
		"Settings",
		"Successfully restored all settings to default!"
		};
	
	CommandBarLocked = {
		"HD Admin",
		"You do not have permission to use the commandBar%s! Rank required: '%s'" -- (barId, rankName)
		};
	
	template = {
		"HD Admin",
		""
		};
	
	}

	return coreNotices[noticeName]
	
end


return module
