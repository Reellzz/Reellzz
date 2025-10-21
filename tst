local LocalPlayer = game.Players.LocalPlayer
local Fsys = require(game.ReplicatedStorage:FindFirstChild("Fsys")).load
local ClientData = Fsys("ClientData")
local get = Fsys("RouterClient").get

local Webhook = "https://discord.com/api/webhooks/1427702943494439056/ft7-u-i5yxwlgJNdUVVqc5tB72WtGx1y02xlSGs0NgHZpuuTBQ-kr-q0eSLALDoiALyl"

local MainPart = Instance.new("Part", workspace)
local ParkPart = Instance.new("Part", workspace)
local BeachPart = Instance.new("Part", workspace)

local Tutorial = require(game:GetService("ReplicatedStorage").ClientModules.Game.Tutorial.LegacyTutorial)
local License = require(game:GetService("ReplicatedStorage").SharedModules.TradeLicenseHelper)

local HMC = require(game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2025.Minigames.HauntletMinigameClient)
local FFM = require(game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2025.Minigames.FashionFrenzyMinigameClient)
local TDC = require(game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2025.Minigames.TreatDashClient)

pcall(function()
	repeat wait()
	until not LocalPlayer.PlayerGui.AssetLoadUI.Enabled
end)

MainPart.Size = Vector3.new(500, 0, 500)
MainPart.Anchored = true
MainPart.CFrame = CFrame.new(500, 500, 500)

ParkPart.Size = Vector3.new(500, 0, 500)
ParkPart.Anchored = true
ParkPart.CFrame = workspace.StaticMap.TeleportLocations.Park.CFrame + Vector3.new(0, -6, 0)

BeachPart.Size = Vector3.new(500, 0, 500)
BeachPart.Anchored = true
BeachPart.CFrame = workspace.StaticMap.TeleportLocations.exterior_beach.CFrame + Vector3.new(0, -5, 0)

function SendWebhook(webhookUrl,Title, v)
	(http_request){
		Url = webhookUrl,
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json",
		},
		Body = game:GetService("HttpService"):JSONEncode({
			content = "",
			embeds = {{
				title = "**"..Title.."**",
				color = tonumber(0xffffff),
				fields = {{name = "",value = v}}
			}}
		})
	}
end

function ButtonClick(Path)
	firesignal(Path["MouseButton1Down"])
	firesignal(Path["MouseButton1Click"])
end

function CurrentLocation(Name)
	Name = ClientData.get_data()[LocalPlayer.Name]["char_wrapper"]["location"]["destination_id"]
	return Name
end

function get_room()
	return HMC.instanced_minigame.round
end

function SetLocation(A, B, C)
	local O = getthreadidentity()
	setthreadidentity(2)
	Location(A, B, C)
	setthreadidentity(O)
end

function FashionAccs(Accessory)
	get("MinigameAPI/MessageServer"):FireServer(FFM.instanced_minigame.minigame_id, "try_pick_up_accessory", Accessory)
	get("MinigameAPI/MessageServer"):FireServer(FFM.instanced_minigame.minigame_id, "try_equip_accessory", Accessory)
end

for i, v in pairs(getgc()) do
	if type(v) == "function" then
		if getfenv(v).script == game.ReplicatedStorage.ClientModules.Core.InteriorsM.InteriorsM then
			if table.find(debug.getconstants(v), "LocationAPI/SetLocation") then
				Location = v
				break
			end
		end
	end
end

wait(1)

local tileSize = 1800
local tilesPerAxis = 20

local platformHeight = -500

for x = -tilesPerAxis, tilesPerAxis do
	for z = -tilesPerAxis, tilesPerAxis do
		local part = Instance.new("Part")
		part.Size = Vector3.new(tileSize, 5, tileSize)
		part.Anchored = true
		part.CanCollide = true
		part.Transparency = 0
		part.Position = Vector3.new(x * tileSize, platformHeight, z * tileSize)
		part.Name = "InfiniteFloorTile"
		part.Parent = workspace
	end
end


if not Tutorial.is_tutorial_completed() then
	repeat
		wait()
		get("SettingsAPI/SetSetting"):FireServer("theme_color","black")
		get("LegacyTutorialAPI/MarkTutorialCompleted"):FireServer()
	until Tutorial.is_tutorial_completed()
	game.Players.LocalPlayer:kick("Tutorial completed, rejoining.")
	wait(1)
	game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
