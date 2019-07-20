local main = _G.HDAdminMain
local settings = main.settings



local module = {
	
	
	
	
	----------------------------------- (0) NONADMIN COMMANDS -----------------------------------
	{
	Name = "commands";
	Aliases	= {"cmds"};
	Prefixes = {settings.UniversalPrefix, settings.Prefix};
	Rank = 0;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		main.signals.ShowPage:FireClient(speaker, {"Commands", "Commands"})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "morphs";
	Aliases	= {};
	Prefixes = {settings.UniversalPrefix, settings.Prefix};
	Rank = 0;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		main.signals.ShowPage:FireClient(speaker, {"Commands", "Morphs"})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "donor";
	Aliases	= {};
	Prefixes = {settings.UniversalPrefix, settings.Prefix};
	Rank = 0;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		main.signals.ShowPage:FireClient(speaker, {"Special", "Donor"})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "serverRanks";
	Aliases	= {"admins"};
	Prefixes = {settings.UniversalPrefix, settings.Prefix};
	Rank = 0;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		main.signals.ShowPage:FireClient(speaker, {"Admin", "Server Ranks"})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "ranks";
	Aliases	= {};
	Prefixes = {settings.UniversalPrefix, settings.Prefix};
	Rank = 0;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		main.signals.ShowPage:FireClient(speaker, {"Admin", "Ranks"})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "banland";
	Aliases	= {"banlist"};
	Prefixes = {settings.UniversalPrefix, settings.Prefix};
	Rank = 0;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		main.signals.ShowPage:FireClient(speaker, {"Admin", "Banland"})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "logs";
	Aliases	= {"commandLogs"};
	Prefixes = {settings.UniversalPrefix, settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		local log = main:GetModule("cf"):GetLog("command", plr)
		main.signals.CreateLog:FireClient(plr, {"commandLogs", log})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "chatLogs";
	Aliases	= {};
	Prefixes = {settings.UniversalPrefix, settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		local log = main:GetModule("cf"):GetLog("chat", plr)
		main.signals.CreateLog:FireClient(plr, {"chatLogs", log})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "info";
	Aliases	= {"about"};
	Prefixes = {settings.UniversalPrefix, settings.Prefix};
	Rank = 0;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		main.signals.ShowPage:FireClient(speaker, {"About", "Info"})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "credits";
	Aliases	= {};
	Prefixes = {settings.UniversalPrefix, settings.Prefix};
	Rank = 0;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		main.signals.ShowPage:FireClient(speaker, {"About", "Credits"})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "updates";
	Aliases	= {};
	Prefixes = {settings.UniversalPrefix, settings.Prefix};
	Rank = 0;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		main.signals.ShowPage:FireClient(speaker, {"About", "Updates"})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "settings";
	Aliases	= {};
	Prefixes = {settings.UniversalPrefix, settings.Prefix};
	Rank = 0;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		main.signals.ShowPage:FireClient(speaker, {"Settings", "Custom"})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "prefix";
	Aliases	= {};
	Prefixes = {settings.UniversalPrefix, settings.Prefix};
	Rank = 0;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local prefix = main.pd[speaker].Prefix
		main:GetModule("cf"):FormatAndFireNotice(speaker, "InformPrefix", prefix)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "clear";
	Aliases	= {"clr"};
	Prefixes = {settings.UniversalPrefix, settings.Prefix};
	Rank = 0;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "Clears all messages off your screen";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local prefix = main.pd[speaker].Prefix
		main.signals.Clear:FireClient(speaker)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "radio";
	Aliases	= {};
	Prefixes = {settings.UniversalPrefix, settings.Prefix};
	Rank = 0;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "COMING SOON";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "getSound";
	Aliases	= {"getSong", "getMusic"};
	Prefixes = {settings.UniversalPrefix, settings.Prefix};
	Rank = 0;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local sound = workspace:FindFirstChild("HDAdminSound")
		if sound and sound.IsPlaying then
			local soundId = string.match(sound.SoundId, "%d+")
			main:GetModule("cf"):FormatAndFireNotice(speaker, "GetSoundSuccess", soundId)
			pcall(function() main.marketplaceService:PromptPurchase(speaker, tonumber(soundId)) end)
		else
			main:GetModule("cf"):FormatAndFireNotice(speaker, "GetSoundFail")
		end
	end;
	--
	};
	
	
	-----------------------------------
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	----------------------------------- (1) VIP COMMANDS -----------------------------------
	{
	Name = "cmdbar";
	Aliases	= {"commandBar"};
	Prefixes = {settings.UniversalPrefix, settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	ClientCommand = true;
	--
	};
	
	
	-----------------------------------
	{
	Name = "cmdbar2";
	Aliases	= {"commandBar2"};
	Prefixes = {settings.UniversalPrefix, settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	ClientCommandToActivate = true;
	--
	};
	
	
	-----------------------------------
	{
	Name = "refresh";
	Aliases	= {"re"};
	Prefixes = {settings.UniversalPrefix, settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "Clears all effects and loops from the player";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		for commandName, people in pairs(main.functionsInLoop) do
			if people[plr] then
				main.functionsInLoop[commandName][plr] = nil
			end
		end
		local originalCFrame
		local head = main:GetModule("cf"):GetHead(plr)
		if head then
			originalCFrame = head.CFrame
		end
		plr:LoadCharacter()
		local head = plr.Character:WaitForChild("Head")
		if originalCFrame then
			head.CFrame = originalCFrame
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "respawn";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		plr:LoadCharacter()
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "shirt";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Number"};
	Function = function(speaker, args)
		local plr = args[1]
		local id = args[2]
		main:GetModule("MorphHandler"):ChangeProperty(plr, "Shirt", id)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "pants";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Number"};
	Function = function(speaker, args)
		local plr = args[1]
		local id = args[2]
		main:GetModule("MorphHandler"):ChangeProperty(plr, "Pants", id)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "hat";
	Aliases	= {"accessory"};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Number"};
	Function = function(speaker, args)
		local plr = args[1]
		local id = args[2]
		main:GetModule("MorphHandler"):AddAccessory(plr, id)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "clearHats";
	Aliases	= {"clrHats", "clearAccessories", "clrAccessories", "removeHats", "removeAccessories",};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		main:GetModule("MorphHandler"):ClearAccessories(plr)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "face";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Number"};
	Function = function(speaker, args)
		local plr = args[1]
		local id = args[2]
		main:GetModule("MorphHandler"):ChangeProperty(plr, "Face", id)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "invisible";
	Aliases	= {"invis",};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		if plr.Character then
			main:GetModule("cf"):SetTransparency(plr.Character, 1)
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "visible";
	Aliases	= {"vis",};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		if plr.Character then
			main:GetModule("cf"):SetTransparency(plr.Character, 0)
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "paint";
	Aliases	= {"color","colour",};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Color"};
	Function = function(speaker, args)
		local plr = args[1]
		local color = args[2]
		if plr.Character then
			main:GetModule("MorphHandler"):ClearProperty(plr, "Shirt")
			main:GetModule("MorphHandler"):ClearProperty(plr, "Pants")
			main:GetModule("MorphHandler"):ChangeAllBodyColors(plr, color)
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "material";
	Aliases	= {"mat","surface",};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Material"};
	Function = function(speaker, args)
		local plr = args[1]
		local material = args[2]
		local char = plr.Character
		if char then
			main:GetModule("cf"):SetFakeBodyParts(char, {Material = material})
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "reflectance";
	Aliases	= {"ref","shiny"};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Number"};
	Function = function(speaker, args)
		local plr = args[1]
		local number = args[2]
		local char = plr.Character
		if char then
			main:GetModule("cf"):SetFakeBodyParts(char, {Reflectance = number})
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "transparency";
	Aliases	= {"trans",};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Number"};
	Function = function(speaker, args)
		local plr = args[1]
		local number = args[2]
		local char = plr.Character
		if char then
			main:GetModule("cf"):SetFakeBodyParts(char, {Transparency = number})
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "glass";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		local char = plr.Character
		if char then
			main:GetModule("cf"):SetFakeBodyParts(char, {Color = Color3.fromRGB(255, 255, 255), Material = Enum.Material.Glass, Transparency = 0.5})
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "neon";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		local char = plr.Character
		if char then
			main:GetModule("cf"):SetFakeBodyParts(char, {Color = Color3.fromRGB(150, 150, 150), Material = Enum.Material.Neon, Transparency = 0})
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "shine";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		local char = plr.Character
		if char then
			main:GetModule("cf"):SetFakeBodyParts(char, {Reflectance = 0, Material = Enum.Material.Neon, Transparency = 0.5})
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "ghost";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		local char = plr.Character
		if char then
			main:GetModule("cf"):SetFakeBodyParts(char, {Reflectance = 0, Color = Color3.fromRGB(255, 255, 255), Material = Enum.Material.SmoothPlastic, Transparency = 0.7})
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "gold";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		local char = plr.Character
		if char then
			main:GetModule("cf"):SetFakeBodyParts(char, {Reflectance = 0.5, Color = Color3.fromRGB(255, 176, 0), Material = Enum.Material.SmoothPlastic, Transparency = 0})
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "jump";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		local humanoid = main:GetModule("cf"):GetHumanoid(plr)
		if humanoid then
			humanoid.Jump = true
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "sit";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		local humanoid = main:GetModule("cf"):GetHumanoid(plr)
		if humanoid then
			humanoid.Sit = true
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "bigHead";
	Aliases	= {"bhead"};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		main:GetModule("MorphHandler"):SetHeadMeshSize(plr, Vector3.new(2,2,2))
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		main:GetModule("MorphHandler"):SetHeadMeshSize(plr, Vector3.new(1,1,1))
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "smallHead";
	Aliases	= {"shead"};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		main:GetModule("MorphHandler"):SetHeadMeshSize(plr, Vector3.new(0.75,0.75,0.75))
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		main:GetModule("MorphHandler"):SetHeadMeshSize(plr, Vector3.new(1,1,1))
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "potatoHead";
	Aliases	= {"phead"};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		local head = main:GetModule("cf"):GetHead(plr)
		if head then
			local mesh = head:FindFirstChildOfClass("SpecialMesh")
			if mesh then
				main:GetModule("MorphHandler"):ClearAccessories(plr)
				mesh.MeshType = Enum.MeshType.Sphere
			end
		end
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		local head = main:GetModule("cf"):GetHead(plr)
		if head then
			local mesh = head:FindFirstChildOfClass("SpecialMesh")
			if mesh then
				mesh.MeshType = Enum.MeshType.Head
			end
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "spin";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Number"};
	Function = function(speaker, args)
		local plr = args[1]
		local number = args[2]
		if number == 0 then
			number = 14
		end
		local head = main:GetModule("cf"):GetHead(plr)
		if head then
			local spin1 = head:FindFirstChild("HDAdminSpin1")
			local spin2 = head:FindFirstChild("HDAdminSpin2")
			if not spin1 then
				spin1 = Instance.new("BodyAngularVelocity")
				spin1.MaxTorque = Vector3.new(300000, 300000, 300000)
				spin1.P = 300
				spin1.Name = "HDAdminSpin1"
				spin1.Parent = head
				spin2 = Instance.new("BodyGyro")
				spin2.MaxTorque = Vector3.new(400000, 0, 400000)
				spin2.D = 500
				spin2.P = 300
				spin2.Name = "HDAdminSpin2"
				spin2.Parent = head
			end
			spin1.AngularVelocity = Vector3.new(0,number,0)
		end
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		local head = main:GetModule("cf"):GetHead(plr)
		if head then
			local spin1 = head:FindFirstChild("HDAdminSpin1")
			local spin2 = head:FindFirstChild("HDAdminSpin2")
			if spin1 then
				spin1:Destroy()
				spin2:Destroy()
			end
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "poop";
	Aliases	= {"poo", "explosiveDiarrhoea"};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	ClientCommand = true;
	FireAllClients = true;
	BlockWhenPunished = true;
	Function = function(speaker, args)
		wait(12)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "icecream";
	Aliases	= {"ic","clown"};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	ClientCommand = true;
	FireAllClients = true;
	BlockWhenPunished = true;
	Function = function(speaker, args)
		wait(26)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "warp";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = true;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	ClientCommand = true;
	Function = function(speaker, args)
		wait(7.5)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "blur";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Number"};
	ClientCommand = true;
	--
	};
	
	
	-----------------------------------
	{
	Name = "hideGuis";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	ClientCommand = true;
	--
	};
	
	
	-----------------------------------
	{
	Name = "showGuis";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	ClientCommand = true;
	--
	};
	
	
	-----------------------------------
	{
	Name = "ice";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		local itemName = "FreezeBlock"
		local hrp = main:GetModule("cf"):GetHRP(plr)
		if main.pd[plr].Items[itemName] == nil and hrp then
			local item = main.server.Assets.FreezeBlock:Clone()
			item.Name = plr.Name.."'s "..itemName
			item.CanCollide = false
			item.CFrame = hrp.CFrame
			main.pd[plr].Items[itemName] = item
			item.Parent = workspace
			local clone = main:GetModule("cf"):CreateClone(plr.Character)
			clone.PrimaryPart = clone.HumanoidRootPart
			clone:SetPrimaryPartCFrame(item.CFrame)
			clone.Name = "FreezeClone"
			clone.Parent = item
			main:GetModule("cf"):AnchorModel(clone, true)
			local faces = {2620487058, 258192246, 20909031, 147144198}
			local faceId = faces[math.random(1,#faces)]
			main:GetModule("MorphHandler"):ChangeFace(clone, faceId)
			main:GetModule("Extensions"):SetupItem(plr, itemName)
		end
	end;
	UnFunction = function(speaker, args)
		main:GetModule("cf"):UnFreeze(args)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "thaw";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		main:GetModule("cf"):UnFreeze(args)
		local plr = args[1]
		if plr and plr.Character then
			main:GetModule("cf"):AnchorModel(plr.Character, false)
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "freeze";
	Aliases	= {"anchor"};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		if plr and plr.Character then
			main:GetModule("cf"):AnchorModel(plr.Character, true)
		end
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		if plr and plr.Character then
			main:GetModule("cf"):AnchorModel(plr.Character, false)
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "jail";
	Aliases	= {"jailCell","jc"};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		local itemName = "JailCell"
		local head = main:GetModule("cf"):GetHead(plr)
		if main.pd[plr].Items[itemName] == nil and head then
			local item = main.server.Assets[itemName]:Clone()
			item.Name = plr.Name.."'s "..itemName
			item.PrimaryPart = item.Union
			item:SetPrimaryPartCFrame(head.CFrame * CFrame.new(0,-0.2,0))
			main.pd[plr].Items[itemName] = item
			item.Parent = workspace
			main:GetModule("Extensions"):SetupItem(plr, itemName)
		end
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		local itemName = "JailCell"
		local item = main.pd[plr].Items[itemName]
		if item then
			main.pd[plr].Items[itemName] = nil
			item:Destroy()
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "forceField";
	Aliases	= {"ff"};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		main:GetModule("cf"):CreateEffect(plr, "ForceField")
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		main:GetModule("cf"):RemoveEffect(plr, "ForceField")
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "fire";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		main:GetModule("cf"):CreateEffect(plr, "Fire")
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		main:GetModule("cf"):RemoveEffect(plr, "Fire")
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "smoke";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		main:GetModule("cf"):CreateEffect(plr, "Smoke")
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		main:GetModule("cf"):RemoveEffect(plr, "Smoke")
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "sparkles";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		main:GetModule("cf"):CreateEffect(plr, "Sparkles")
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		main:GetModule("cf"):RemoveEffect(plr, "Sparkles")
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "name";
	Aliases	= {"fakeName"};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Text"};
	Function = function(speaker, args)
		local plr = args[1]
		local text = args[2]
		main:GetModule("cf"):CreateFakeName(plr, text)
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		local head = main:GetModule("cf"):GetHead(plr)
		local fakeName = main:GetModule("cf"):GetFakeName(plr)
		if head and fakeName then
			fakeName:Destroy()
			head.Transparency = 0
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "hideName";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		local text = ""
		main:GetModule("cf"):CreateFakeName(plr, text)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "showName";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		local head = main:GetModule("cf"):GetHead(plr)
		local fakeName = main:GetModule("cf"):GetFakeName(plr)
		if head and fakeName then
			fakeName:Destroy()
			head.Transparency = 0
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "r15";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		main:GetModule("cf"):ConvertCharacterToRig(plr, "R15")
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "r6";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		main:GetModule("cf"):ConvertCharacterToRig(plr, "R6")
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "nightVision";
	Aliases	= {"nv"};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	ClientCommand = true;
	--
	};
	
	
	-----------------------------------
	{
	Name = "dwarf";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	RequiresRig = Enum.HumanoidRigType.R15;
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		local size = 1
		main:GetModule("MorphHandler"):ChangeProperties(plr, {DepthScale = 0.75*size, HeightScale = 0.5*size, WidthScale = 0.75*size, HeadScale = 1.4*size})
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		main:GetModule("MorphHandler"):ChangeProperties(plr, {DepthScale = 1, HeightScale = 1, WidthScale = 1, HeadScale = 1})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "giant";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	RequiresRig = Enum.HumanoidRigType.R15;
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		local size = 3
		main:GetModule("MorphHandler"):ChangeProperties(plr, {DepthScale = 0.75*size, HeightScale = 0.5*size, WidthScale = 0.65*size, HeadScale = 1.4*size})
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		main:GetModule("MorphHandler"):ChangeProperties(plr, {DepthScale = 1, HeightScale = 1, WidthScale = 1, HeadScale = 1})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "size";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	RequiresRig = Enum.HumanoidRigType.R15;
	--
	Args = {"Player", "Scale"};
	Function = function(speaker, args)
		local plr = args[1]
		local size = args[2]
		main:GetModule("MorphHandler"):ChangeProperties(plr, {DepthScale = 1*size, HeightScale = 1*size, WidthScale = 1*size, HeadScale = 1*size})
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		main:GetModule("MorphHandler"):ChangeProperties(plr, {DepthScale = 1, HeightScale = 1, WidthScale = 1, HeadScale = 1})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "bodyTypeScale";
	Aliases	= {"btScale"};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	RequiresRig = Enum.HumanoidRigType.R15;
	--
	Args = {"Player", "Scale"};
	Function = function(speaker, args)
		local plr = args[1]
		local number = args[2]
		main:GetModule("MorphHandler"):ChangeProperties(plr, {BodyTypeScale = number})
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		main:GetModule("MorphHandler"):ChangeProperties(plr, {BodyTypeScale = 0.3})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "depth";
	Aliases	= {"dScale", "depthScale"};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	RequiresRig = Enum.HumanoidRigType.R15;
	--
	Args = {"Player", "Scale"};
	Function = function(speaker, args)
		local plr = args[1]
		local number = args[2]
		main:GetModule("MorphHandler"):ChangeProperties(plr, {DepthScale = number})
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		main:GetModule("MorphHandler"):ChangeProperties(plr, {DepthScale = 1})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "headSize";
	Aliases	= {"headScale"};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	RequiresRig = Enum.HumanoidRigType.R15;
	--
	Args = {"Player", "Scale"};
	Function = function(speaker, args)
		local plr = args[1]
		local number = args[2]
		main:GetModule("MorphHandler"):ChangeProperties(plr, {HeadScale = number})
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		main:GetModule("MorphHandler"):ChangeProperties(plr, {HeadScale = 1})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "height";
	Aliases	= {"hScale", "heightScale"};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	RequiresRig = Enum.HumanoidRigType.R15;
	--
	Args = {"Player", "Scale"};
	Function = function(speaker, args)
		local plr = args[1]
		local number = args[2]
		main:GetModule("MorphHandler"):ChangeProperties(plr, {HeightScale = number})
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		main:GetModule("MorphHandler"):ChangeProperties(plr, {HeightScale = 1})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "hipHeight";
	Aliases	= {"hip"};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--RequiresRig = Enum.HumanoidRigType.R15;
	--
	Args = {"Player", "Scale"};
	Function = function(speaker, args)
		local plr = args[1]
		local number = args[2]
		local humanoid = main:GetModule("cf"):GetHumanoid(plr)
		if humanoid then
			humanoid.HipHeight = number
		end
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		local humanoid = main:GetModule("cf"):GetHumanoid(plr)
		if humanoid then
			main:GetModule("MorphHandler"):UpdateHipHeight(plr.Character)
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "squash";
	Aliases	= {"flat", "flatten"};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	RequiresRig = Enum.HumanoidRigType.R15;
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		main:GetModule("MorphHandler"):ChangeProperties(plr, {HeightScale = 0.1})
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		main:GetModule("MorphHandler"):ChangeProperties(plr, {HeightScale = 1})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "proportion";
	Aliases	= {"pScale", "proportionScale"};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	RequiresRig = Enum.HumanoidRigType.R15;
	--
	Args = {"Player", "Scale"};
	Function = function(speaker, args)
		local plr = args[1]
		local number = args[2]
		main:GetModule("MorphHandler"):ChangeProperties(plr, {ProportionScale = number})
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		main:GetModule("MorphHandler"):ChangeProperties(plr, {ProportionScale = 1})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "width";
	Aliases	= {"wScale", "widthScale"};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	RequiresRig = Enum.HumanoidRigType.R15;
	--
	Args = {"Player", "Scale"};
	Function = function(speaker, args)
		local plr = args[1]
		local number = args[2]
		main:GetModule("MorphHandler"):ChangeProperties(plr, {WidthScale = number})
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		main:GetModule("MorphHandler"):ChangeProperties(plr, {WidthScale = 1})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "fat";
	Aliases	= {"obese"};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	RequiresRig = Enum.HumanoidRigType.R15;
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		main:GetModule("MorphHandler"):ChangeProperties(plr, {WidthScale = 2, DepthScale = 1.5})
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		main:GetModule("MorphHandler"):ChangeProperties(plr, {WidthScale = 1, DepthScale = 1})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "thin";
	Aliases	= {"skinny"};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	RequiresRig = Enum.HumanoidRigType.R15;
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		main:GetModule("MorphHandler"):ChangeProperties(plr, {WidthScale = 0.2, DepthScale = 0.2})
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		main:GetModule("MorphHandler"):ChangeProperties(plr, {WidthScale = 1, DepthScale = 1})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "char";
	Aliases	= {"become"};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "UserId"};
	Function = function(speaker, args)
		local plr = args[1]
		local userId = args[2]
		main:GetModule("MorphHandler"):BecomeTargetPlayer(plr, userId)
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		local userId = plr.UserId
		main:GetModule("MorphHandler"):BecomeTargetPlayer(plr, userId)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "morph";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Morph"};
	Function = function(speaker, args)
		local plr = args[1]
		local morph = args[2]
		if morph then
			main:GetModule("MorphHandler"):Morph(plr, morph)
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "view";
	Aliases	= {"watch","spectate"};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	ClientCommand = true;
	FireToSpeaker = true;
	--
	};
	
	
	-----------------------------------
	{
	Name = "bundle";
	Aliases	= {"package"};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Number"};
	Function = function(speaker, args)
		local plr = args[1]
		local humanoid = main:GetModule("cf"):GetHumanoid(plr)
		local bundleId = args[2]
		main:GetModule("MorphHandler"):ApplyBundle(humanoid, bundleId)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "dino";
	Aliases	= {"TRex", "dinosaur"};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		local humanoid = main:GetModule("cf"):GetHumanoid(plr)
		local bundleId = 458
		main:GetModule("MorphHandler"):ClearAccessories(plr)
		main:GetModule("MorphHandler"):ApplyBundle(humanoid, bundleId)
		local head = main:GetModule("cf"):GetHead(plr)
		if head then
			local sound = Instance.new("Sound")
			main.debris:AddItem(sound, 5)
			sound.SoundId = "rbxassetid://177090631"
			sound.Parent = head
			sound.Name = "DinoSound"
			sound.Volume = 1.5
			sound:Play()
		end
		wait(4)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "follow";
	Aliases	= {"join", "joinServer"};
	Prefixes = {settings.Prefix};
	Rank = 1;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "Teleports you to the specified player's server (if they are in the same game as you).";
	Contributors = {"ForeverHD"};
	--
	Args = {"UserId"};
	Function = function(speaker, args)
		local userId = args[1]
		local success, errorMessage, _, placeId, jobId = pcall(function() return game:GetService("TeleportService"):GetPlayerPlaceInstanceAsync(userId) end)
		if success and placeId and jobId then
			main.teleportService:TeleportToPlaceInstance(
			    placeId,
			    jobId,
			    speaker
			)
		else
			local playerName = main:GetModule("cf"):GetName(userId)
			main:GetModule("cf"):FormatAndFireError(speaker, "FollowFail", tostring(playerName))
		end
	end;
	--
	};
	
	
	-----------------------------------
	
	
	
	
	
	
	
	
	----------------------------------- (2) MOD COMMANDS -----------------------------------
	{
	Name = "h";
	Aliases	= {"hint"};
	Prefixes = {settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	SpecialColors = true;
	--
	Args = {"Text"};
	Function = function(speaker, args, self)
		--
		local hType = "Standard"
		local hDesc = speaker.Name..": "..args[1]
		local hDescColor = self.SpecialColor
		if not hDescColor then
			hDescColor = Color3.fromRGB(255,255,255)
		end
		--
		for i, plr in pairs(main.players:GetChildren()) do
			main.signals.Hint:FireClient(plr, {hType, hDesc, hDescColor})
		end
		wait(main:GetModule("cf"):GetMessageTime(hDesc))
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "fly";
	Aliases	= {"flight"};
	Prefixes = {settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Speed"};
	ClientCommandToActivate = true;
	--
	};
	
	
	-----------------------------------
	{
	Name = "fly2";
	Aliases	= {"flight2"};
	Prefixes = {settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Speed"};
	ClientCommandToActivate = true;
	--
	};
	
	
	-----------------------------------
	{
	Name = "noclip";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Speed"};
	ClientCommandToActivate = true;
	--
	};
	
	
	-----------------------------------
	{
	Name = "clip";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	ClientCommand = true;
	--
	};
	
	
	-----------------------------------
	{
	Name = "speed";
	Aliases	= {"ws", "walkSpeed"};
	Prefixes = {settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Number"};
	Function = function(speaker, args)
		local plr = args[1]
		local humanoid = main:GetModule("cf"):GetHumanoid(plr)
		if humanoid then
			humanoid.WalkSpeed = args[2]
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "jumpPower";
	Aliases	= {"jp"};
	Prefixes = {settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Number"};
	Function = function(speaker, args)
		local plr = args[1]
		local humanoid = main:GetModule("cf"):GetHumanoid(plr)
		if humanoid then
			humanoid.JumpPower = args[2]
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "health";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Number"};
	Function = function(speaker, args)
		local plr = args[1]
		local humanoid = main:GetModule("cf"):GetHumanoid(plr)
		if humanoid then
			local newHealth = args[2]
			if newHealth < 1 then
				newHealth = 1
			end
			humanoid.MaxHealth = newHealth
			humanoid.Health = newHealth
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "heal";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		local humanoid = main:GetModule("cf"):GetHumanoid(plr)
		if humanoid then
			humanoid.Health = humanoid.MaxHealth
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "god";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		local humanoid = main:GetModule("cf"):GetHumanoid(plr)
		if humanoid then
			humanoid.MaxHealth = math.huge
			humanoid.Health = humanoid.MaxHealth
		end
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		local humanoid = main:GetModule("cf"):GetHumanoid(plr)
		if humanoid then
			humanoid.MaxHealth = 100
			humanoid.Health = humanoid.MaxHealth
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "damage";
	Aliases	= {"dmg"};
	Prefixes = {settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Number"};
	Function = function(speaker, args)
		local plr = args[1]
		local humanoid = main:GetModule("cf"):GetHumanoid(plr)
		if humanoid then
			humanoid:TakeDamage(args[2])
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "kill";
	Aliases	= {"die", "commitNotAlive"};
	Prefixes = {settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = true;
	Tags = {"Abusive"};
	Description = "Kills the player.";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		local char = plr.Character
		if char then
			char:BreakJoints()
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "teleport";
	Aliases	= {"tp"};
	Prefixes = {settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	Teleport = true;
	--
	Args = {"Player", "Individual"};
	Function = function(speaker, args)
		local plrsToTeleport = args[1]
		local targetPlr = args[2]
		main:GetModule("cf"):TeleportPlayers(plrsToTeleport, targetPlr)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "bring";
	Aliases	= {"br"};
	Prefixes = {settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	Teleport = true;
	--
	Args = {"Player", "Individual"};
	Function = function(speaker, args)
		local plrsToTeleport = args[1]
		local targetPlr = args[2]
		main:GetModule("cf"):TeleportPlayers(plrsToTeleport, targetPlr)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "to";
	Aliases	= {"br"};
	Prefixes = {settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	Teleport = true;
	--
	Args = {"Player", "Individual"};
	Function = function(speaker, args)
		local plrsToTeleport = {speaker}
		local targetPlr = args[1][1]
		main:GetModule("cf"):TeleportPlayers(plrsToTeleport, targetPlr)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "apparate";
	Aliases	= {"ap", "skip"};
	Prefixes = {settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "Teleports the player x studs forward (8 default)";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Studs"};
	Function = function(speaker, args)
		local plr = args[1]
		local studs = -((args[2] ~= 0 and args[2]) or 8)
		print()
		print(args[2])
		print(studs)
		local head = main:GetModule("cf"):GetHead(plr)
		if head then
			head.CFrame = head.CFrame * CFrame.new(0,0,studs)
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "talk";
	Aliases	= {"say", "speak"};
	Prefixes = {settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Text"};
	Function = function(speaker, args)
		local plr = args[1]
		local text = args[2]
		local head = main:GetModule("cf"):GetHead(plr)
		if head and #text > 0 then
			main.chat:Chat(head, text, "White")
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "bubbleChat";
	Aliases	= {"bchat"};
	Prefixes = {settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	ClientCommandToActivate = true;
	--
	};
	
	
	-----------------------------------
	{
	Name = "control";
	Aliases	= {"hijak"};
	Prefixes = {settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		--check 1st person from list
		local plr = args[1]
		if speaker ~= plr then
			local speakerHead = main:GetModule("cf"):GetHead(speaker)
			local plrHead = main:GetModule("cf"):GetHead(plr)
			local itemName = "ControlPlr"
			if main.pd[speaker].Items[itemName] == nil and speakerHead then
				local originalCFrame = speakerHead.CFrame
				local item = Instance.new("ObjectValue")
				item.Name = speaker.Name.."'s "..itemName
				item.Value = plr
				main.pd[speaker].Items[itemName] = item
				item.Parent = workspace
				local clone = main:GetModule("cf"):CreateClone(speaker.Character)
				clone.Head.CFrame = originalCFrame
				clone.Name = "FakePlayer"
				clone.Parent = item
				clone.HumanoidRootPart.Anchored = true
				main:GetModule("Extensions"):SetupItem(speaker, itemName)
				--
				if plrHead then
					speakerHead.CFrame = plrHead.CFrame
				end
				main.signals.ActivateClientCommand:FireClient(speaker, {"bubbleChat"})
				--
			end
			local itemName = "UnderControl"
			if main.pd[plr].Items[itemName] == nil then
				local item = Instance.new("ObjectValue")
				item.Name = plr.Name.."'s "..itemName
				item.Value = speaker
				main.pd[plr].Items[itemName] = item
				main:GetModule("cf"):FormatAndFireNotice(plr, "UnderControl", speaker.Name)
				main:GetModule("Extensions"):SetupItem(plr, itemName)
			end
		end
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		local underControl = main.pd[plr].Items["UnderControl"]
		if underControl then
			local controller = underControl.Value
			if controller then
				main:GetModule("cf"):RemoveControlPlr(controller)
			end
			main:GetModule("cf"):RemoveUnderControl(plr)
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "handTo";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		if speaker.Character then
			local plr = args[1]
			local tool = speaker.Character:FindFirstChildOfClass("Tool")
			if tool ~= nil then
				tool:Clone().Parent = plr.Backpack
				speaker.Character.Humanoid:UnequipTools()
				tool:Destroy()
			end
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "give";
	Aliases	= {"tool"};
	Prefixes = {settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Tools"};
	Function = function(speaker, args)
		local plr = args[1]
		if plr.Character then
			local tools = args[2]
			for i,v in pairs(tools) do
				v:Clone().Parent = plr.Backpack
			end
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "sword";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		if plr.Character then
			main.server.Tools.Sword:Clone().Parent = plr.Backpack
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "gear";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Number"};
	Function = function(speaker, args)
		local plr = args[1]
		local gearId = args[2]
		local pdata = main.pd[plr]
		if main:GetModule("cf"):FindValue(main.settings.GearBlacklist, gearId) and pdata and pdata.Rank < main.settings.IgnoreGearBlacklist then
			main:GetModule("cf"):FormatAndFireError(speaker, "GearBlacklist", gearId)
			return
		end
		local success, model = pcall(function() return(main.insertService:LoadAsset(gearId)) end)
		if success then
			local tool = model:FindFirstChildOfClass("Tool")
			if tool then
				tool.Parent = plr.Backpack
			end
			model:Destroy()
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "explode";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		local hrp = main:GetModule("cf"):GetHRP(plr)
		if hrp then
			local explosion = Instance.new("Explosion")
			explosion.Position = hrp.Position
			explosion.Parent = plr.Character
			explosion.DestroyJointRadiusPercent = 0
			plr.Character:BreakJoints()
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "title";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	SpecialColors = true;
	--
	Args = {"Player", "Text"};
	Function = function(speaker, args, self)
		local plr = args[1]
		local color = self.SpecialColor
		if not color then
			color = Color3.fromRGB(255,255,255)
		end
		local text = args[2]
		local head = main:GetModule("cf"):GetHead(plr)
		if head then
			local titleName = "HDAdminTitle"
			local title = head:FindFirstChild(titleName)
			if not title then
				title = main.server.Assets.Title:Clone()
				title.Name = titleName
				title.Parent = head
			end
			title.TextLabel.Text = text
			title.TextLabel.TextColor3 = color
			local h,s,v = Color3.toHSV(color)
			title.TextLabel.TextStrokeColor3 = Color3.fromHSV(h, s, v*0.2)
		end
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		local head = main:GetModule("cf"):GetHead(plr)
		if head then
			local title = head:FindFirstChild("HDAdminTitle")
			if title then
				title:Destroy()
			end
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "fling";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 2;
	RankLock = false;
	Loopable = true;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local speakerHrp = main:GetModule("cf"):GetHRP(speaker)
		local plr = args[1]
		local plrHrp = main:GetModule("cf"):GetHRP(plr)
		local plrHumanoid = main:GetModule("cf"):GetHumanoid(plr)
		if speakerHrp and plrHrp and plrHumanoid then
			local flingDistance = 50--math.random(14,20)
			local speakerPos = speakerHrp.Position
			local plrPos = plrHrp.Position
			local bodyPosition = Instance.new("BodyPosition")
			bodyPosition.MaxForce = Vector3.new(10000000, 10000000, 10000000)
			bodyPosition.Name = "HDAdminFlingBP"
			bodyPosition.D = 450
			bodyPosition.P = 10000
			if plr == speaker then
				plrPos = (plrHrp.CFrame * CFrame.new(0,0,-4)).p
			end
			local direction = (plrPos - speakerPos).Unit
			bodyPosition.Position = plrPos + Vector3.new(direction.X, 1.4, direction.Z) * flingDistance
			--
			local spin = Instance.new("BodyAngularVelocity")
			spin.MaxTorque = Vector3.new(300000, 300000, 300000)
			spin.P = 300
			spin.AngularVelocity = Vector3.new(10, 10 ,10)
			spin.Name = "HDAdminFlingSpin"
			spin.Parent = plrHrp
			main.debris:AddItem(spin, 0.1)
			--
			plrHumanoid.JumpPower = 0
			bodyPosition.Parent = plrHrp
			main.debris:AddItem(bodyPosition, 0.1)
			for i = 1,30 do
				plrHumanoid.Sit = true
				wait(0.1)
			end
			wait(1)
		end
	end;
	--
	};
	
	
	-----------------------------------
	
	
	
	
	
	
	
	
	
	
	
	----------------------------------- (3) ADMIN COMMANDS -----------------------------------
	{
	Name = "m";
	Aliases	= {"message"};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	SpecialColors = true;
	--
	Args = {"Text"};
	Function = function(speaker, args, self)
		--
		local mType = "Standard"
		local mTitle = "Message from "..speaker.Name
		local mSubTitle = main:GetModule("cf"):GetRankName(main.pd[speaker].Rank)
		local mDesc = args[1]
		local mDescColor = self.SpecialColor
		if not mDescColor then
			mDescColor = Color3.fromRGB(255,255,255)
		end
		--
		for i, plr in pairs(main.players:GetChildren()) do
			main.signals.Message:FireClient(plr, {speaker, mType, mTitle, mSubTitle, mDesc, mDescColor})
		end
		wait(main:GetModule("cf"):GetMessageTime(mDesc))
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "serverMessage";
	Aliases	= {"sm", "smessage"};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Text"};
	Function = function(speaker, args)
		--
		local mType = "Server"
		local mTitle = "Server Message"
		local mSubTitle = main:GetModule("cf"):GetRankName(main.pd[speaker].Rank)
		local mDesc = args[1]
		local mDescColor = Color3.fromRGB(255,255,255)
		--
		for i, plr in pairs(main.players:GetChildren()) do
			main.signals.Message:FireClient(plr, {speaker, mType, mTitle, mSubTitle, mDesc, mDescColor})
		end
		wait(main:GetModule("cf"):GetMessageTime(mDesc))
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "serverHint";
	Aliases	= {"sh", "shint"};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--f"
	Args = {"Text"};
	Function = function(speaker, args)
		--
		local hType = "Server"
		local hDesc = "Server: "..args[1]
		local hDescColor = Color3.fromRGB(255,255,255)
		--
		for i, plr in pairs(main.players:GetChildren()) do
			main.signals.Hint:FireClient(plr, {hType, hDesc, hDescColor})
		end
		wait(main:GetModule("cf"):GetMessageTime(hDesc))
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "countdown";
	Aliases	= {"countdown1"};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Number"};
	Function = function(speaker, args)
		--
		local hType = "Countdown"
		local hDesc = args[1]
		local hDescColor = Color3.fromRGB(255,255,255)
		--
		if hDesc == 0 then
			hDesc = 10
		elseif hDesc < 1 then
			hDesc = 1
		end
		for i, plr in pairs(main.players:GetChildren()) do
			main.signals.Hint:FireClient(plr, {hType, hDesc, hDescColor})
		end
		wait(hDesc+1)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "countdown2";
	Aliases	= {"countdownM"};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Number"};
	Function = function(speaker, args)
		--
		local mType = "Countdown"
		local mDesc = args[1]
		local mDescColor = Color3.fromRGB(255,255,255)
		--
		if mDesc == 0 then
			mDesc = 10
		elseif mDesc < 1 then
			mDesc = 1
		end
		for i, plr in pairs(main.players:GetChildren()) do
			main.signals.Message:FireClient(plr, {nil, mType, nil, mType, mDesc, mDescColor})
		end
		wait(mDesc+1)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "notice";
	Aliases	= {"n"};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Text"};
	Function = function(speaker, args)
		local plr = args[1]
		local text = args[2]
		main.signals.Notice:FireClient(plr, {"Notice", text})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "privateMessage";
	Aliases	= {"pm"};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Text"};
	Function = function(speaker, args)
		local plr = args[1]
		local message = args[2]
		main:GetModule("cf"):PrivateMessage(speaker, plr, message)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "alert";
	Aliases	= {"warn"};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Text"};
	Function = function(speaker, args)
		local plr = args[1]
		local message = args[2]
		main.signals.CreateAlert:FireClient(plr, {"Alert from "..speaker.Name, message})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "tempRank";
	Aliases	= {"tRank"};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = true;
	Loopable = false;
	Tags = {"Ranks"};
	Description = "Ranks a player (until player leaves)";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Rank"};
	Function = function(speaker, args)
		return(main:GetModule("cf"):RankPlayerCommand(speaker, args, "Temp"))
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "rank";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = true;
	Loopable = false;
	Tags = {"Ranks"};
	Description = "Ranks a player (for the given server)";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Rank"};
	Function = function(speaker, args)
		return(main:GetModule("cf"):RankPlayerCommand(speaker, args, "Server"))
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "unRank";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = true;
	Loopable = false;
	Tags = {"Ranks"};
	Description = "Sets the players rank to 0 (NonAdmin)";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		return(main:GetModule("cf"):Unrank(plr))
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "music";
	Aliases	= {"sound", "audio"};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Number"};
	Function = function(speaker, args)
		local soundId = args[1]
		local soundName = "HDAdminSound"
		local sound = workspace:FindFirstChild(soundName)
		if not sound then
			sound = Instance.new("Sound")
			sound.Looped = true
			sound.Name = soundName
			sound.Parent = workspace
		else
			sound:Stop()
		end
		sound.Volume = 0.5
		sound.Pitch = 1
		local info = main:GetModule("cf"):GetProductInfo(soundId)
		if info.Created ~= "null" and info.AssetTypeId == 3 then
			sound.SoundId = "rbxassetid://"..soundId
			sound:Play()
			main.signals.Hint:FireAllClients{"Standard", "Now playing '"..info.Name.."' ("..soundId..")", Color3.fromRGB(255,255,255)}
			return
		else
			main.signals.Hint:FireClient(speaker, {"Standard", "Invalid SoundId", Color3.fromRGB(255,255,255)})
		end
	end;
	UnFunction = function(speaker, args)
		local sound = workspace:FindFirstChild("HDAdminSound")
		if sound then
			sound:Stop()
		end
	end
	--
	};
	
	
	-----------------------------------
	{
	Name = "pitch";
	Aliases	= {"playbackSpeed"};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Number"};
	Function = function(speaker, args)
		local number = args[1]
		local sound = workspace:FindFirstChild("HDAdminSound")
		if sound then
			sound.Pitch = number
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "volume";
	Aliases	= {"loudness"};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Number"};
	Function = function(speaker, args)
		local number = args[1]
		local sound = workspace:FindFirstChild("HDAdminSound")
		if sound then
			sound.Volume = number
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "buildingTools";
	Aliases	= {"btools"};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"GigsD4X"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		if plr.Character then
			for i,v in pairs(main.server.Assets.BuildingTools:GetChildren()) do
				v:Clone().Parent = plr.Backpack
			end
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "chatColor";
	Aliases	= {"chatc"};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Color"};
	Function = function(speaker, args)
		local plr = args[1]
		local color = args[2]
		main.chatService:GetSpeaker(plr.Name):SetExtraData("ChatColor", color)
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		local color = Color3.fromRGB(255,255,255)
		main.chatService:GetSpeaker(plr.Name):SetExtraData("ChatColor", color)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "sellGamepass";
	Aliases	= {"sell", "prompt"};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Number"};
	Function = function(speaker, args)
		local plr = args[1]
		local id = args[2]
		if id > 0 then
			pcall(function() main.marketplaceService:PromptGamePassPurchase(plr, id) end)
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "sellAsset";
	Aliases	= {"sell2", "prompt2"};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Number"};
	Function = function(speaker, args)
		local plr = args[1]
		local id = args[2]
		if id > 0 then
			pcall(function() main.marketplaceService:PromptPurchase(plr, id) end)
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "team";
	Aliases	= {"joinTeam"};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "TeamColor"};
	Function = function(speaker, args)
		local plr = args[1]
		local teamColor = args[2]
		if teamColor then
			plr.TeamColor = teamColor
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "change";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Stat", "String"};
	Function = function(speaker, args)
		local plr = args[1]
		local statName = args[2]
		local value = args[3]
		local stat = main:GetModule("cf"):GetStat(plr, statName)
		if stat then
			if stat:IsA("IntValue") or stat:IsA("NumberValue") then
				if tonumber(value) then
					stat.Value = value
				end
			else
				stat.Value = value
			end
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "add";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Stat", "Value"};
	Function = function(speaker, args)
		local plr = args[1]
		local statName = args[2]
		local value = args[3]
		local stat = main:GetModule("cf"):GetStat(plr, statName)
		if stat then
			if stat:IsA("IntValue") or stat:IsA("NumberValue") and tonumber(value) then
				stat.Value = stat.Value + value
			end
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "subtract";
	Aliases	= {"sub"};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Stat", "Value"};
	Function = function(speaker, args)
		local plr = args[1]
		local statName = args[2]
		local value = args[3]
		local stat = main:GetModule("cf"):GetStat(plr, statName)
		if stat then
			if stat:IsA("IntValue") or stat:IsA("NumberValue") and tonumber(value) then
				stat.Value = stat.Value - value
			end
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "resetStats";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		local leaderstats = plr:FindFirstChild("leaderstats")
		if leaderstats then
			for _,stat in pairs(leaderstats:GetChildren()) do
				if stat:IsA("IntValue") or stat:IsA("NumberValue") then
					stat.Value = 0
				elseif stat:IsA("BoolValue") then
					stat.Value = false
				end
			end
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "time";
	Aliases	= {"clockTime","ct","timeOfDay", "tod"};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Number"};
	Function = function(speaker, args)
		local number = args[1]
		main.lighting.ClockTime = number
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "mute";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		main.signals.SetCoreGuiEnabled:FireClient(plr,{"Chat", false})
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		main.signals.SetCoreGuiEnabled:FireClient(plr,{"Chat", true})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "kick";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = true;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Text"};
	Function = function(speaker, args)
		local plr = args[1]
		local reason = args[2]
		local kickMessage = "by ".. speaker.Name.."\n\nReason: '"..reason.."'\n"
		if #reason < 1 then
			kickMessage = "By: ".. speaker.Name
		end
		plr:Kick(kickMessage)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "place";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Number"};
	Function = function(speaker, args)
		local plr = args[1]
		local placeId = args[2]
		local placeInfo = main:GetModule("cf"):GetProductInfo(placeId)
		local placeName = placeInfo.Name
		if placeName then
			main:GetModule("cf"):FormatAndFireNotice2(plr, "ClickToTeleport", {"Teleport", placeId}, placeName, placeId)
		else
			--main.signals.Error:FireClient(speaker, {"HD Admin", placeId.." is an invalid placeId!"})
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "punish";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		if plr and plr.Character then
			plr.Character.Parent = nil
		end
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		if plr and plr.Character then
			plr.Character.Parent = workspace
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "disco";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	EndDisco = main.client.Signals.EndDisco;
	--
	Args = {};
	Function = function(speaker, args, self)
		local propertiesToChange = {"Ambient", "OutdoorAmbient", "FogColor"}
		local originalAmbients = {}
		local running = true
		local tween
		local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear)
		local targetHues = {3/3, 2/3, 1/3}
		for i,v in pairs(propertiesToChange) do
			originalAmbients[v] = main.lighting[v]
		end
		coroutine.wrap(function()
			while running do
				for i = 1, #targetHues do
					if not running then
						break
					end
					local targetValue = targetHues[i]
					local newPropValues = {}
					for i,v in pairs(propertiesToChange) do
						newPropValues[v] = Color3.fromHSV(targetValue, 1, 1)
					end
					tween = main.tweenService:Create(main.lighting, tweenInfo, newPropValues)
					tween:Play()
					tween.Completed:Wait()
				end
			end
		end)()
		self.EndDisco.Event:Wait()
		running = false
		tween:Cancel()
		for propName, originalValue in pairs(originalAmbients) do
			main.lighting[propName] = originalValue
		end
	end;
	UnFunction = function(speaker, args, self)
		self.EndDisco:Fire()
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "fogEnd";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Number"};
	Function = function(speaker, args)
		main.tweenService:Create(main.lighting, TweenInfo.new(2), {FogEnd = args[1]}):Play()
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "fogStart";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Number"};
	Function = function(speaker, args)
		main.tweenService:Create(main.lighting, TweenInfo.new(2), {FogStart = args[1]}):Play()
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "fogColor";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Color"};
	Function = function(speaker, args)
		main.tweenService:Create(main.lighting, TweenInfo.new(2), {FogColor = args[1]}):Play()
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "vote";
	Aliases	= {"poll"};
	Prefixes = {settings.Prefix};
	Rank = 3;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "Displays the poll menu.";
	Contributors = {"ForeverHD"};
	--
	Args = {"PlayerArg", "Answers", "Question"};
	Function = function(speaker, args)
		local plrArg = args[1]
		local answers = args[2]
		local question = args[3]
		main.signals.CreatePollMenu:FireClient(speaker, {targetPlayer = plrArg, server = "Current", answers = answers, question = question})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "lockPlayer";
	Aliases	= {"lockPlr", "lockp", "lock"};
	Prefixes = {settings.Prefix};
	Rank = 4;
	RankLock = false;
	Loopable = false;
	Tags = {""};
	Description = "Locks all parts with the specified player.";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		local char = plr and plr.Character
		if char then
			for a,b in pairs(char:GetDescendants()) do
				if b:IsA("BasePart") then
					b.Locked = true
				end
			end
		end
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		local char = plr and plr.Character
		if char then
			for a,b in pairs(char:GetDescendants()) do
				if b:IsA("BasePart") then
					b.Locked = false
				end
			end
		end
	end;
	--
	};
	
	
	-----------------------------------
	
	
	
	
	
	
	
	
	
	
	----------------------------------- (4) HEADADMIN COMMANDS -----------------------------------
	{
	Name = "lockMap";
	Aliases	= {"lockM"};
	Prefixes = {settings.Prefix};
	Rank = 4;
	RankLock = false;
	Loopable = false;
	Tags = {""};
	Description = "Locks all parts in workspace, preventing players from selecting and editing parts.";
	Contributors = {"ForeverHD"};
	--
	Args = {};
	Function = function(speaker, args)
		for a,b in pairs(workspace:GetDescendants()) do
			if b:IsA("BasePart") then
				b.Locked = true
			end
		end
	end;
	UnFunction = function(speaker, args)
		for a,b in pairs(workspace:GetDescendants()) do
			if b:IsA("BasePart") then
				b.Locked = false
			end
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "saveMap";
	Aliases	= {"backupMap"};
	Prefixes = {settings.Prefix};
	Rank = 4;
	RankLock = false;
	Loopable = false;
	Tags = {""};
	Description = "Saves a copy of the map which can be restored using the ;loadMap command";
	Contributors = {"ForeverHD"};
	--
	Args = {};
	Function = function(speaker, args)
		main:GetModule("cf"):SaveMap(speaker)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "loadMap";
	Aliases	= {"restoreMap"};
	Prefixes = {settings.Prefix};
	Rank = 4;
	RankLock = false;
	Loopable = false;
	Tags = {""};
	Description = "Restores the last saved copy of the map. Use ;saveMap to backup a copy of the map. A default copy is saved at the start of the game.";
	Contributors = {"ForeverHD"};
	--
	Args = {};
	Function = function(speaker, args)
		local mapBackup = main.ss:FindFirstChild("HDAdminMapBackup")
		if mapBackup then
			main.signals.Hint:FireAllClients{"Standard", "Restoring map...", Color3.fromRGB(255,255,255)}
			for a,b in pairs(workspace:GetChildren()) do
				if not b:IsA("Terrain") and b.Archivable then
					b:Destroy()
				end
			end
			local terrainBackup = main.mapBackupTerrain
			if terrainBackup then
				local terrain = workspace:FindFirstChildOfClass("Terrain")
				terrain:Clear()
				terrain:PasteRegion(terrainBackup, terrain.MaxExtents.Min, true)
			end
			local mapBackupClone = mapBackup:Clone()
			mapBackupClone.Parent = workspace
			for a,b in pairs(mapBackupClone:GetChildren()) do
				b.Parent = workspace
			end
			mapBackupClone:Destroy()
			main.signals.Hint:FireAllClients{"Standard", "Map successfully restored!", Color3.fromRGB(255,255,255)}
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "createTeam";
	Aliases	= {"cTeam"};
	Prefixes = {settings.Prefix};
	Rank = 4;
	RankLock = false;
	Loopable = false;
	Tags = {""};
	Description = "Creates a new team";
	Contributors = {"ForeverHD"};
	--
	Args = {"Color", "TeamName"};
	Function = function(speaker, args)
		local team = Instance.new("Team")
		team.TeamColor = BrickColor.new(args[1])
		team.Name = args[2]
		team.Parent = main.teams
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "removeTeam";
	Aliases	= {"rTeam"};
	Prefixes = {settings.Prefix};
	Rank = 4;
	RankLock = false;
	Loopable = false;
	Tags = {""};
	Description = "Removes an existing team";
	Contributors = {"ForeverHD"};
	--
	Args = {"Team"};
	Function = function(speaker, args)
		local team = args[1]
		if team then
			team:Destroy()
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "permRank";
	Aliases	= {"pRank"};
	Prefixes = {settings.Prefix};
	Rank = 4;
	RankLock = true;
	Loopable = false;
	Tags = {"Ranks"};
	Description = "Ranks a player (permanently across all servers)";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Rank"};
	Function = function(speaker, args)
		return(main:GetModule("cf"):RankPlayerCommand(speaker, args, "Perm"))
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "crash";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 4;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		local crash = main.server.Assets.Crash:Clone()
		crash.Parent = plr.PlayerGui
		crash.Disabled = false
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "forcePlace";
	Aliases	= {"fplace"};
	Prefixes = {settings.Prefix};
	Rank = 4;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Number"};
	Function = function(speaker, args)
		local plr = args[1]
		local placeId = args[2]
		local placeInfo = main:GetModule("cf"):GetProductInfo(placeId)
		local placeName = placeInfo.Name
		if placeName then
			main.teleportService:Teleport(args[2], plr)
		else
			--main.signals.Error:FireClient(speaker, {"HD Admin", placeId.." is an invalid placeId!"})
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "shutdown";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 4;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {};
	Function = function(speaker, args)
		local kickMessage = "The server has been shutdown by "..speaker.Name
		for i, plr in pairs(main.players:GetChildren()) do
			main.signals.Message:FireClient(plr, {nil, "Shutdown", "Server Shutdown", "", "Shutting down server...", Color3.fromRGB(255,255,255)})
		end
		wait(3)
		for i, plr in pairs(main.players:GetChildren()) do
			plr:Kick(kickMessage)
		end
		main.players.PlayerAdded:Connect(function(plr)
			plr:Kick(kickMessage)
		end)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "serverLock";
	Aliases	= {"slock"};
	Prefixes = {settings.Prefix};
	Rank = 4;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "Locks the server for players lower than the given rank";
	Contributors = {"ForeverHD"};
	--
	Args = {"Rank"};
	Function = function(speaker, args)
		local rank = args[1]
		if rank < 1 or rank > 5 then
			rank = 4
		end
		main.ranksAllowedToJoin = rank
		for i, plr in pairs(main.players:GetChildren()) do
			main.signals.Hint:FireClient(plr, {"Standard", "The server has been locked for ranks below '".. main:GetModule("cf"):GetRankName(rank).."'", Color3.fromRGB(255,255,255)})
		end
	end;
	UnFunction = function(speaker, args)
		main.ranksAllowedToJoin = 0
		for i, plr in pairs(main.players:GetChildren()) do
			main.signals.Hint:FireClient(plr, {"Standard", "The server has been unlocked", Color3.fromRGB(255,255,255)})
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "ban";
	Aliases	= {};
	Prefixes = {settings.Prefix};
	Rank = 4;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "Displays the ban menu.";
	Contributors = {"ForeverHD"};
	--
	Args = {"PlayerArg", "Reason"};
	Function = function(speaker, args)
		local plrArg = args[1]
		main.signals.CreateBanMenu:FireClient(speaker, {targetPlayer = plrArg, server = "Current", length = "Infinite", reason = args[2]})
	end;
	UnFunction = function(speaker, args)
		local plrArg = args[1]
		local banDetails = main:GetModule("cf"):GetBannedUserDetails(plrArg)
		main.signals.ShowBannedUser:FireClient(speaker, banDetails)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "directBan";
	Aliases	= {"dBan"};
	Prefixes = {settings.Prefix};
	Rank = 4;
	RankLock = true;
	Loopable = false;
	Tags = {};
	Description = "Directly bans a player, instead of displaying the ban menu.";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Reason", "Details"};
	Function = function(speaker, args, self, details)
		local plr = args[1]
		local speakerData = main.pd[speaker]
		local userId = plr.UserId
		local reason = args[2]
		--
		if not details then
			details = {}
		end
		local server = details.server
		local length = details.length
		local lengthTime = details.lengthTime
		if server == nil then
			server = "Current"
		end
		if length == nil then
			length = "Infinite"
		end
		if lengthTime == nil then
			lengthTime = "0m1h0d"
		end
		--
		local totalTimeInSeconds = 0
		lengthTime:gsub("%d+%a", function(c)
			local d = tonumber(c:match("%d+"))
			if d then
				local timeType = c:match("%a")
				local amount = main:GetModule("cf"):GetTimeAmount(timeType, d)
				totalTimeInSeconds = totalTimeInSeconds + amount
			end
			return
		end)
		local errorStart = "Failed to ban "..plr.Name..": "
		if totalTimeInSeconds < 1 and length ~= "Infinite" then
			main:GetModule("cf"):FormatAndFireError(speaker, "BanFailLength", errorStart)
		elseif server ~= "Current" and game.VIPServerOwnerId ~= 0 and (main.blacklistedVipServerCommands["permban"] or main.blacklistedVipServerCommands["pban"]) then 
			main:GetModule("cf"):FormatAndFireError(speaker, "BanFailVIPServer", errorStart)
		elseif server ~= "Current" and speakerData and speakerData.Rank < main.commandRanks.permban then
			main:GetModule("cf"):FormatAndFireError(speaker, "BanFailAllServers")
		else
			local banTime = "Infinite"
			if length == "Time" then
				banTime = os.time() + totalTimeInSeconds
			end
			local record = {
				UserId = userId;
				BanTime = banTime;
				Reason = reason;
				Server = server;
				BannedBy = speaker.UserId;
			}
			if main:GetModule("cf"):FindUserIdInRecord(main.serverBans, userId) or main:GetModule("cf"):FindUserIdInRecord(main.sd.Banland.Records, userId) then
				main:GetModule("cf"):FormatAndFireError(speaker, "BanFailAlreadyBanned", errorStart)
			else
				if server == "Current" then
					table.insert(main.serverBans, record)
				else
					main:GetModule("SystemData"):InsertStat("Banland", "RecordsToAdd", record)
					main:GetModule("SystemData"):InsertStat("Banland", "Records", record)
				end
				main:GetModule("cf"):FormatAndFireNotice(speaker, "BanSuccess", plr.Name)
				main:GetModule("cf"):BanPlayer(plr, record)
			end
		end
	end;
	UnFunction = function(speaker, args)
		local plrArg = args[1]
		local banDetails, record = main:GetModule("cf"):GetBannedUserDetails(plrArg)
		--targetName, targetId, targetReason, record
		if banDetails then
			record.BanTime = os.time()
			if record.Server ~= "Current" then
				main:GetModule("SystemData"):InsertStat("Banland", "RecordsToModify", record)
			end
			main:GetModule("cf"):FormatAndFireNotice(speaker, "UnBanSuccess", banDetails[1])
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "permBan";
	Aliases	= {"pBan"};
	Prefixes = {settings.Prefix};
	Rank = 5;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "Displays the ban menu.";
	Contributors = {"ForeverHD"};
	--
	Args = {"PlayerArg", "Reason"};
	Function = function(speaker, args)
		local plrArg = args[1]
		main.signals.CreateBanMenu:FireClient(speaker, {targetPlayer = plrArg, server = "All", length = "Infinite", reason = args[2]})
	end;
	UnFunction = function(speaker, args)
		local plrArg = args[1]
		local banDetails = main:GetModule("cf"):GetBannedUserDetails(plrArg)
		main.signals.ShowBannedUser:FireClient(speaker, banDetails)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "timeBan";
	Aliases	= {"tBan"};
	Prefixes = {settings.Prefix};
	Rank = 4;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "Displays the ban menu.";
	Contributors = {"ForeverHD"};
	--
	Args = {"PlayerArg", "?m?h?d", "Reason"};
	Function = function(speaker, args)
		local plrArg = args[1]
		main.signals.CreateBanMenu:FireClient(speaker, {targetPlayer = plrArg, server = "All", length = "Time", timeDetails = args[2], reason = args[3]})
	end;
	UnFunction = function(speaker, args)
		local plrArg = args[1]
		local banDetails = main:GetModule("cf"):GetBannedUserDetails(plrArg)
		main.signals.ShowBannedUser:FireClient(speaker, banDetails)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "globalAnnouncement";
	Aliases	= {"ga","broadcast"};
	Prefixes = {settings.Prefix, settings.UniversalPrefix};
	Rank = 4;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "Broadcasts a message to all servers.";
	Contributors = {"ForeverHD"};
	--
	Args = {};
	Function = function(speaker, args)
		main.signals.CreateCommandMenu:FireClient(speaker, {"broadcast", {}, 7})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "globalVote";
	Aliases	= {"gv", "gVote", "globalPoll", "gPoll", "gp"};
	Prefixes = {settings.Prefix, settings.UniversalPrefix};
	Rank = 4;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "Displays the poll menu.";
	Contributors = {"ForeverHD"};
	--
	Args = {"PlayerArg", "Answers", "Question"};
	Function = function(speaker, args)
		local plrArg = args[1]
		local answers = args[2]
		local question = args[3]
		main.signals.CreatePollMenu:FireClient(speaker, {targetPlayer = plrArg, server = "All", answers = answers, question = question})
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "globalAlert";
	Aliases	= {"gat", "gAlert"};
	Prefixes = {settings.Prefix, settings.UniversalPrefix};
	Rank = 4;
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "Displays the alert menu.";
	Contributors = {"ForeverHD"};
	--
	Args = {"Text"};
	Function = function(speaker, args)
		local message = args[1]
		main.signals.CreateMenu:FireClient(speaker, {MenuName = "alertMenu", Data = {targetPlayer = "all", server = "All", message = message}, TemplateId = 12})
	end;
	--
	};
	
	
	-----------------------------------
	

	
	
	
	
	
	
	
	
	
	
	----------------------------------- DONOR COMMANDS -----------------------------------
	{
	Name = "laserEyes";
	Aliases	= {"le", "lazerEyes"};
	Prefixes = {settings.UniversalPrefix};
	Rank = "Donor";
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Color"};
	ClientCommandToActivate = true;
	PreFunction = function(speaker, args)
		local plr = args[1]
		local pdata = main.pd[plr]
		local head = main:GetModule("cf"):GetHead(plr)
		if head and pdata then
			local color = args[2]
			if color then
				main:GetModule("PlayerData"):ChangeStat(plr, "LaserColor", color)
			end
			local laserHead = head:FindFirstChild("HDAdminLaserHead")
			if laserHead then
				laserHead:Destroy()
			end
			laserHead = main.server.Assets.LaserHead:Clone()
			laserHead.Name = "HDAdminLaserHead"
			laserHead.CFrame = head.CFrame * CFrame.new(0,0,-0.1)
			laserHead.WeldConstraint.Part1 = head
			laserHead.Parent = head
			for a,b in pairs(laserHead.LaserTarget:GetDescendants()) do
				if b:IsA("Beam") then
					b.Color = ColorSequence.new(pdata.LaserColor)
				end
			end
			--
			local face = head:FindFirstChildOfClass("Decal")
			if face then
				main.tweenService:Create(face, TweenInfo.new(1), {Transparency = 1}):Play()
			end
			local tweenTime = 0.8
			main.tweenService:Create(laserHead.LeftEye, TweenInfo.new(tweenTime), {Transparency = 0}):Play()
			main.tweenService:Create(laserHead.RightEye, TweenInfo.new(tweenTime), {Transparency = 0}):Play()
		end
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		local head = main:GetModule("cf"):GetHead(plr)
		if head then
			local laserHead = head:FindFirstChild("HDAdminLaserHead")
			if laserHead then
				laserHead:Destroy()
			end
			local face = head:FindFirstChildOfClass("Decal")
			if face then
				face.Transparency = 0
			end
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "thanos";
	Aliases	= {};
	Prefixes = {settings.UniversalPrefix};
	Rank = "Donor";
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local plr = args[1]
		main:GetModule("MorphHandler"):ChangeAllBodyColors(plr, Color3.fromRGB(167, 94, 155))
		main:GetModule("MorphHandler"):ChangeProperty(plr, "Face", 173789324)--1442002588)
		main:GetModule("MorphHandler"):ChangeProperty(plr, "Shirt", 1729864201)
		main:GetModule("MorphHandler"):ChangeProperty(plr, "Pants", 1539857193)
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "headSnap";
	Aliases	= {"hs"};
	Prefixes = {settings.UniversalPrefix};
	Rank = "Donor";
	RankLock = false;
	Loopable = false;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player", "Degrees"};
	Function = function(speaker, args)
		local plr = args[1]
		local degrees = args[2]
		local head = main:GetModule("cf"):GetHead(plr)
		local humanoid = main:GetModule("cf"):GetHumanoid(plr)
		if head and humanoid then
			local neck = main:GetModule("cf"):GetNeck(plr)
			if neck then
				if humanoid.RigType == Enum.HumanoidRigType.R6 then
					neck.C0 = CFrame.new(neck.Transform.p) * CFrame.new(0,1,0) * CFrame.fromEulerAnglesXYZ(math.rad(90),math.rad(180),math.rad(degrees))
				else
					neck.C0 = CFrame.new(neck.Transform.p) * CFrame.new(0,humanoid.HipHeight/1.7,0) * CFrame.fromEulerAnglesXYZ(0, math.rad(degrees), 0)
				end
			end
		end
	end;
	UnFunction = function(speaker, args)
		local plr = args[1]
		local head = main:GetModule("cf"):GetHead(plr)
		local humanoid = main:GetModule("cf"):GetHumanoid(plr)
		if head and humanoid then
			local neck = main:GetModule("cf"):GetNeck(plr)
			if neck then
				if humanoid.RigType == Enum.HumanoidRigType.R6 then
					neck.C0 = CFrame.new(neck.Transform.p) * CFrame.new(0,1,0) * CFrame.fromEulerAnglesXYZ(math.rad(90),math.rad(180),0)
				else
					neck.C0 = CFrame.new(neck.Transform.p) * CFrame.new(0,humanoid.HipHeight/1.7,0)
				end
			end
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "fart";
	Aliases	= {};
	Prefixes = {settings.UniversalPrefix};
	Rank = "Donor";
	RankLock = false;
	Loopable = true;
	Tags = {};
	Description = "";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	Function = function(speaker, args)
		local farts = {154967038, 2663775994, 131314452, 340261128}
		local fartVolumes = {0.5, 0.5, 0.2, 0.3}
		local fartTimes = {0.5, 0.7, 1, 2}
		local plr = args[1]
		local hrp = main:GetModule("cf"):GetHRP(plr)
		if hrp then
			local fart = main.server.Assets.FartHolder.FartAttachment:Clone()
			local fartId = math.random(1, #farts)
			fart.Parent = hrp
			fart.Sound.SoundId = "rbxassetid://"..farts[fartId]
			fart.Sound.Volume = fartVolumes[fartId]
			fart.Sound:Play()
			fart.ParticleEmitter.Enabled = true
			wait(fartTimes[fartId])
			fart.ParticleEmitter.Enabled = false
			main.debris:AddItem(fart, 5)
		end
	end;
	--
	};
	
	
	-----------------------------------
	{
	Name = "boing";
	Aliases	= {};
	Prefixes = {settings.UniversalPrefix};
	Rank = "Donor";
	RankLock = false;
	Loopable = true;
	Tags = {""};
	Description = "Who does't love a good bit of yoga?";
	Contributors = {"ForeverHD"};
	--
	Args = {"Player"};
	ClientCommand = true;
	FireAllClients = true;
	Function = function(speaker, args)
		wait(2)
	end;
	--
	};
	
	
	-----------------------------------
	
		
};






return module
