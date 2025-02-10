local LocalPlayer = game.Players.LocalPlayer
local Fsys = require(game.ReplicatedStorage:FindFirstChild("Fsys")).load
local ClientData = Fsys("ClientData")
local get = Fsys("RouterClient").get

if ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique] then
	for i,v in pairs(ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]) do
		if i == "thirsty" then
			print('["debug"]["thirsty"]: start task')
			
			pcall(function()
				while wait() do
					repeat wait()
					until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["thirsty"])
				end
			end)
			
			print('["debug"]["thirsty"]: end task')
		end
		if i == "hungry" then
			print('["debug"]["hungry"]: start task')
			
			pcall(function()
				while wait() do
					repeat wait()
					until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["hungry"])
				end
			end)
			
			print('["debug"]["hungry"]: start task')
		end
		if i == "sick" then
			print('["debug"]["sick"]: start task')
			
			pcall(function()
				while wait() do
					repeat wait()
					until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["sick"])
				end
			end)
			
			print('["debug"]["sick"]: start task')
		end
		if i == "bored" then
			print('["debug"]["bored"]: start task')
			
			pcall(function()
				while wait() do
					repeat wait()
					until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["bored"])
				end
			end)
			
			print('["debug"]["bored"]: start task')
		end
		if i == "camping" then
			print('["debug"]["camping"]: start task')
			
			pcall(function()
				while wait() do
					repeat wait()
					until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["camping"])
				end
			end)
			
			print('["debug"]["camping"]: start task')
		end
		if i == "beach_party" then
			print('["debug"]["beach_party"]: start task')
			
			pcall(function()
				while wait() do
					repeat wait()
					until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["beach_party"])
				end
			end)
			
			print('["debug"]["beach_party"]: start task')
		end
		if i == "pizza_party" then
			print('["debug"]["pizza_party"]: start task')
			
			pcall(function()
				while wait() do
					repeat wait()
					until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["pizza_party"])
				end
			end)
			
			print('["debug"]["pizza_party"]: start task')
		end
		if i == "salon" then
			print('["debug"]["salon"]: start task')
			
			pcall(function()
				while wait() do
					repeat wait()
					until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["salon"])
				end
			end)
			
			print('["debug"]["salon"]: start task')
		end
		if i == "mystery" then
			print('["debug"]["mystery"]: start task')
			
			pcall(function()
				while wait() do
					repeat wait()
					until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["mystery"])
				end
			end)
			
			print('["debug"]["mystery"]: start task')
		end
		if i == "school" then
			print('["debug"]["school"]: start task')
			
			pcall(function()
				while wait() do
					repeat wait()
					until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["school"])
				end
			end)
			
			print('["debug"]["school"]: start task')
		end
		if i == "dirty" then
			print('["debug"]["dirty"]: start task')
			
			pcall(function()
				while wait() do
					repeat wait()
					until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["dirty"])
				end
			end)
			
			print('["debug"]["dirty"]: start task')
		end
		if i == "sleepy" then
			print('["debug"]["sleepy"]: start task')
			
			pcall(function()
				while wait() do
					repeat wait()
					until not (ClientData.get_data()[LocalPlayer.Name].ailments_manager.ailments[ClientData.get_data()[LocalPlayer.Name].pet_char_wrappers[1].pet_unique]["sleepy"])
				end
			end)
			
			print('["debug"]["sleepy"]: start task')
		end
	end
end

--loadstring(game:HttpGet("https://raw.githubusercontent.com/Reellzz/Reellzz/refs/heads/main/tst"))()