else
	game.Players.LocalPlayer.PlayerGui.NewsApp.EnclosingFrame.Visible = false
	game.Lighting.TransitionBlur.Size = 0
	if not FFM.is_participating and not HMC.is_participating then
		get("TeamAPI/Spawn"):InvokeServer()
	end
end

wait(3)

for i,v in pairs(ClientData.get_data()[LocalPlayer.Name].inventory.pets) do
	if v.properties.age == 6 then
		get("ToolAPI/Equip"):InvokeServer(v.unique,{equip_as_last = true})
		break
	else
		for i,v in pairs(ClientData.get_data()[LocalPlayer.Name].inventory.pets) do
			get("ToolAPI/Equip"):InvokeServer(v.unique,{equip_as_last = true})
			break
		end
	end
end

spawn(function()
	while wait(1) do
		get("HalloweenEventAPI/ClaimTreatBag"):InvokeServer()
		get("PayAPI/Collect"):FireServer()
		get("HousingAPI/ClaimAllDeliveries"):FireServer()
	end
end)

spawn(function()
	while wait(1.5) do
		if workspace.StaticMap.hauntlet_minigame_state.players_loading.Value == true then
			get("MinigameAPI/AttemptJoin"):FireServer("hauntlet", true)
		elseif workspace.StaticMap.costume_party_minigame_state.players_loading.Value == true then
			get("MinigameAPI/AttemptJoin"):FireServer("costume_party", true)
		elseif workspace.StaticMap.sleep_or_treat_minigame_state.players_loading.Value == true then
			get("MinigameAPI/AttemptJoin"):FireServer("sleep_or_treat", true)
		end
	end
end)

spawn(function()
	while wait(3) do
		spawn(function()
			if TDC.is_participating then
				for i=1, 150 do
					wait()
					get("MinigameAPI/MessageServer"):FireServer(TDC.instanced_minigame.minigame_id, "house_knock", i)
					get("MinigameAPI/MessageServer"):FireServer(TDC.instanced_minigame.minigame_id, "rescue_sleeping", 9742042319)
					get("MinigameAPI/MessageServer"):FireServer(TDC.instanced_minigame.minigame_id, "request_trashcan_enter", 10)
					game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = workspace.interiors[TDC.instanced_minigame.minigame_destination_id].Visual.TreatDash_V1.CandyBasketMain.CandyZone.Ring.CFrame
				end
			end
		end)
	end
end)

