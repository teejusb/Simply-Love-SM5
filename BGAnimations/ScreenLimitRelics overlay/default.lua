local mpn = GAMESTATE:GetMasterPlayerNumber()
local profile_name = PROFILEMAN:GetPlayerName(mpn)

-- generate a table of possible/valid relics for the player to choose from
local player_relics = {}

-- These loops should be consistent with the LimitRelics OptionRow in the Overrides table since we'll use
-- the returned index to quickly fetch all the relevant Relic information, instead of needing to loop over
-- ECS.Relics and searching for the matching name.
for i,player_relic in ipairs(ECS.Players[profile_name].relics) do
	for master_relic in ivalues(ECS.Relics) do
		if master_relic.name == player_relic.name then
			if not master_relic.is_consumable or player_relic.quantity > 0 then
				if ECS.Mode == "ECS8" and not master_relic.is_marathon then
					player_relics[#player_relics+1] = {
						name=master_relic.name,
						quantity=player_relic.quanity,
						is_consumable=master_relic.is_consumable,
						desc=master_relic.desc,
						effect=master_relic.effect,
						action=master_relic.action
					}
				end
			end
		end
	end
end

local t = Def.ActorFrame{
	InitCommand=function(self)
		if IsUsingWideScreen() then self:x(110) end
	end,
	OnCommand=function(self)
	end,
	OffCommand=function(self)
	end,
	TransitionBackCommand=function(self)
		SCREENMAN:GetTopScreen():PostScreenMessage("SM_GoToPrevScreen",0)
	end,
	RelicActivatedMessageCommand=function(self, params)
	end,
	-- fade out when exiting the screen
	Def.Quad{
		InitCommand=function(self)
			self:FullScreen():diffuse(0,0,0,0)
			if IsUsingWideScreen() then self:Center():addx(-110) end
		end,
		OffCommand=function(self) self:sleep(0.3):linear(0.55):diffusealpha(1) end
	}
}

t[#t+1] = LoadActor("./pane.lua")

-- ---------------------------------------------------------------------
return t