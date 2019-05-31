-- << RETRIEVE FRAMEWORK >>
local main = require(game:GetService("ReplicatedStorage"):WaitForChild("HDAdminSetup")):GetMain(true)
main:Initialize("Client")
local modules = main.modules



-- << SETUP >>
modules.PageAbout:UpdateProfileIcon()
modules.PageAbout:CreateUpdates()
modules.PageAbout:UpdateContributors()
modules.PageAbout:CreateCredits()
modules.PageCommands:CreateCommands()
modules.PageCommands:CreateMorphs()
modules.PageCommands:CreateDetails()
modules.PageSpecial:SetupDonorCommands()
modules.PageAdmin:SetupRanks()
modules.GUIs:DisplayPagesAccordingToRank()



-- << LOAD ASSETS >>
local assetsToLoad = {main.gui}
main.contentProvider:PreloadAsync(assetsToLoad)
