local groups = {
	{
		{label="Get 0 misses", kind="misses", value=0},
		{label="Get 5 misses or less", kind="misses", value=5},
		{label="Get 10 misses or less", kind="misses", value=10},
		{label="Get 25 misses or less", kind="misses", value=25},
		{label="Get 50 misses or less", kind="misses", value=50},
		{label="Get 100 misses or less", kind="misses", value=100},
	},
	{
		{label="Get 0 greats", kind="greats", value=0},
		{label="Get 5 greats or less", kind="greats", value=5},
		{label="Get 10 greats or less", kind="greats", value=10},
		{label="Get 25 greats or less", kind="greats", value=25},
		{label="Get 50 greats or less", kind="greats", value=50},
		{label="Get 100 greats or less", kind="greats", value=100},
	},
	{
		{label="Get a 75% or above", kind="percent", value=75},
		{label="Get an 80% or above", kind="percent", value=80},
		{label="Get an 85% or above", kind="percent", value=85},
		{label="Get a 90% or above", kind="percent", value=90},
		{label="Get a 95% or above", kind="percent", value=95},
		{label="Get a 99% or above", kind="percent", value=99},
	},
	{
		{label="Play on 0% Mini", kind="mini", value=0},
		{label="Play on 25% Mini", kind="mini", value=25},
		{label="Play on 50% Mini", kind="mini", value=50},
		{label="Play on 75% Mini", kind="mini", value=75},
		{label="Play on 100% Mini", kind="mini", value=100},
		{label="Play on -25% Mini", kind="mini", value=-25},
		{label="Play on -50% Mini", kind="mini", value=-50},
		{label="Play on -75% Mini", kind="mini", value=-75},
		{label="Play on -100% Mini", kind="mini", value=-100},
	},
	{
		{label="Play on Overhead", kind="perspective", mod="Overhead"},
		{label="Play on Hallway", kind="perspective", mod="Hallway"},
		{label="Play on Distant", kind="perspective", mod="Distant"},
		{label="Play on Incoming", kind="perspective", mod="Incoming"},
		{label="Play on Space", kind="perspective", mod="Space"},
	},
	{
		{label="Play on Mirror", kind="turn", mod="Mirror"},
		{label="Play on Left", kind="turn", mod="Left"},
		{label="Play on Right", kind="turn", mod="Right"},
		{label="Play on LR-Mirror", kind="turn", mod="LRMirror"},
		{label="Play on UD-Mirror", kind="turn", mod="UDMirror"},
		{label="Play on Shuffle", kind="turn", mod="Shuffle"},
		{label="Play on Blender", kind="turn", mod="Blender"},
		{label="Play on Random", kind="turn", mod="Random"},
	},
	{
		{label="Play on Reverse", kind="scroll", mod="Reverse"},
		{label="Play on Alternate", kind="scroll", mod="Alternate"},
		{label="Play on Cross", kind="scroll", mod="Cross"},
		{label="Play on Centered", kind="scroll", mod="Centered"},
	},
}

local contracts = {}
local focus = 1
local screen

local FormatBreakTime = function(seconds)
	seconds = math.max(0, seconds)
	return string.format("%02d:%02d", math.floor(seconds / 60), math.floor(seconds % 60))
end

local Refresh = function()
	for i, contract in ipairs(contracts) do
		local actor = screen:GetChild("Contract"..i)
		actor:settext((focus == i and "> " or "  ")..contract.label)
		actor:diffuse(contract.selected and color("#00ff00") or color("#ff4040"))
	end
	local start = screen:GetChild("ContractStart")
	start:settext(focus == 5 and "> START" or "  START")
	start:diffuse(focus == 5 and color("#ffff00") or color("#ffffff"))
end

