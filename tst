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

local in_minigame

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
	Name = ClientData.get_data()[LocalPlayer.Name]["char_wrapper"]["location"]["full_destination_id"]
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

for i,v in pairs(workspace.StaticMap.MinigameJoinCircleLocations:GetDescendants()) do
	if v:IsA("Part") then
		v.CanCollide = true
	end
end

spawn(function()
	while wait(1) do
		spawn(function()
			for i,v in pairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
				if v:IsA("ScreenGui") and v.Name ~= "MinigameInGameApp" then
					v.Enabled = false
				end
			end
			get("HalloweenEventAPI/ProgressTaming"):InvokeServer(true)
			get("HalloweenEventAPI/ClaimTreatBag"):InvokeServer()
			get("PayAPI/Collect"):FireServer()
			get("HousingAPI/ClaimAllDeliveries"):FireServer()
			if not ClientData.get_data()[LocalPlayer.Name].popcorn_manager.lily_pad_states[1] then
				for i=1, 6 do
					wait()
					get("HalloweenEventAPI/ClaimLilyPadCandy"):FireServer(i)
				end
			end
		end)
	end
end)

spawn(function()
	while wait(0.1) do
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
	while wait() do
		if HMC.is_participating or FFM.is_participating or TDC.is_participating then
			in_minigame = true
		elseif not HMC.is_participating and not FFM.is_participating and not TDC.is_participating then
			in_minigame = false
		end
	end
end)

