local player = ...
local pn = ToEnumShortString(player)

-- if the conditions aren't right, don't bother
if SL[pn].ActiveModifiers.DataVisualizations ~= "Step Statistics"
or GAMESTATE:GetCurrentStyle():GetName() ~= "single"
or SL.Global.GameMode == "Casual"
or (PREFSMAN:GetPreference("Center1Player") and not IsUsingWideScreen())
then
	return
end

-- -----------------------------------------------------------------------

local header_height   = 80
local notefield_width = GetNotefieldWidth()
local sidepane_width  = _screen.w/2
local sidepane_pos_x  = _screen.w * (player==PLAYER_1 and 0.75 or 0.25)

if (PREFSMAN:GetPreference("Center1Player") and IsUsingWideScreen()) then
	sidepane_width = (_screen.w - GetNotefieldWidth()) / 2

	if player==PLAYER_1 then
		sidepane_pos_x = _screen.cx + notefield_width + (sidepane_width-notefield_width)/2
	else
		sidepane_pos_x = _screen.cx - notefield_width - (sidepane_width-notefield_width)/2
	end
end

-- -----------------------------------------------------------------------

local af = Def.ActorFrame{}
af.InitCommand=function(self)
	self:x(sidepane_pos_x):y(_screen.cy + header_height)
end

af[#af+1] = LoadActor("./DarkBackground.lua", {player, header_height, sidepane_width})

-- banner, judgment labels, and judgment numbers will be collectively shrunk
-- if Center1Player is enabled to accommodate the smaller space
af[#af+1] = Def.ActorFrame{
	InitCommand=function(self)
		if (PREFSMAN:GetPreference("Center1Player") and IsUsingWideScreen()) then
			local zoomfactor = {
				sixteen_ten  = 0.825,
				sixteen_nine = 0.925
			}
			local zoom = scale(GetScreenAspectRatio(), 16/10, 16/9, zoomfactor.sixteen_ten, zoomfactor.sixteen_nine)
			-- handle aspect ratios wider than 16:9 (e.g. 21:9) by clamping zoom
			zoom = clamp(zoom, zoomfactor.sixteen_ten, zoomfactor.sixteen_nine )
			self:zoom( zoom )
		end
	end,

	LoadActor("./Banner.lua", player),
	LoadActor("./JudgmentLabels.lua", player),
	LoadActor("./JudgmentNumbers.lua", player),
}

af[#af+1] = LoadActor("./DensityGraph.lua", {player, sidepane_width})

return af