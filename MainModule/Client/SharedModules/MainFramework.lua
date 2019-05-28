local main = {Initialized = false}
function main:Initialize(location, setupScript)
	
	-- << SERVICES >>
	main.rs = game:GetService("ReplicatedStorage")
	main.ss = game:GetService("ServerStorage")
	main.sss = game:GetService("ServerScriptService")
    main.players = game:GetService("Players")
	main.teleportService = game:GetService('TeleportService')
	main.badgeService = game:GetService("BadgeService")
	main.runService = game:GetService("RunService")
	main.tweenService = game:GetService("TweenService")
	main.marketplaceService = game:GetService("MarketplaceService")
	main.chat = game:GetService("Chat")
	main.dataStoreService = game:GetService("DataStoreService")
	main.physicsService = game:GetService("PhysicsService")
	main.starterGui = game:GetService("StarterGui")
	main.guiService = game:GetService("GuiService")
	main.userInputService = game:GetService("UserInputService")
	main.textService = game:GetService("TextService")
	main.debris = game:GetService("Debris")
	main.contentProvider = game:GetService("ContentProvider")
	main.replicatedFirst = game:GetService("ReplicatedFirst")
	main.starterPlayer = game:GetService("StarterPlayer")
	main.groupService = game:GetService("GroupService")
	main.teams = game:GetService("Teams")
	main.insertService = game:GetService("InsertService")
	main.lighting = game:GetService("Lighting")
	main.starterPack = game:GetService("StarterPack")
	main.messagingService = game:GetService("MessagingService")
	main.assetService = game:GetService("AssetService")
	if location == "Server" then
		coroutine.wrap(function()
			main.chatService = require(main.sss:WaitForChild("ChatServiceRunner"):WaitForChild("ChatService"))
		end)()
	end
	
	
	-- << INITIAL SETUP >>
	if location == "Server" then
		
		for _, dataLocation in pairs(setupScript:GetChildren()) do
			if dataLocation.Name == "Server" then
				main.serverContainer = dataLocation
				main.serverContainer.Name = "HDAdminServerContainer"
				main.serverContainer.Parent = main.ss
			elseif dataLocation.Name == "Client" then
				main.container = dataLocation
				main.container.Name = "HDAdminContainer"
				main.container.Parent = main.rs
				for _,folder in pairs(dataLocation:GetChildren()) do
					if folder:IsA("Folder") then
						if folder.Name == "StarterKit" then
							for a,b in pairs(folder:GetChildren()) do
								local objectLocation
								if b:IsA("ScreenGui") then
									objectLocation = main.starterGui
								elseif b.Name == "HDAdminLocalFirst" then
									objectLocation = main.replicatedFirst
								elseif b.Name == "HDAdminStarterCharacter" then
									objectLocation = main.starterPlayer.StarterCharacterScripts
								elseif b.Name == "HDAdminStarterPlayer" then
									objectLocation = main.starterPlayer.StarterPlayerScripts
								end
								if objectLocation:FindFirstChild(b.Name) == nil then
									local newObject = b:Clone()
									newObject.Parent = objectLocation
									if newObject:IsA("LocalScript") then
										newObject.Disabled = false
									end
								end
							end
						end
					end
				end
			end
		end
	else
		main.container = main.rs:WaitForChild("HDAdminContainer")
	end
	
	
	
	-- << MAIN VARIABLES >>
	main.alphabet = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"}
	main.network = main.container:WaitForChild("Network")
	main.sharedModules =  main.container:WaitForChild("SharedModules")
	main.modules = {}
	main.pd = {}
	main.sd = {}
	main.permissions = {
		specificUsers = {};
		gamepasses = {};
		assets = {};
		groups = {};
		friends = 0;
		freeAdmin = 0;
		vipServerOwner = 0;
		vipServerPlayer = 0;
		owner = true
	}
	main.UserIdsFromName = {}
	main.UsernamesFromUserId = {}
	main.validSettings = {"Theme", "NoticeSoundId", "NoticeVolume", "NoticePitch", "ErrorSoundId", "ErrorVolume", "ErrorPitch", "AlertSoundId", "AlertVolume", "AlertPitch", "Prefix"}
	main.commandInfoToShowOnClient = {"Name", "Contributors", "Prefixes", "Rank", "Aliases", "Tags", "Description", "Args", "Loopable"}
	main.validCommands = {}
	main.commandInfo = {}
	main.commandRanks = {}
	main.infoOnAllCommands = {
		Contributors = {};	--table
		Tags = {};			--table
		Prefixes = {};		--dictionary
		Aliases = {};		--dictionary
	}
	main.products = {
		Donor = 5745895;
		OldDonor = 2649766;
	}
	main.ownerId = game.CreatorId
	main.ownerName = "Owner"
	main.gameName = game.GameId
	main.materials = {"Plastic", "Wood", "Concrete", "CorrodedMetal", "DiamondPlate", "Foil", "Grass", "Ice", "Marble", "Granite", "Brick", "Pebble", "Sand", "Fabric", "SmoothPlastic", "Metal", "WoodPlanks", "Cobblestone", "Neon", "Glass",}
	main.rankTypes = {
		["Auto"] = 4;
		["Perm"] = 3;
		["Server"] = 2;
		["Temp"] = 1;
		}
	main.morphNames = {}
	main.toolNames = {}
	
	if location == "Server" then
		main.assets = main.serverContainer:WaitForChild("Assets")
		main.tools = main.assets:WaitForChild("Tools")
		main.moduleGroup = main.serverContainer.Modules
		main.commands = {}
		main.playersRanked = {}
		main.playersUnranked = {}
		main.settings.UniversalPrefix = "!";
		main.serverAdmins = {}
		main.owner = {}
		if game.CreatorType == Enum.CreatorType.Group then
			local ownerInfo = main.groupService:GetGroupInfoAsync(game.CreatorId).Owner
			main.ownerId = ownerInfo.Id
			main.ownerName = ownerInfo.Name
		end
		main.gameName = main.marketplaceService:GetProductInfo(game.PlaceId, Enum.InfoType.Asset).Name
		main.listOfTools = {}
		main.ranksAllowedToJoin = 0
		main.permissionToReplyToPrivateMessage = {}
		main.logs = {
			command = {};
			chat = {};
		}
		main.isStudio = main.runService:IsStudio()
		main.serverBans = {}
		main.blacklistedVipServerCommands = {}
		main.banned = {}
		main.commandBlocks = {}
		
		
	elseif location == "Client" then
		main.assets = main.container:WaitForChild("Assets")
		main.audio = main.assets:WaitForChild("Audio")
		main.templates = main.assets:WaitForChild("Templates")
		main.moduleGroup = main.container:WaitForChild("Modules")
		main.player = game.Players.LocalPlayer
		main.playerGui = main.player:WaitForChild("PlayerGui")
		main.gui = main.playerGui:WaitForChild("HDAdminGUIs")
		main.warnings = main.gui.MainFrame:WaitForChild("Warnings")
		main.camera = workspace.CurrentCamera
		main.qualifiers = {"me", "all", "others", "random", "admins", "nonAdmins", "friends", "nonFriends", "NBC", "BC", "TBC", "OBC", "R6", "R15", "rthro", "nonRthro"}
		main.colors = {}
		main.topbarEnabled = true
		main.blur = Instance.new("BlurEffect", main.camera)
		main.blur.Size = 0
		
		main.commandMenus = {}
		main.commandsToDisableCompletely = {laserEyes=true}
		main.commandsActive = {}
		main.commandsAllowedToUse = {}
		main.commandsWithMenus = {
			["Type1"] = {
				["laserEyes"] = {"Info", "Press and hold to activate."};
				["fly"] = {"Input", "Speed"};
				["fly2"] = {"Input", "Speed"};
				["noclip"] = {"Input", "Speed"};
				};
			["Type2"] = {
				["cmdbar2"] = {};
				};
			["Type3"] = {
				["bubbleChat"] = {};
				};
			}
		main.commandSpeeds = {
			fly = 50;
			fly2 = 50;
			noclip = 100;
			}
		main.infoFramesViewed = {
			Speed = true;
			}

		main.tablet = false
		if main.guiService:IsTenFootInterface() then
			main.device = "Console"
		elseif (main.userInputService.TouchEnabled and not main.userInputService.MouseEnabled) then
			main.device = "Mobile"
		else
			main.device = "Computer"
		end
		if main.gui.AbsoluteSize.Y < 1 then repeat wait() until main.gui.AbsoluteSize.Y > 0 end
		if main.device == "Mobile" then
			if main.gui.AbsoluteSize.Y >= 650 then
				main.tablet = true
			end
		end
		
		local dataToRetrieve
		repeat
			dataToRetrieve = main.network.RetrieveData:InvokeServer()
			if not dataToRetrieve then
				wait(1)
			end
		until dataToRetrieve
		for statName, statData in pairs(dataToRetrieve) do
			main[statName] = statData
		end
		
	end
	table.sort(main.settings.Ranks, function(a,b) return a[1] < b[1] end)
	
	
	
	-- << SETUP MODULES >>
	function main:SetupModules(folder, moduleStorage)
		for a,b in pairs(folder:GetDescendants()) do
			if b:IsA("ModuleScript") and b.Name ~= script.Name then
				local moduleName = b.Name
				--
				if moduleName == "ClientCoreFunctions" or moduleName == "ServerCoreFunctions" then
					moduleName = "cf"
				elseif moduleName == "ClientAPI" or moduleName == "ServerAPI" then
					moduleName = "API"
				end
				--
				local success, errorMessage = pcall(function() moduleStorage[moduleName] = require(b) end)
				if not success then
					warn("HD Admin Module Error | "..b.Name.." | "..errorMessage)
				else
					--
					if moduleName == "SharedCoreFunctions" then
						for funcName, func in pairs(main.modules.SharedCoreFunctions) do
							main.modules.cf[funcName] = func
						end
					elseif moduleName == "SharedAPI" then
						for funcName, func in pairs(main.modules.SharedAPI) do
							main.modules.API[funcName] = func
						end
					end
					--
				end
				if location == "Client" and b.Name ~= script.Name then
					b:Destroy()
				end
			end
		end
	end
	main:SetupModules(main.moduleGroup, main.modules)
	main:SetupModules(main.sharedModules, main.modules)
	if location == "Server" then
		main.modules.cf:SetupCommands(main.serverContainer.Modules.Commands, false)
		main.modules.Parser:UpdateLoopRank()
		if main.ownerName == "Owner" then
			main.ownerName = main.modules.cf:GetName(main.ownerId)
		end
	elseif location == "Client" then
		local customClientCommands = main.container.Assets:FindFirstChild("ClientCommands")
		if customClientCommands then
			local clientCommandsToAdd = require(customClientCommands)
			for commandName, command in pairs(clientCommandsToAdd) do
				main.modules.ClientCommands[commandName] = command
			end
		end
	end
	
	main.container.Assets.Bindables.Initialized:Fire()
	main.Initialized = true
	
end

function main:CheckInitialized(container)
	if not main.Initialized then
		--container.Assets.Bindables.Initialized.Event:Wait()
		container.Assets.Bindables.LoaderSetup.Event:Wait()
	end
	return main
end

return main