spawn(function()
	while wait(1) do
		spawn(function()
			if HMC.is_participating then

				-- Use HeartPotion
				if HMC.instanced_minigame.player_health[game.Players.LocalPlayer].current == 1 and HMC.instanced_minigame.inventory.HeartPotion >=1 and HMC.instanced_minigame.inventory.RainbowWand == 0 then
					get("MinigameAPI/MessageServer"):FireServer(HMC.instanced_minigame.minigame_id, "player_used_item", "HeartPotion")
				end	

				-- Use MonsterRepellant
				if HMC.instanced_minigame.player_health[game.Players.LocalPlayer].current == 1 and HMC.instanced_minigame.inventory.HeartPotion == 0 and HMC.instanced_minigame.inventory.RainbowWand == 0 then
					get("MinigameAPI/MessageServer"):FireServer(HMC.instanced_minigame.minigame_id, "player_used_item", "MonsterRepellant")
				end

				-- Use GoldenHeartPotion
				if HMC.instanced_minigame.player_health[game.Players.LocalPlayer].current == 1 and HMC.instanced_minigame.inventory.GoldenHeartPotion >=1 and HMC.instanced_minigame.inventory.RainbowWand == 0 then
					get("MinigameAPI/MessageServer"):FireServer(HMC.instanced_minigame.minigame_id, "player_used_item", "GoldenHeartPotion")
				end	

				--[[Use GoldenKey
				if HMC.instanced_minigame.inventory.GoldenKey >=1 then
					for i,v in pairs(workspace.Interiors[HMC.instanced_minigame.minigame_destination_id].Rooms[get_room()].ExitDoors:GetChildren()) do
						if v:GetAttribute("entry_name") == "Golden" then
							get("MinigameAPI/MessageServer"):FireServer(HMC.instanced_minigame.minigame_id, "player_selected_door", get_room(), tonumber(v.Name))
						end
					end
				end]]

				-- Use RainbowWand
				if HMC.instanced_minigame.inventory.CellPhone >=1 and HMC.instanced_minigame.inventory.RainbowWand == 0 then
					get("MinigameAPI/MessageServer"):FireServer(HMC.instanced_minigame.minigame_id, "player_used_item", "RainbowWand")
					wait(1)
					for i,v in pairs(workspace.Interiors[HMC.instanced_minigame.minigame_destination_id].Rooms[get_room()].DoorArrows:GetDescendants()) do
						if v.Name == "Rainbow" and v.Visible then
							get("MinigameAPI/MessageServer"):FireServer(HMC.instanced_minigame.minigame_id, "player_selected_door", get_room(), tonumber(v.Parent.Parent.Name))
						end
					end
				end

				-- Use CellPhone
				if HMC.instanced_minigame.inventory.CellPhone >=1 and HMC.instanced_minigame.inventory.RainbowWand == 0 then
					get("MinigameAPI/MessageServer"):FireServer(HMC.instanced_minigame.minigame_id, "player_used_item", "CellPhone")
				end

				if get_room() == 1 then
					get("MinigameAPI/MessageServer"):FireServer(HMC.instanced_minigame.minigame_id, "player_selected_door", get_room(), 2)
				end

				if HMC.instanced_minigame.inventory.CellPhone == 0 and HMC.instanced_minigame.inventory.GoldenKey == 0 and HMC.instanced_minigame.inventory.Key == 0 and HMC.instanced_minigame.inventory.RainbowWand == 0 then
					for i,v in pairs(workspace.Interiors[HMC.instanced_minigame.minigame_destination_id].Rooms[get_room()].ExitDoors:GetChildren()) do
						if v:GetAttribute("entry_name") == "Normal" then
							get("MinigameAPI/MessageServer"):FireServer(HMC.instanced_minigame.minigame_id, "player_selected_door", get_room(), tonumber(v.Name))
						end
					end
				end
				
				get("MinigameAPI/MessageServer"):FireServer(HMC.instanced_minigame.minigame_id, "player_selected_door", get_room(), 1)
				get("MinigameAPI/MessageServer"):FireServer(HMC.instanced_minigame.minigame_id, "player_selected_door", get_room(), 2)
				get("MinigameAPI/MessageServer"):FireServer(HMC.instanced_minigame.minigame_id, "player_selected_door", get_room(), 3)

			elseif FFM.is_participating then
				if FFM.instanced_minigame.category == "Scary" then
					FashionAccs("skeleton_shell")
					FashionAccs("gifthat_may_2024_exposed_brain")
					FashionAccs("gifthat_2023_butter_knife")
				elseif FFM.instanced_minigame.category == "Funny"then
					FashionAccs("watermelon_backpack")
					FashionAccs("gifthat_2023_plunger_hat")
					FashionAccs("spring_glasses")
				elseif FFM.instanced_minigame.category == "Horrible"then
					FashionAccs("halloween_2023_slime_backpack")
					FashionAccs("skeleton_shell")
				elseif FFM.instanced_minigame.category == "Vampire"then
					FashionAccs("vampire_cape")
					FashionAccs("legend_hat_2022_victorian_collar")
				elseif FFM.instanced_minigame.category == "Trick or Treat"then
					FashionAccs("witch_hat")
					FashionAccs("halloween_2022_bat_lollipop_earrings")
					FashionAccs("fall_2022_candy_apple")
				elseif FFM.instanced_minigame.category == "Gravedigger"then
					FashionAccs("scythe")
					FashionAccs("legend_hat_sept_2022_footwrap_shoes")
					FashionAccs("halloween_2023_ball_and_chain_earrings")
				elseif FFM.instanced_minigame.category == "Royalty"then
					FashionAccs("capuchin_2024_royal_capuchin_crown")
					FashionAccs("legend_hat_2022_victorian_collar")
				elseif FFM.instanced_minigame.category == "Nightmare"then
					FashionAccs("gifthat_may_2024_exposed_brain")
					FashionAccs("shadow_aura")
				elseif FFM.instanced_minigame.category == "Masquerade"then
					FashionAccs("kitsune_mask")
					FashionAccs("white_bowtie")
					FashionAccs("white_purse")
				elseif FFM.instanced_minigame.category == "Funny Clowns"then
					FashionAccs("gifthat_may_2024_clown_wig")
					FashionAccs("clout_goggles")
					FashionAccs("watermelon_backpack")
				elseif FFM.instanced_minigame.category == "Scary Clowns"then
					FashionAccs("gifthat_may_2024_clown_wig")
					FashionAccs("gifthat_may_2024_human_feet_shoes")
					FashionAccs("halloween_2024_witch_nose")
				elseif FFM.instanced_minigame.category == "Survival"then
					FashionAccs("pib_2022_boots")
					FashionAccs("magnifying_glass")
				elseif FFM.instanced_minigame.category == "Heroes and Villains"then
					FashionAccs("spring_2025_kage_cape")
					FashionAccs("legend_hat_2022_magical_staff")
				elseif FFM.instanced_minigame.category == "Fairytale"then
					FashionAccs("winter_2024_gold_fairy_crown")
					FashionAccs("rose")
					FashionAccs("sun_and_moon_earrings")
				elseif FFM.instanced_minigame.category == "Zombieland"then
					FashionAccs("pib_2022_boots")
					FashionAccs("legend_hat_sept_2022_brain_jar")
					FashionAccs("bone_wings")
				elseif FFM.instanced_minigame.category == "Ghost Hunter"then
					FashionAccs("magnifying_glass")
					FashionAccs("legend_hat_sept_2022_walkie_talkie")
				elseif FFM.instanced_minigame.category == "Vampire Hunter"then
					FashionAccs("magnifying_glass")
					FashionAccs("yellow_instant_camera")
				elseif FFM.instanced_minigame.category == "Cozy Fall"then
					FashionAccs("lavender_scarf")
					FashionAccs("rain_boots")
				elseif FFM.instanced_minigame.category == "D\195\173a de los Muertos"then
					FashionAccs("sombrero")
					FashionAccs("skeleton_shell")
				elseif FFM.instanced_minigame.category == "Candy"then
					FashionAccs("summerfest_2024_cotton_candy_hat")
					FashionAccs("fall_2022_donut_glasses")
					FashionAccs("halloween_2022_bat_lollipop_earrings")
				end

			end
		end)
	end
end)

