local LocalPlayer = game.Players.LocalPlayer
local Fsys = require(game.ReplicatedStorage:FindFirstChild("Fsys")).load
local ClientData = Fsys("ClientData")
local get = Fsys("RouterClient").get

if ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique] then
	for i, v in pairs(ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]) do
		if i == "thirsty" then
			print('["debug"]["thirsty"]: start task')
			
			print('["debug"]["thirsty"]: end task')
		end
		if i == "hungry" then
			print('["debug"]["hungry"]: start task')
			
			print('["debug"]["hungry"]: end task')
		end
		if i == "sick" then
			print('["debug"]["sick"]: start task')
			
			print('["debug"]["sick"]: end task')
		end
		if i == "bored" then
			print('["debug"]["bored"]: start task')
			
			print('["debug"]["bored"]: end task')
		end
		if i == "camping" then
			print('["debug"]["camping"]: start task')
			
			print('["debug"]["camping"]: end task')
		end
		if i == "beach_party" then
			print('["debug"]["beach_party"]: start task')
			
			print('["debug"]["beach_party"]: end task')
		end
		if i == "pizza_party" then
			print('["debug"]["pizza_party"]: start task')
			
			print('["debug"]["pizza_party"]: end task')
		end
		if i == "salon" then
			print('["debug"]["salon"]: start task')
			
			print('["debug"]["salon"]: end task')
		end
		if i == "mystery" then
			print('["debug"]["mystery"]: start task')
			
			print('["debug"]["mystery"]: end task')
		end
		if i == "school" then
			print('["debug"]["school"]: start task')
			
			print('["debug"]["school"]: end task')
		end
		if i == "dirty" then
			print('["debug"]["dirty"]: start task')
			
			print('["debug"]["dirty"]: end task')
		end
		if i == "sleepy" then
			print('["debug"]["sleepy"]: start task')
			
			print('["debug"]["sleepy"]: end task')
		end
		if i == "toilet" then
			print('["debug"]["toilet"]: start task')

			print('["debug"]["toilet"]: end task')
		end
		if i == "walk" then
			print('["debug"]["walk"]: start task')

			print('["debug"]["walk"]: end task')
		end
	end
end
