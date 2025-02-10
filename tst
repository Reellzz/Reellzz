local LocalPlayer = game.Players.LocalPlayer
local Fsys = require(game.ReplicatedStorage:FindFirstChild("Fsys")).load
local ClientData = Fsys("ClientData")
local get = Fsys("RouterClient").get

function TaskEnd(Task)
	pcall(function()
		while wait() do
			repeat wait()
			until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique][Task])
		end
	end)
end

if ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique] then
	for i,v in pairs(ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]) do
		if i == "thirsty" then
			print('["debug"]["thirsty"]: start task')
			TaskEnd("thirsty")
			print('["debug"]["thirsty"]: end task')
		end
		if i == "hungry" then
			print('["debug"]["hungry"]: start task')
			TaskEnd("hungry")
			print('["debug"]["hungry"]: start task')
		end
		if i == "sick" then
			print('["debug"]["sick"]: start task')
			TaskEnd("sick")
			print('["debug"]["sick"]: start task')
		end
		if i == "bored" then
			print('["debug"]["bored"]: start task')
			TaskEnd("bored")
			print('["debug"]["bored"]: start task')
		end
		if i == "camping" then
			print('["debug"]["camping"]: start task')
			TaskEnd("camping")
			print('["debug"]["camping"]: start task')
		end
		if i == "beach_party" then
			print('["debug"]["beach_party"]: start task')
			TaskEnd("beach_party")
			print('["debug"]["beach_party"]: start task')
		end
		if i == "pizza_party" then
			print('["debug"]["pizza_party"]: start task')
			TaskEnd("pizza_party")
			print('["debug"]["pizza_party"]: start task')
		end
		if i == "salon" then
			print('["debug"]["salon"]: start task')
			TaskEnd("salon")
			print('["debug"]["salon"]: start task')
		end
		if i == "mystery" then
			print('["debug"]["mystery"]: start task')
			TaskEnd("mystery")
			print('["debug"]["mystery"]: start task')
		end
		if i == "school" then
			print('["debug"]["school"]: start task')
			TaskEnd("school")
			print('["debug"]["school"]: start task')
		end
		if i == "dirty" then
			print('["debug"]["dirty"]: start task')
			TaskEnd("dirty")
			print('["debug"]["dirty"]: start task')
		end
		if i == "sleepy" then
			print('["debug"]["sleepy"]: start task')
			TaskEnd("sleepy")
			print('["debug"]["sleepy"]: start task')
		end
	end
end
