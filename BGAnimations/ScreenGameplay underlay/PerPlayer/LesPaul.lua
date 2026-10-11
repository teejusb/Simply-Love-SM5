local player = ...
local pn = ToEnumShortString(player)

local has_les_paul = false
for relic in ivalues(ECS.Player.Relics) do
	if relic.name == "Les Paul" then
		has_les_paul = true
		break
	end
end

if not has_les_paul then return Def.ActorFrame{} end

local mods = SL[pn].ActiveModifiers
local original_settings = ECS.Player.LesPaulOriginalSettings[pn]
if not original_settings then
	original_settings = {DataVisualizations=mods.DataVisualizations}
	ECS.Player.LesPaulOriginalSettings[pn] = original_settings
end
mods.DataVisualizations = "None"

local section_percentages = {10, 40, 70}
local beats_per_measure = 4
local phrase_measures = 4
local phrase_beats = beats_per_measure * phrase_measures
local star_power_beats = beats_per_measure * 4
local max_star_power_beats = star_power_beats * 2
local is_double = GAMESTATE:GetCurrentStyle():GetName() == "double"
local display_x = is_double and (player == PLAYER_1 and 60 or _screen.w - 60) or _screen.cx
local prompt_x = is_double and (player == PLAYER_1 and 100 or _screen.w - 100) or display_x
local prompt_y = _screen.h * 0.70
local meter_width = 32
local meter_height = 128
local meter_x = display_x
local meter_bottom = _screen.h - 110
local steps = GAMESTATE:GetCurrentSteps(player)
ParseChartInfo(steps, pn)
local total_measures = #SL[pn].Streams.NotesPerMeasure
local section_starts = {}

