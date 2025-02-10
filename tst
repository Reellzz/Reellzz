local LocalPlayer = game.Players.LocalPlayer
local Fsys = require(game.ReplicatedStorage:FindFirstChild("Fsys")).load
local ClientData = Fsys("ClientData")
local get = Fsys("RouterClient").get

local AMCheatPart = Instance.new("Part", workspace)
local ParkPart = Instance.new("Part", workspace)
local BeachPart = Instance.new("Part", workspace)

AMCheatPart.Size = Vector3.new(500, 0, 500)
AMCheatPart.Anchored = true
AMCheatPart.CFrame = CFrame.new(500, 500, 500)

ParkPart.Size = Vector3.new(500, 0, 500)
ParkPart.Anchored = true
ParkPart.CFrame = workspace.StaticMap.TeleportLocations.Park.CFrame + Vector3.new(0, -6, 0)

BeachPart.Size = Vector3.new(500, 0, 500)
BeachPart.Anchored = true
BeachPart.CFrame = workspace.StaticMap.TeleportLocations.exterior_beach.CFrame + Vector3.new(0, -5, 0)

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

_G.Start = true
while _G.Start == true do
	wait(1)
	if ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique] then
		for i,v in pairs(ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]) do

			if i == "thirsty" then
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
			if i == "hungry" then
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
			if i == "sick" then
				if not TaskFarming then
					TaskFarming = true
					print('["debug"]["sick"]: start task')
					LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = AMCheatPart.CFrame + Vector3.new(0, 5, 0)

					get("LocationAPI/SetLocation"):FireServer("Hospital")

					local args = {
						[1] = "f-80",
						[2] = "UseBlock",
						[3] = "Yes",
						[4] = workspace:WaitForChild("PlayerCharacters"):WaitForChild(LocalPlayer.Name)
					}

					get("HousingAPI/ActivateInteriorFurniture"):InvokeServer(unpack(args))

					pcall(function()
						while wait() do
							repeat wait()
							until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["sick"])
							return
						end
					end)

					LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = AMCheatPart.CFrame + Vector3.new(0, 5, 0)
					TaskFarming = false
					print('["debug"]["sick"]: end task')
				end
			end
			if i == "bored" then
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

					LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = AMCheatPart.CFrame + Vector3.new(0, 5, 0)
					TaskFarming = false
					print('["debug"]["bored"]: end task')
				end
			end
			if i == "camping" then
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

					LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = AMCheatPart.CFrame + Vector3.new(0, 5, 0)
					TaskFarming = false
					print('["debug"]["camping"]: end task')
				end
			end
			if i == "beach_party" then
				if not TaskFarming then
					TaskFarming = true
					print('["debug"]["beach_party"]: start task')
					LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = workspace.StaticMap.TeleportLocations.exterior_beach.CFrame + Vector3.new(0, -5, 0)

					get("LocationAPI/SetLocation"):FireServer("MainMap", game.Players.LocalPlayer, "Default")

					pcall(function()
						while wait() do
							repeat wait()
							until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["beach_party"])
							return
						end
					end)

					LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = AMCheatPart.CFrame + Vector3.new(0, 5, 0)
					TaskFarming = false
					print('["debug"]["beach_party"]: end task')
				end
			end
			if i == "pizza_party" then
				if not TaskFarming then
					TaskFarming = true
					print('["debug"]["pizza_party"]: start task')
					LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = AMCheatPart.CFrame + Vector3.new(0, 5, 0)

					get("LocationAPI/SetLocation"):FireServer("PizzaShop")

					pcall(function()
						while wait() do
							repeat wait()
							until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["pizza_party"])
							return
						end
					end)

					LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = AMCheatPart.CFrame + Vector3.new(0, 5, 0)
					TaskFarming = false
					print('["debug"]["pizza_party"]: end task')
				end
			end
			if i == "salon" then
				if not TaskFarming then
					TaskFarming = true
					print('["debug"]["salon"]: start task')
					LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = AMCheatPart.CFrame + Vector3.new(0, 5, 0)

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
			if i == "mystery" then
				if not TaskFarming then
					TaskFarming = true
					print('["debug"]["mystery"]: start task')

					for a,b in pairs(ClientData.get_data()[LocalPlayer.Name]["ailments_manager"]["ailments"][ClientData.get_data()[LocalPlayer.Name]["pet_char_wrappers"][1]["pet_unique"]]["mystery"]["components"]["mystery"]["components"]) do
						wait(0.65)
						pcall(function()
							get("AilmentsAPI/ChooseMysteryAilment"):FireServer("mystery", 1, a)
							wait(0.5)
							get("AilmentsAPI/ChooseMysteryAilment"):FireServer("mystery", 2, a)
						end)
					end

					TaskFarming = false
					print('["debug"]["mystery"]: end task')
				end
			end
			if i == "school" then
				if not TaskFarming then
					TaskFarming = true
					print('["debug"]["school"]: start task')
					LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = AMCheatPart.CFrame + Vector3.new(0, 5, 0)

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
			if i == "dirty" then
				if not TaskFarming then
					TaskFarming = true
					print('["debug"]["dirty"]: start task')

					LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = AMCheatPart.CFrame + Vector3.new(0, 5, 0)

					get("HousingAPI/UnsubscribeFromHouse"):InvokeServer(LocalPlayer)
					get("HousingAPI/SubscribeToHouse"):FireServer(LocalPlayer)
					get("LocationAPI/SetLocation"):FireServer("housing", LocalPlayer)

					wait(3)

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
			if i == "sleepy" then
				if not TaskFarming then
					TaskFarming = true
					print('["debug"]["sleepy"]: start task')

					LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = AMCheatPart.CFrame + Vector3.new(0, 5, 0)

					get("HousingAPI/UnsubscribeFromHouse"):InvokeServer(LocalPlayer)
					get("HousingAPI/SubscribeToHouse"):FireServer(LocalPlayer)
					get("LocationAPI/SetLocation"):FireServer("housing", LocalPlayer)

					wait(3)

					if BedFinder() then
						local args = {
							[1] = LocalPlayer,
							[2] = BedFinder(),
							[3] = "UseBlock",
							[4] = {
								["cframe"] = LocalPlayer.Character.Head.CFrame
							},
							[5] = workspace:FindFirstChild("Pets"):FindFirstChild(Fsys("InventoryDB").pets[ClientData.get_data()[LocalPlayer.Name]["pet_char_wrappers"][1]["pet_id"]]["name"])
						}

						get("HousingAPI/ActivateFurniture"):InvokeServer(unpack(args))
					end

					TaskFarming = false
					print('["debug"]["sleepy"]: end task')
				end
			end
			if i == "pet_me" then
				if not TaskFarming then
					TaskFarming = true
					print('["debug"]["pet_me"]: start task')

					for i=1, 10 do
						get("AdoptAPI/FocusPet"):FireServer(workspace:FindFirstChild("Pets"):FindFirstChild(Fsys("InventoryDB").pets[ClientData.get_data()[LocalPlayer.Name]["pet_char_wrappers"][1]["pet_id"]]["name"]))
						get("AvatarAPI/SetPlayerOnPlayerCollision"):FireServer(false)
						get("PetAPI/ReplicateActivePerformances"):FireServer(workspace:FindFirstChild("Pets"):FindFirstChild(Fsys("InventoryDB").pets[ClientData.get_data()[LocalPlayer.Name]["pet_char_wrappers"][1]["pet_id"]]["name"]),{["FocusPet"] = true})
						get("PetAPI/ReplicateActivePerformances"):FireServer(workspace:FindFirstChild("Pets"):FindFirstChild(Fsys("InventoryDB").pets[ClientData.get_data()[LocalPlayer.Name]["pet_char_wrappers"][1]["pet_id"]]["name"]),{["FocusPet"] = true})
						get("AilmentsAPI/ProgressPetMeAilment"):FireServer(ClientData.get_data()[LocalPlayer.Name]["pet_char_wrappers"][1]["pet_unique"])
					end
					
					pcall(function()
						while wait() do
							repeat wait()
							until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["pet_me"])
							return
						end
					end)

					TaskFarming = false
					print('["debug"]["pet_me"]: end task')
				end
			end
			if i == "moon" then
				if not TaskFarming then
					TaskFarming = true
					print('["debug"]["moon"]: start task')

					get("LocationAPI/SetLocation"):FireServer("MoonInterior")

					pcall(function()
						while wait() do
							repeat wait()
							until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["moon"])
							return
						end
					end)

					TaskFarming = false
					print('["debug"]["moon"]: end task')
				end
			end
			if i == "walk" then
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

					TaskFarming = false
					print('["debug"]["walk"]: end task')
				end
			end
			if i == "play" then
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
			if i == "ride" then
				if not TaskFarming then
					TaskFarming = true
					print('["debug"]["ride"]: start task')

					for i,v in pairs(ClientData.get_data()[LocalPlayer.Name].inventory.strollers) do
						if v.id == "stroller-default" then
							Stroller = v.unique
							get("ToolAPI/Equip"):InvokeServer(Stroller)
							wait(2)
							get("AdoptAPI/UseStroller"):InvokeServer(workspace:FindFirstChild("Pets"):FindFirstChild(Fsys("InventoryDB").pets[ClientData.get_data()[LocalPlayer.Name]["pet_char_wrappers"][1]["pet_id"]]["name"]),LocalPlayer.Character.StrollerTool.ModelHandle.TouchToSits.TouchToSit)
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
			if i == "toilet" then
				if not TaskFarming then
					TaskFarming = true
					print('["debug"]["toilet"]: start task')

					LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = AMCheatPart.CFrame + Vector3.new(0, 5, 0)

					get("HousingAPI/UnsubscribeFromHouse"):InvokeServer(LocalPlayer)
					get("HousingAPI/SubscribeToHouse"):FireServer(LocalPlayer)
					get("LocationAPI/SetLocation"):FireServer("housing", LocalPlayer)

					wait(3)

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
		end
	end
end

--loadstring(game:HttpGet("https://raw.githubusercontent.com/Reellzz/Reellzz/refs/heads/main/tst"))()
