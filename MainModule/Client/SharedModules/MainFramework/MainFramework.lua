local main = {}



function main:Initialize(location, loader)
	
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
	
	
	
	-- << SETUP >>
	local function ConvertToCamelCase(pascalCase)
		local camelCase = string.lower(string.sub(pascalCase,1,1))..string.sub(pascalCase,2)
		return camelCase
	end
	
	if location == "Server" then
		-- Retrieve default settings
		local loaderCopy = main.insertService:LoadAsset(857927023)
		local settingsModuleCopy = loaderCopy:FindFirstChild("Settings", true)
		if settingsModuleCopy then
			main.settings = require(settingsModuleCopy)
		end
		
		-- Define storage folders
		main.mainModule = script:FindFirstAncestor("MainModule")
		main.server = main.mainModule.Server
		main.client = main.mainModule.Client
		for a,b in pairs(main.server:GetChildren()) do
			--main[ConvertToCamelCase(b.Name)] = b
		end
		
		-- Update settings
		local settingsModule = require(loader:FindFirstChild("Settings", true))
		if settingsModule then
			for settingName, value in pairs(settingsModule) do
				main.settings[settingName] = value
			end
		end
		
		-- Merge CustomFeatures into MainModule
		local customFeatures = loader:FindFirstChild("CustomFeatures", true)
		local function UpdateStorageWithContents(folder, coreFolderName)
			local newCoreFolderName = string.lower((coreFolderName == "Client" and coreFolderName) or "Server")
			local storageName = folder.Name
			local storage = main[newCoreFolderName]:FindFirstChild(storageName)
			if storage and storageName ~= "client" and storageName ~= "server" then
				for _, newItem in pairs(folder:GetChildren()) do
					local existingItem = storage:FindFirstChild(newItem.Name)
					if existingItem and not existingItem:IsA("ModuleScript") then
						existingItem:Destroy()
					end
					newItem.Parent = storage
				end
			end
		end
		if customFeatures then
			for a,b in pairs(customFeatures:GetChildren()) do
				UpdateStorageWithContents(b)
				local coreFolderName = b.Name
				for c,d in pairs(b:GetChildren()) do
					UpdateStorageWithContents(d, coreFolderName)
				end
			end
		end--]]
		
		-- Place items into correct locations
		local itemsToMove = {
			["Client"] = main.rs;
			["Server"] = main.ss;
			}
		local itemsToCloneAndMove = {
			["HDAdminLocalFirst"] = main.replicatedFirst;
			["HDAdminStarterCharacter"] = main.starterPlayer.StarterCharacterScripts;
			["HDAdminStarterPlayer"] = main.starterPlayer.StarterPlayerScripts;
			["HDAdminGUIs"] = main.starterGui;
			}
		local function CheckToMove(item)
			local itemName = item.Name
			local itemLocation = (itemsToMove[itemName] or itemsToCloneAndMove[itemName])
			if itemLocation and not itemLocation:FindFirstChild(itemName) then
				if itemsToMove[itemName] then
					item.Name = "HDAdmin"..itemName
					item.Parent = itemLocation
				elseif itemsToCloneAndMove[itemName] then
					local itemClone = item:Clone()
					itemClone.Parent = itemLocation
					if itemClone:IsA("LocalScript") then
						itemClone.Disabled = false
					end
				end
			end
		end
		for a,b in pairs(main.mainModule:GetChildren()) do
			CheckToMove(b)
			for c,d in pairs(b:GetChildren()) do
				CheckToMove(d)
				for e,f in pairs(d:GetChildren()) do
					CheckToMove(f)
				end
			end
		end
		
		-- Manually add items for players who joined early
		local setupQuickJoiners = main.server.Assets.SetupQuickJoiners
		for i, player in pairs(main.players:GetChildren()) do
			setupQuickJoiners:Clone().Parent = player.PlayerGui
		end
	
	
	
	
	elseif location == "Client" then
		-- Define storage folders
		main.client = main.rs:WaitForChild("HDAdminClient")
		for a,b in pairs(main.client:GetChildren()) do
			--main[ConvertToCamelCase(b.Name)] = b
		end
		
		-- Core client variables
		main.player = game.Players.LocalPlayer
		main.playerGui = main.player:WaitForChild("PlayerGui")
		main.gui = main.playerGui:WaitForChild("HDAdminGUIs")
		main.templates = main.gui.Templates
		main.warnings = main.gui.MainFrame:WaitForChild("Warnings")
		main.camera = workspace.CurrentCamera
		
		-- Get device type
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
		
		-- Retrieve PlayerData
		local dataToRetrieve
		repeat
			dataToRetrieve = main.client.Signals.RetrieveData:InvokeServer()
			if not dataToRetrieve then
				wait(1)
			end
		until dataToRetrieve
		for statName, statData in pairs(dataToRetrieve) do
			main[statName] = statData
		end
		
		
	end
	
	
	
	-- << SHARED CORE VARIABLES >>
	main.modules = {}
	main.coreFolder = main[string.lower(location)]
	main.moduleGroup = main.coreFolder.Modules
	main.sharedModules =  main.client.SharedModules
	main.signals = main.client.Signals
	main.audio = main.client.Audio
		
	
	
	-- << SETUP MODULES >>
	local moduleNamesToAdapt = {
		["cf"] = {"ClientCoreFunctions", "SharedCoreFunctions", "ServerCoreFunctions"};
		["API"] = {"ClientAPI", "ServerAPI", "SharedAPI"};
	}
	local moduleNamesToAdaptDictionary = {}
	for newName, originalNames in pairs(moduleNamesToAdapt) do
		for _, originalName in pairs(originalNames) do
			moduleNamesToAdaptDictionary[originalName] = newName
		end
	end
	local function SetupModules(folder, moduleStorage)
		for a,b in pairs(folder:GetDescendants()) do
			if b:IsA("ModuleScript") and b.Name ~= script.Name then
				
				--Adapt module name if specified
				local moduleName = b.Name
				local newModuleName = moduleNamesToAdaptDictionary[moduleName]
				if newModuleName then
					moduleName = newModuleName
				end
				
				--Retrieve module data
				local success, data = pcall(function() return require(b) end)
				
				--Warn of module error
				if not success then
					warn("HD Admin Module Error | "..b.Name.." | ".. tostring(data))
				
				--If module already exists, merge conetents
				elseif moduleStorage[moduleName] then
					for funcName, func in pairs(data) do
						if tonumber(funcName) then
							table.insert(moduleStorage[moduleName], func)
						else
							moduleStorage[moduleName][funcName] = func
						end
					end
					
				--Else setup new module
				else
					moduleStorage[moduleName] = data
				end
				
				--Hide module on client
				if location == "Client" and b.Name ~= script.Name then
					b:Destroy()
				end
				
			end
		end
	end
	require(script.MainVariables):SetupMainVariables(location)
	SetupModules(main.moduleGroup, main.modules)
	SetupModules(main.sharedModules, main.modules)
	
	
	
	-- << STARTER FUNCTIONS >>
	if location == "Server" then
		if not main.ownerName then
			main.ownerName = main.modules.cf:GetName(main.ownerId)
		end
		main.modules.cf:SetupCommands(main.server.Modules.Commands, false)
		main.modules.Parser:UpdateLoopRank()
		main.modules.LoaderHandler:Setup()
		main.chatService = require(main.sss:WaitForChild("ChatServiceRunner", 1):WaitForChild("ChatService", 1))
		main.client.Assets:WaitForChild("HDAdminSetup").Parent = main.rs
	end
	
	
	
	-- << END >>
	main.initialized = true
	main.client.Signals.Initialized:Fire()
end





-- << CHECK INITIALIZED >>
function main:CheckInitialized()
	if not main.initialized then
		script.Parent.Parent:WaitForChild("Signals"):WaitForChild("Initialized").Event:Wait()
	end
	return main
end



---------------------
_G.HDAdminMain = main
---------------------



return main