spawn(function()
	while wait(1) do
		spawn(function()
			if TDC.is_participating then
				if TDC.instanced_minigame.sleep_state.is_asleep then
					get("MinigameAPI/MessageServer"):FireServer(TDC.instanced_minigame.minigame_id, "rescue_sleeping", game.Players.LocalPlayer.UserId)
				end

				while wait(0.1) do
					if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - workspace.Interiors[TDC.instanced_minigame.minigame_destination_id].Visual.TreatDash_V1.CandyBasketMain.CandyZone.Ring.Position).Magnitude < 10 then
						for a,b in pairs(TDC.instanced_minigame.houses) do
							if not b.disabled then
								wait(0.5)
								get("MinigameAPI/MessageServer"):FireServer(TDC.instanced_minigame.minigame_id, "house_knock", tonumber(a))
								get("MinigameAPI/MessageServer"):FireServer(TDC.instanced_minigame.minigame_id, "house_knock", tonumber(a))
								get("MinigameAPI/MessageServer"):FireServer(TDC.instanced_minigame.minigame_id, "house_knock", tonumber(a))
							end
						end
					else
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Interiors[TDC.instanced_minigame.minigame_destination_id].Visual.TreatDash_V1.CandyBasketMain.CandyZone.Ring.CFrame
					end
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

				--Use GoldenKey
				if HMC.instanced_minigame.inventory.GoldenKey >=1 then
					for i,v in pairs(workspace.Interiors[HMC.instanced_minigame.minigame_destination_id].Rooms[get_room()].ExitDoors:GetChildren()) do
						if v:GetAttribute("entry_name") == "Golden" then
							get("MinigameAPI/MessageServer"):FireServer(HMC.instanced_minigame.minigame_id, "player_selected_door", get_room(), tonumber(v.Name))
						end
					end
				end

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

function BathFinder(Name)
	local FurnitureDB = require(game:GetService("ReplicatedStorage").ClientDB.Housing.FurnitureDB)
	for i,v in pairs(FurnitureDB) do
		if v.can_use_in_house and v.model_name:match("Shower") or v.model_name:match("Bath") then
			for a,b in pairs(workspace.HouseInteriors.furniture:GetChildren()) do
				if b:FindFirstChildWhichIsA("Model") and b:FindFirstChildWhichIsA("Model").Name == v.model_name then
					Name = string.split(b.Name, "true/")[2]
					return Name
				end
			end
		end
	end
end

function ToiletFinder(Name)
	local FurnitureDB = require(game:GetService("ReplicatedStorage").ClientDB.Housing.FurnitureDB)
	for i,v in pairs(FurnitureDB) do
		if v.can_use_in_house and v.model_name:match("Toilet") or v.model_name:match("Toilet") then
			for a,b in pairs(workspace.HouseInteriors.furniture:GetChildren()) do
				if b:FindFirstChildWhichIsA("Model") and b:FindFirstChildWhichIsA("Model").Name == v.model_name then
					Name = string.split(b.Name, "true/")[2]
					return Name
				end
			end
		end
	end
end

function BedFinder(Name)
	local FurnitureDB = require(game:GetService("ReplicatedStorage").ClientDB.Housing.FurnitureDB)
	for i,v in pairs(FurnitureDB) do
		if v.can_use_in_house and v.model_name:match("BasicCrib") or v.model_name:match("BasicCrib") then
			for a,b in pairs(workspace.HouseInteriors.furniture:GetChildren()) do
				if b:FindFirstChildWhichIsA("Model") and b:FindFirstChildWhichIsA("Model").Name == v.model_name then
					Name = string.split(b.Name, "true/")[2]
					return Name
				end
			end
		end
	end
end

TaskFarming = false

while wait(1) do
	pcall(function()
		if ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique] then
			for i,v in pairs(ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]) do

				if i == "thirsty" and not in_minigame then
					if not TaskFarming then
						TaskFarming = true
						print('["debug"]["thirsty"]: start task')

						get("ShopAPI/BuyItem"):InvokeServer("food", "water", {["buy_count"] = 1})
						wait(0.5)
						get("PetObjectAPI/CreatePetObject"):InvokeServer("__Enum_PetObjectCreatorType_2", {["pet_unique"] = ClientData.get_data()[LocalPlayer.Name]["pet_char_wrappers"][1]["pet_unique"],["unique_id"] = ClientData.get_data()[LocalPlayer.Name]["equip_manager"]["food"][1]["unique"]})

						pcall(function()
							while wait() do
								repeat wait()
								until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["thirsty"])
								return
							end
						end)

						TaskFarming = false
						print('["debug"]["thirsty"]: end task')
					end
				end
				if i == "hungry" and not in_minigame then
					if not TaskFarming then
						TaskFarming = true
						print('["debug"]["hungry"]: start task')

						get("ShopAPI/BuyItem"):InvokeServer("food", "apple", {["buy_count"] = 1})
						wait(0.5)
						get("PetObjectAPI/CreatePetObject"):InvokeServer("__Enum_PetObjectCreatorType_2", {["pet_unique"] = ClientData.get_data()[LocalPlayer.Name]["pet_char_wrappers"][1]["pet_unique"],["unique_id"] = ClientData.get_data()[LocalPlayer.Name]["equip_manager"]["food"][1]["unique"]})

						pcall(function()
							while wait() do
								repeat wait()
								until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["hungry"])
								return
							end
						end)

						TaskFarming = false
						print('["debug"]["hungry"]: end task')
					end
				end
				if i == "sick" and not in_minigame then
					if not TaskFarming then
						TaskFarming = true
						print('["debug"]["sick"]: start task')
						LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = MainPart.CFrame + Vector3.new(0, 5, 0)

						get("LocationAPI/SetLocation"):FireServer("Hospital")

						local args = {
							"f-14",
							"UseBlock",
							"Yes",
							game:GetService("Players").LocalPlayer.Character
						}

						get("HousingAPI/ActivateInteriorFurniture"):InvokeServer(unpack(args))

						pcall(function()
							while wait() do
								repeat wait()
								until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["sick"])
								return
							end
						end)

						LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = MainPart.CFrame + Vector3.new(0, 5, 0)
						TaskFarming = false
						print('["debug"]["sick"]: end task')
					end
				end
				if i == "bored" and not in_minigame then
					if not TaskFarming then
						TaskFarming = true
						print('["debug"]["bored"]: start task')
						LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = workspace.StaticMap.TeleportLocations.Park.CFrame + Vector3.new(0, 5, 0)

						get("LocationAPI/SetLocation"):FireServer("MainMap", game.Players.LocalPlayer, "Default")

						pcall(function()
							while wait() do
								repeat wait()
								until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["bored"])
								return
							end
						end)

						LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = MainPart.CFrame + Vector3.new(0, 5, 0)
						TaskFarming = false
						print('["debug"]["bored"]: end task')
					end
				end
				if i == "camping" and not in_minigame then
					if not TaskFarming then
						TaskFarming = true
						print('["debug"]["camping"]: start task')
						LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = workspace.StaticMap.Campsite.CampsiteOrigin.CFrame + Vector3.new(0, 5, 0)

						get("LocationAPI/SetLocation"):FireServer("MainMap", game.Players.LocalPlayer, "Default")

						pcall(function()
							while wait() do
								repeat wait()
								until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["camping"])
								return
							end
						end)

						LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = MainPart.CFrame + Vector3.new(0, 5, 0)
						TaskFarming = false
						print('["debug"]["camping"]: end task')
					end
				end
				if i == "beach_party" and not in_minigame then
					if not TaskFarming then
						TaskFarming = true
						print('["debug"]["beach_party"]: start task')
						LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = workspace.StaticMap.TeleportLocations.exterior_beach.CFrame + Vector3.new(0, 5, 0)

						get("LocationAPI/SetLocation"):FireServer("MainMap", game.Players.LocalPlayer, "Default")

						pcall(function()
							while wait() do
								repeat wait()
								until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["beach_party"])
								return
							end
						end)

						LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = MainPart.CFrame + Vector3.new(0, 5, 0)
						TaskFarming = false
						print('["debug"]["beach_party"]: end task')
					end
				end
				if i == "pizza_party" and not in_minigame then
					if not TaskFarming then
						TaskFarming = true
						print('["debug"]["pizza_party"]: start task')

						get("LocationAPI/SetLocation"):FireServer("PizzaShop")

						pcall(function()
							while wait() do
								repeat wait()
								until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["pizza_party"])
								return
							end
						end)

						LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = MainPart.CFrame + Vector3.new(0, 5, 0)
						TaskFarming = false
						print('["debug"]["pizza_party"]: end task')
					end
				end
				if i == "salon" and not in_minigame then
					if not TaskFarming then
						TaskFarming = true
						print('["debug"]["salon"]: start task')

						get("LocationAPI/SetLocation"):FireServer("Salon")

						pcall(function()
							while wait() do
								repeat wait()
								until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["salon"])
								return
							end
						end)

						TaskFarming = false
						print('["debug"]["salon"]: end task')
					end
				end
				if i == "mystery" and not in_minigame then
					if not TaskFarming then
						TaskFarming = true
						print('["debug"]["mystery"]: start task')

						pcall(function()
							for a,b in pairs(ClientData.get_data()[LocalPlayer.Name]["ailments_manager"]["ailments"][ClientData.get_data()[LocalPlayer.Name]["pet_char_wrappers"][1]["pet_unique"]]["mystery"]["components"]["mystery"]["components"]) do
								if b["preference_status"] then
									get("AilmentsAPI/ChooseMysteryAilment"):FireServer(ClientData.get_data()[LocalPlayer.Name]["pet_char_wrappers"][1]["pet_unique"], "mystery", 1, a)
									wait(1)
									get("AilmentsAPI/ChooseMysteryAilment"):FireServer(ClientData.get_data()[LocalPlayer.Name]["pet_char_wrappers"][1]["pet_unique"], "mystery", 1, a)
									wait(1)
									get("AilmentsAPI/ChooseMysteryAilment"):FireServer(ClientData.get_data()[LocalPlayer.Name]["pet_char_wrappers"][1]["pet_unique"], "mystery", 1, a)
								end
							end
						end)

						TaskFarming = false
						print('["debug"]["mystery"]: end task')
					end
				end
				if i == "school" and not in_minigame then
					if not TaskFarming then
						TaskFarming = true
						print('["debug"]["school"]: start task')
						LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = MainPart.CFrame + Vector3.new(0, 5, 0)

						get("LocationAPI/SetLocation"):FireServer("School")

						pcall(function()
							while wait() do
								repeat wait()
								until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["school"])
								return
							end
						end)

						TaskFarming = false
						print('["debug"]["school"]: end task')
					end
				end
				if i == "dirty" and not in_minigame then
					if not TaskFarming then
						TaskFarming = true
						print('["debug"]["dirty"]: start task')

						get("HousingAPI/UnsubscribeFromHouse"):InvokeServer(LocalPlayer)
						get("HousingAPI/SubscribeToHouse"):FireServer(LocalPlayer)
						get("LocationAPI/SetLocation"):FireServer("housing", LocalPlayer)

						wait(2)

						if BathFinder() then
							local args = {
								[1] = LocalPlayer,
								[2] = BathFinder(),
								[3] = "UseBlock",
								[4] = {
									["cframe"] = LocalPlayer.Character.Head.CFrame
								},
								[5] = workspace:FindFirstChild("Pets"):FindFirstChild(Fsys("InventoryDB").pets[ClientData.get_data()[LocalPlayer.Name]["pet_char_wrappers"][1]["pet_id"]]["name"])
							}

							get("HousingAPI/ActivateFurniture"):InvokeServer(unpack(args))
						end

						TaskFarming = false
						print('["debug"]["dirty"]: end task')
					end
				end
				if i == "sleepy" and not in_minigame then
					if not TaskFarming then
						TaskFarming = true
						print('["debug"]["sleepy"]: start task')

						get("HousingAPI/UnsubscribeFromHouse"):InvokeServer(LocalPlayer)
						get("HousingAPI/SubscribeToHouse"):FireServer(LocalPlayer)
						get("LocationAPI/SetLocation"):FireServer("housing", LocalPlayer)

						wait(2)

						if BedFinder() then
							local args = {
								LocalPlayer,
								BedFinder(),
								"UseBlock",
								{
									cframe = LocalPlayer.Character.Head.CFrame
								},
								workspace:FindFirstChild("Pets"):FindFirstChild(Fsys("InventoryDB").pets[ClientData.get_data()[LocalPlayer.Name]["pet_char_wrappers"][1]["pet_id"]]["name"])
							}
							get("HousingAPI/ActivateFurniture"):InvokeServer(unpack(args))
						end

						TaskFarming = false
						print('["debug"]["sleepy"]: end task')
					end
				end
				if i == "pet_me" and not in_minigame then
					if not TaskFarming then
						TaskFarming = true
						print('["debug"]["pet_me"]: start task')

						pcall(function()
							while wait() do
								repeat wait() get("AdoptAPI/FocusPet"):FireServer(workspace:FindFirstChild("Pets"):FindFirstChild(Fsys("InventoryDB").pets[ClientData.get_data()[LocalPlayer.Name]["pet_char_wrappers"][1]["pet_id"]]["name"]))
									--get("AvatarAPI/SetPlayerOnPlayerCollision"):FireServer(false)
									get("PetAPI/ReplicateActivePerformances"):FireServer(workspace:FindFirstChild("Pets"):FindFirstChild(Fsys("InventoryDB").pets[ClientData.get_data()[LocalPlayer.Name]["pet_char_wrappers"][1]["pet_id"]]["name"]),{["FocusPet"] = true})
									get("PetAPI/ReplicateActivePerformances"):FireServer(workspace:FindFirstChild("Pets"):FindFirstChild(Fsys("InventoryDB").pets[ClientData.get_data()[LocalPlayer.Name]["pet_char_wrappers"][1]["pet_id"]]["name"]),{["FocusPet"] = true})
									get("AilmentsAPI/ProgressPetMeAilment"):FireServer(ClientData.get_data()[LocalPlayer.Name]["pet_char_wrappers"][1]["pet_unique"])
								until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["pet_me"])
								return
							end
						end)

						TaskFarming = false
						print('["debug"]["pet_me"]: end task')
					end
				end
				if i == "walk" and not in_minigame then
					if not TaskFarming then
						TaskFarming = true
						print('["debug"]["walk"]: start task')

						get("AdoptAPI/HoldBaby"):FireServer(workspace:FindFirstChild("Pets"):FindFirstChild(Fsys("InventoryDB").pets[ClientData.get_data()[LocalPlayer.Name]["pet_char_wrappers"][1]["pet_id"]]["name"]))

						pcall(function()
							while wait() do
								repeat wait() game.Players.LocalPlayer.Character.Humanoid.Jump = true
								until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["walk"])
								return
							end
						end)

						wait(1)

						get("AdoptAPI/EjectBaby"):FireServer(workspace:FindFirstChild("Pets"):FindFirstChild(Fsys("InventoryDB").pets[ClientData.get_data()[LocalPlayer.Name]["pet_char_wrappers"][1]["pet_id"]]["name"]))

						TaskFarming = false
						print('["debug"]["walk"]: end task')
					end
				end
				if i == "play" and not in_minigame then
					if not TaskFarming then
						TaskFarming = true
						print('["debug"]["play"]: start task')

						for i,v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.toys) do
							if v.id == "squeaky_bone_default" then
								get("ToolAPI/Equip"):InvokeServer(v.unique)
								wait(2)
								get("PetObjectAPI/CreatePetObject"):InvokeServer("__Enum_PetObjectCreatorType_1",{["reaction_name"] = "ThrowToyReaction",["unique_id"] = v.unique})
								wait(4)
								get("PetObjectAPI/CreatePetObject"):InvokeServer("__Enum_PetObjectCreatorType_1",{["reaction_name"] = "ThrowToyReaction",["unique_id"] = v.unique})
								wait(4)
								get("PetObjectAPI/CreatePetObject"):InvokeServer("__Enum_PetObjectCreatorType_1",{["reaction_name"] = "ThrowToyReaction",["unique_id"] = v.unique})
								wait(2)
								get("ToolAPI/Unequip"):InvokeServer(v.unique)
							end
						end

						TaskFarming = false
						print('["debug"]["play"]: end task')
					end
				end
				if i == "ride" and not in_minigame then
					if not TaskFarming then
						TaskFarming = true
						print('["debug"]["ride"]: start task')

						for i,v in pairs(ClientData.get_data()[LocalPlayer.Name].inventory.strollers) do
							if v.id == "stroller-default" then
								Stroller = v.unique
								get("ToolAPI/Equip"):InvokeServer(Stroller)
								wait(2)
								get("AdoptAPI/UseStroller"):InvokeServer(game.Players[game.Players.LocalPlayer.Name],workspace:FindFirstChild("Pets"):FindFirstChild(Fsys("InventoryDB").pets[ClientData.get_data()[LocalPlayer.Name]["pet_char_wrappers"][1]["pet_id"]]["name"]),LocalPlayer.Character.StrollerTool.ModelHandle.TouchToSits.TouchToSit)
							end
						end

						pcall(function()
							while wait() do
								repeat wait() game.Players.LocalPlayer.Character.Humanoid.Jump = true
								until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["ride"])
								return
							end
						end)

						get("ToolAPI/Unequip"):InvokeServer(Stroller)

						TaskFarming = false
						print('["debug"]["ride"]: end task')
					end
				end
				if i == "toilet" and not in_minigame then
					if not TaskFarming then
						TaskFarming = true
						print('["debug"]["toilet"]: start task')

						get("HousingAPI/UnsubscribeFromHouse"):InvokeServer(LocalPlayer)
						get("HousingAPI/SubscribeToHouse"):FireServer(LocalPlayer)
						get("LocationAPI/SetLocation"):FireServer("housing", LocalPlayer)

						wait(2)

						if ToiletFinder() then
							local args = {
								[1] = LocalPlayer,
								[2] = ToiletFinder(),
								[3] = "Seat1",
								[4] = {
									["cframe"] = LocalPlayer.Character.Head.CFrame
								},
								[5] = workspace:FindFirstChild("Pets"):FindFirstChild(Fsys("InventoryDB").pets[ClientData.get_data()[LocalPlayer.Name]["pet_char_wrappers"][1]["pet_id"]]["name"])
							}

							get("HousingAPI/ActivateFurniture"):InvokeServer(unpack(args))
						end

						TaskFarming = false
						print('["debug"]["toilet"]: end task')
					end
				end
				if i == "scale_the_organ" and not in_minigame then
					if not TaskFarming then
						TaskFarming = true
						print('["debug"]["scale_the_organ"]: start task')

						pcall(function()
							while wait() do
								repeat wait(1)
									local player = game.Players.LocalPlayer
									local character = player.Character or player.CharacterAdded:Wait()
									local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

									local keysFolder = workspace:WaitForChild("StaticMap"):WaitForChild("HalloweenEvent"):WaitForChild("Keys")
									for _, key in pairs(keysFolder:GetChildren()) do
										local touchInterest = key:FindFirstChildOfClass("TouchTransmitter")
										if touchInterest then
											firetouchinterest(humanoidRootPart, key, 0)
											task.wait()
											firetouchinterest(humanoidRootPart, key, 1)
										end
									end
								until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["scale_the_organ"])
								return
							end
						end)

						TaskFarming = false
						print('["debug"]["scale_the_organ"]: end task')
					end
				end
				if i == "wear_scare" and not in_minigame then
					if not TaskFarming then
						TaskFarming = true
						print('["debug"]["wear_scare"]: start task')

						get("AdoptAPI/HoldBaby"):FireServer(workspace:FindFirstChild("Pets"):FindFirstChild(Fsys("InventoryDB").pets[ClientData.get_data()[LocalPlayer.Name]["pet_char_wrappers"][1]["pet_id"]]["name"]))

						pcall(function()
							while wait() do
								repeat wait() game.Players.LocalPlayer.Character.Humanoid.Jump = true
								until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["wear_scare"])
								return
							end
						end)

						wait(1)

						get("AdoptAPI/EjectBaby"):FireServer(workspace:FindFirstChild("Pets"):FindFirstChild(Fsys("InventoryDB").pets[ClientData.get_data()[LocalPlayer.Name]["pet_char_wrappers"][1]["pet_id"]]["name"]))

						TaskFarming = false
						print('["debug"]["wear_scare"]: end task')
					end
				end
			end
		end
	end)
end