for _, percentage in ipairs(section_percentages) do
	local measure = math.floor((total_measures - 1) * percentage / 100 + 0.5)
	if measure >= 0 and measure + phrase_measures <= total_measures then
		if section_starts[#section_starts] ~= measure then
			section_starts[#section_starts + 1] = measure
		end
	end
end

local player_state = GAMESTATE:GetPlayerState(player)
local player_options = player_state:GetPlayerOptions("ModsLevel_Song")
local original_stealth = player_options:Stealth()
local stealth_active = false
local section_index = 1
local active_sections = {}
local star_power_sections = 0
local star_power_active = false
local star_power_end_beat = 0
local relic_failed = false

local SetPhraseStealth = function(enabled)
	if stealth_active == enabled then return end
	stealth_active = enabled
	player_options:Stealth(enabled and 0.5 or original_stealth, 100)
end

local RestoreLesPaulSettings = function()
	local original = ECS.Player.LesPaulOriginalSettings[pn]
	if not original then return end

	for key, value in pairs(original) do
		if key ~= "PlayerMini" and key ~= "Reverse" then
			SL[pn].ActiveModifiers[key] = value
		end
	end
	player_options:Mini(original.PlayerMini)
	player_options:Reverse(original.Reverse)
	ECS.Player.LesPaulOriginalSettings[pn] = nil
end

local IsPlayerFailed = function()
	local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)
	local life_meter = SCREENMAN:GetTopScreen():GetLifeMeter(player)
	return pss:GetFailed() or (life_meter and life_meter:IsFailing()) or false
end

local DisableRelicOnFail = function(self)
	if relic_failed then return end
	relic_failed = true
	ECS.Player.LesPaulPoints = 0
	active_sections = {}
	star_power_sections = 0
	star_power_active = false
	SetPhraseStealth(false)
	self:GetChild("LesPaulLane"):diffuse(Color.White)
	self:GetChild("LesPaulBackground"):diffuse(Color.White)
	self:GetChild("StarPowerMeterFill"):setsize(meter_width - 10, 0)
	self:GetChild("LesPaulPoints"):settext("")
	self:GetChild("StarPowerPrompt"):visible(false)
	self:GetChild("StarPowerPromptBackdrop"):visible(false)
	self:GetChild("UpcomingSection"):visible(false)
	self:GetChild("CountdownBackdrop"):visible(false)
end

local GetCurrentMeasure = function()
	local beat = player_state:GetSongPosition():GetSongBeatVisible()
	return beat, math.floor(beat / beats_per_measure)
end

local CountNotes = function(notes)
	local count = 0
	for _, note in pairs(notes or {}) do
		local note_type = ToEnumShortString(note:GetTapNoteType())
		if note_type == "Tap" or note_type == "HoldHead" or note_type == "Lift" then
			count = count + 1
		end
	end
	return count
end

local BreaksCombo = function(params)
	if params.HoldNoteScore then
		local hold_score = ToEnumShortString(params.HoldNoteScore)
		if hold_score == "LetGo" or hold_score == "MissedHold" then return true end
	end

	if not params.TapNoteScore then return false end
	local tap_score = ToEnumShortString(params.TapNoteScore)
	if tap_score == "Miss" then return true end

	local score_window = tonumber(tap_score:match("W(%d+)"))
	local maintain_window = tonumber(GetComboThreshold("Maintain"):match("W(%d+)"))
	return score_window and maintain_window and score_window > maintain_window or false
end

local Update = function(self)
	if relic_failed then return end
	if IsPlayerFailed() then
		DisableRelicOnFail(self)
		return
	end

	local beat, measure = GetCurrentMeasure()

	if star_power_active and beat >= star_power_end_beat then
		star_power_active = false
	end

	while section_index <= #section_starts and section_starts[section_index] <= measure do
		active_sections[#active_sections + 1] = {end_measure=section_starts[section_index] + phrase_measures}
		section_index = section_index + 1
	end

	for i = #active_sections, 1, -1 do
		if measure >= active_sections[i].end_measure then
			table.remove(active_sections, i)
			star_power_sections = math.min(2, star_power_sections + 1)
			if star_power_active then star_power_end_beat = star_power_end_beat + phrase_beats end
			SOUND:PlayOnce(THEME:GetPathG("", "_ECS/staravailable.ogg"))
		end
	end

	SetPhraseStealth(#active_sections > 0)
	local display_color = star_power_active and color("#3A9DFF")
		or (#active_sections > 0 and color("#FFFF00"))
		or Color.White
	self:GetChild("LesPaulLane"):diffuse(display_color)
	self:GetChild("LesPaulBackground"):diffuse(display_color)

	local remaining_beats = star_power_active and math.max(0, star_power_end_beat - beat)
		or star_power_sections * star_power_beats
	local fill_height = meter_height * math.min(1, remaining_beats / max_star_power_beats)
	local fill = self:GetChild("StarPowerMeterFill")
	fill:setsize(meter_width - 10, fill_height):xy(meter_x, meter_bottom)
	fill:diffuse(star_power_active and color("#3A9DFF") or color("#FFE000"))

	local countdown = self:GetChild("UpcomingSection")
	local countdown_backdrop = self:GetChild("CountdownBackdrop")
	local next_section = section_starts[section_index]
	if next_section then
		local timing = GAMESTATE:GetCurrentSong():GetTimingData()
		local target_seconds = timing:GetElapsedTimeFromBeat(next_section * beats_per_measure)
		local current_seconds = timing:GetElapsedTimeFromBeat(beat)
		local music_rate = SL[pn].ActiveModifiers.MusicRate or 1
		local seconds_until = (target_seconds - current_seconds) / music_rate
		if seconds_until > 0 and seconds_until <= 3 then
			countdown:settext(math.ceil(seconds_until).."...")
			countdown:visible(true)
			countdown_backdrop:visible(true)
		else
			countdown:visible(false)
			countdown_backdrop:visible(false)
		end
	else
		countdown:visible(false)
		countdown_backdrop:visible(false)
	end

	self:GetChild("LesPaulPoints"):settext("BP: "..ECS.Player.LesPaulPoints)
	local can_activate = star_power_sections > 0 and not star_power_active
	self:GetChild("StarPowerPrompt"):visible(can_activate)
	self:GetChild("StarPowerPromptBackdrop"):visible(can_activate)
end

local InputHandler = function(event)
	local button = event.GameButton or event.button
	if event.PlayerNumber ~= player or event.type ~= "InputEventType_FirstPress" or button ~= "Start" then
		return false
	end
	if relic_failed or IsPlayerFailed() then return false end

	if star_power_sections > 0 and not star_power_active then
		local beat = GetCurrentMeasure()
		local charge_beats = star_power_sections * star_power_beats
		star_power_sections = 0
		star_power_active = true
		star_power_end_beat = beat + charge_beats
		SOUND:PlayOnce(THEME:GetPathG("", "_ECS/staractive.ogg"))
	end
	return false
end

local af = Def.ActorFrame{
	OnCommand=function(self)
		local playfield = SCREENMAN:GetTopScreen():GetChild("Player"..pn)
		if playfield then playfield:rotationx(-50) end
		SCREENMAN:GetTopScreen():AddInputCallback(InputHandler)
		self:SetUpdateFunction(Update)
	end,
	JudgmentMessageCommand=function(self, params)
		if params.Player ~= player or IsAutoplay(player) or relic_failed then return end
		if IsPlayerFailed() then
			DisableRelicOnFail(self)
			return
		end

		local broke_combo = BreaksCombo(params)
		if star_power_active and params.TapNoteScore then
			local tap_score = ToEnumShortString(params.TapNoteScore)
			if tap_score ~= "Miss" and tap_score ~= "HitMine" then
				local points = 3 * CountNotes(params.Notes)
				ECS.Player.LesPaulPoints = ECS.Player.LesPaulPoints + points
			end
		end

		if broke_combo then
			local in_phrase = #active_sections > 0
			if in_phrase then
				active_sections = {}
				SetPhraseStealth(false)
			end
			if in_phrase or star_power_active then
				SOUND:PlayOnce(THEME:GetPathG("", "_ECS/badnote.ogg"))
			end
		end
	end,
	OffCommand=function(self)
		SetPhraseStealth(false)
		if IsPlayerFailed() then ECS.Player.LesPaulPoints = 0 end
		RestoreLesPaulSettings()
	end,

	Def.Sprite{
		Name="LesPaulBackground",
		Texture=THEME:GetPathG("", "_ECS/lespaul (doubleres).png"),
		InitCommand=function(self) self:Center():zoom(0.9) end,
	},
	Def.Sprite{
		Name="LesPaulLane",
		Texture=THEME:GetPathG("", "_ECS/lespaul lane (doubleres).png"),
		InitCommand=function(self)
			self:xy(GetNotefieldX(player), _screen.cy):zoom(0.9):zoomtowidth(GetNotefieldWidth() * 1.4)
		end,
	},
	Def.Quad{
		Name="StarPowerMeterBorder",
		InitCommand=function(self)
			self:xy(meter_x, meter_bottom - meter_height / 2):setsize(meter_width, meter_height + 8):diffuse(Color.White)
		end,
	},
	Def.Quad{
		Name="StarPowerMeterBackground",
		InitCommand=function(self)
			self:xy(meter_x, meter_bottom - meter_height / 2):setsize(meter_width - 8, meter_height):diffuse(color("#101820"))
		end,
	},
	Def.Quad{
		Name="StarPowerMeterFill",
		InitCommand=function(self)
			self:xy(meter_x, meter_bottom):setsize(meter_width - 10, 0):valign(1)
		end,
	},
	Def.Quad{
		Name="StarPowerMeterDivider",
		InitCommand=function(self)
			self:xy(meter_x, meter_bottom - meter_height / 2):setsize(meter_width - 8, 3):diffuse(color("#101820"))
		end,
	},
	LoadFont("Common Bold")..{
		Text="STAR POWER",
		InitCommand=function(self)
			self:xy(meter_x, meter_bottom - meter_height - 18):zoom(0.42):diffuse(Color.White):shadowlength(1)
		end,
	},
	Def.Quad{
		Name="CountdownBackdrop",
		InitCommand=function(self)
			self:xy(display_x, meter_bottom - meter_height - 42):setsize(64, 26):diffuse(color("#000000CC")):visible(false)
		end,
	},
	LoadFont("Common Bold")..{
		Name="UpcomingSection",
		InitCommand=function(self)
			self:xy(display_x, meter_bottom - meter_height - 42):zoom(0.75):diffuse(color("#FFFF66")):shadowlength(1):visible(false)
		end,
	},
	LoadFont("Common Normal")..{
		Name="LesPaulPoints",
		InitCommand=function(self)
			self:xy(meter_x, meter_bottom + 18):zoom(0.8):horizalign(center):diffuse(Color.White):shadowlength(1)
		end,
	},
	Def.Quad{
		Name="StarPowerPromptBackdrop",
		InitCommand=function(self)
			self:xy(prompt_x, prompt_y):setsize(130, 28):diffuse(color("#000000CC")):visible(false)
		end,
	},
	LoadFont("Common Normal")..{
		Name="StarPowerPrompt",
		Text="Press &START;",
		InitCommand=function(self)
			self:xy(prompt_x, prompt_y):zoom(0.85):horizalign(center):diffuse(Color.White):shadowlength(1):visible(false)
		end,
	},
}

return af