local ApplySelectedMods = function()
	local player = GAMESTATE:GetMasterPlayerNumber()
	local player_state = GAMESTATE:GetPlayerState(player)
	ECS.Player.ContraktOriginalPlayerOptionsString = player_state:GetPlayerOptionsString("ModsLevel_Preferred")
	local mods = {
		Overhead="overhead", Hallway="hallway", Distant="distant", Incoming="incoming", Space="space",
		Mirror="mirror", Left="left", Right="right", LRMirror="lrmirror", UDMirror="udmirror",
		Shuffle="shuffle", Blender="supershuffle", Random="hypershuffle",
		Reverse="reverse", Alternate="alternate", Cross="cross", Centered="centered",
	}
	for contract in ivalues(contracts) do
		if contract.selected then
			if contract.kind == "perspective" then
				GAMESTATE:ApplyGameCommand("mod,overhead", player)
			elseif contract.kind == "turn" then
				GAMESTATE:ApplyGameCommand("mod,no turn", player)
			elseif contract.kind == "scroll" then
				GAMESTATE:ApplyGameCommand("mod,no reverse,no split,no alternate,no cross,no centered", player)
			end
		end
	end
	for contract in ivalues(contracts) do
		if contract.selected then
			if contract.kind == "mini" then
				GAMESTATE:ApplyGameCommand("mod,"..contract.value.."% mini", player)
			elseif contract.kind == "perspective" or contract.kind == "turn" or contract.kind == "scroll" then
				GAMESTATE:ApplyGameCommand("mod,"..mods[contract.mod], player)
			end
		end
	end
end

local InputHandler = function(event)
	if event.PlayerNumber ~= GAMESTATE:GetMasterPlayerNumber() or event.type ~= "InputEventType_FirstPress" then return false end
	if event.button == "Left" or event.button == "MenuLeft" then
		focus = (focus - 2) % 5 + 1
		Refresh()
	elseif event.button == "Right" or event.button == "MenuRight" then
		focus = focus % 5 + 1
		Refresh()
	elseif event.button == "Start" then
		if focus == 5 then
			ApplySelectedMods()
			ECS.Player.ContraktPlaying = true
			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
		else
			contracts[focus].selected = not contracts[focus].selected
			Refresh()
		end
	elseif event.button == "Back" then
		SCREENMAN:GetTopScreen():PostScreenMessage("SM_GoToPrevScreen", 0)
	end
	return false
end

local t = Def.ActorFrame{
	Name="ContraktScreen",
	InitCommand=function(self)
		screen = self
		self:queuecommand("Setup")
	end,
	SetupCommand=function(self)
		self:SetUpdateFunction(function(actor)
			actor:GetChild("ContractTimer"):settext("Break time left: "..FormatBreakTime(ECS.BreakTimer))
		end)
		local group_indices = {1,2,3,4,5,6,7}
		for i=#group_indices,2,-1 do
			local j = math.random(i)
			group_indices[i], group_indices[j] = group_indices[j], group_indices[i]
		end
		contracts = {}
		for i=1,4 do
			local group = groups[group_indices[i]]
			local contract = group[math.random(#group)]
			contract.selected = true
			contracts[i] = contract
		end
		ECS.Player.ContraktOptions = contracts
		focus = 1
		Refresh()
		SCREENMAN:GetTopScreen():AddInputCallback(InputHandler)
	end,
	Def.Quad{
		InitCommand=function(self) self:FullScreen():diffuse(Color.Black):diffusealpha(0.85) end,
	},
	Def.Quad{
		InitCommand=function(self) self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y):zoomto(760, 470):diffuse(Color.Black) end,
	},
	LoadFont("Common Normal")..{
		InitCommand=function(self) self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y-190):zoom(1.3):settext("Contrakt") end,
	},
	LoadFont("Common Normal")..{
		InitCommand=function(self) self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y-145):settext("Select which obligations to accept") end,
	},
}

for i=1,4 do
	local index = i
	t[#t+1] = LoadFont("Common Normal")..{
		Name="Contract"..index,
		InitCommand=function(self) self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y-85 + (index-1)*58):zoom(0.9) end,
	}
end

t[#t+1] = LoadFont("Common Normal")..{
	Name="ContractStart",
	InitCommand=function(self) self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y+155):zoom(1.2) end,
}
t[#t+1] = LoadFont("Common Normal")..{
	InitCommand=function(self)
		self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y+200):zoom(0.75):settext("&LEFT; / &RIGHT; to navigate   &START; to toggle / begin")
	end,
}
t[#t+1] = LoadFont("Common Normal")..{
	Name="ContractTimer",
	InitCommand=function(self) self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y+225):zoom(0.75):settext("Break time left: "..FormatBreakTime(ECS.BreakTimer)) end,
}

return t