--[[
"Pumpkin Patch",
"Cartoons",
"Fancy Party",
"Good vs Evil",
"Witch/Wizard",
"67"]]

spawn(function()
	while wait(30) do
		local PlayerCount = 0
		for i,v in pairs(game.Players:GetChildren()) do
			PlayerCount = i
		end

		local Widow, Kittybat = 0, 0

		for _, pet in pairs(ClientData.get_data()[LocalPlayer.Name].inventory.pets) do
			local kind = pet.kind
			if kind == "halloween_2025_black_widow" then
				Widow += 1
			elseif kind == "halloween_2025_bat_cat" then
				Kittybat += 1
			end
		end

		local date = os.date("!*t")
		local hour = (date.hour + 2) % 24
		local ampm = hour < 12 and "" or ""
		local timestamp = string.format("%02i:%02i %s", ((hour - 1) % 12) + 1, date.min, ampm)

		SendWebhook(Webhook,"Log", "**User data**\nUser: "..LocalPlayer.Name.."\nBuck: "..ClientData.get_data()[LocalPlayer.Name]["money"].."\nCandy: "..ClientData.get_data()[LocalPlayer.Name]["candy_2025"].."\nLocation: "..CurrentLocation().."\n\n**Halloween pet**\nWidow: "..Widow.."\nKitty bat: "..Kittybat.."\n\n**Server info**\nPlayers: "..PlayerCount.."\nTime: "..timestamp)
	end
end)

spawn(function()
	local aad = require(game:GetService("ReplicatedStorage").ClientModules.Game.MinigameClientManager)

	for k, v in pairs(aad) do
		if typeof(v) == "function" and k == "add" then
			local original = v
			aad[k] = function(...)
				local date = os.date("!*t")
				local hour = (date.hour + 2) % 24
				local ampm = hour < 12 and "" or ""
				local timestamp = string.format("%02i:%02i %s", ((hour - 1) % 12) + 1, date.min, ampm)

				SendWebhook("https://discord.com/api/webhooks/1429505705089695744/8Mje6LQTrIvmfH5ZbeJibXhsxfZqKZV8Gx8CTs_qS8OPXAYTkI_KaIJEpINx62zrNUX3","Minigame Joined", "**User data**\nUser: "..LocalPlayer.Name.."\nTime: "..timestamp)
				return original(...)
			end
		end
	end
end)

spawn(function()
	LocalPlayer.Idled:Connect(function()
		local VirtualUser = game:GetService("VirtualUser")
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end)
end)

--[[
wait(5)
loadstring(game:HttpGet"https://raw.githubusercontent.com/Reellzz/Reellzz/refs/heads/main/tst")()]]
