local player = ...
local pn = ToEnumShortString(player)

local has_les_paul = false
for relic in ivalues(ECS.Player.Relics) do
	if relic.name == "Les Paul" then
		has_les_paul = true
		break
	end
end

has_les_paul = true

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
local last_status = "Ready"

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
	local beat, measure = GetCurrentMeasure()

	if star_power_active and beat >= star_power_end_beat then
		star_power_active = false
		last_status = "Star power ended"
	end

	while section_index <= #section_starts and section_starts[section_index] <= measure do
		active_sections[#active_sections + 1] = {end_measure=section_starts[section_index] + phrase_measures}
		last_status = "Phrase started at measure "..section_starts[section_index]
		section_index = section_index + 1
	end

	for i = #active_sections, 1, -1 do
		if measure >= active_sections[i].end_measure then
			table.remove(active_sections, i)
			star_power_sections = math.min(2, star_power_sections + 1)
			if star_power_active then star_power_end_beat = star_power_end_beat + phrase_beats end
			SOUND:PlayOnce(THEME:GetPathG("", "_ECS/staravailable.ogg"))
			last_status = "Phrase complete"
		end
	end

	SetPhraseStealth(#active_sections > 0)
	local display_color = star_power_active and color("#3A9DFF")
		or (#active_sections > 0 and color("#FFFF00"))
		or Color.White
	self:GetChild("LesPaulLane"):diffuse(display_color)
	self:GetChild("LesPaulBackground"):diffuse(display_color)

	local star_text = star_power_active and ("Active ("..math.max(0, math.ceil((star_power_end_beat - beat) / beats_per_measure)).." measures)")
		or (star_power_sections.."/2 sections")
	local phrase_text = #active_sections > 0 and ("Combo section: "..math.max(0, active_sections[1].end_measure - measure).." measures left")
		or "No combo section"
	self:GetChild("LesPaulDebug"):settext(
		"Star power: "..star_text.."  |  Points: "..ECS.Player.LesPaulPoints..
		"\n"..phrase_text.."  |  "..last_status
	)
end

local InputHandler = function(event)
	local button = event.GameButton or event.button
	if event.PlayerNumber ~= player or event.type ~= "InputEventType_FirstPress" or button ~= "Start" then
		return false
	end

	if star_power_sections > 0 and not star_power_active then
		local beat = GetCurrentMeasure()
		star_power_sections = 0
		star_power_active = true
		star_power_end_beat = beat + star_power_beats
		SOUND:PlayOnce(THEME:GetPathG("", "_ECS/staractive.ogg"))
		last_status = "Star power activated"
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
		if params.Player ~= player or IsAutoplay(player) then return end

		local broke_combo = BreaksCombo(params)
		if star_power_active and params.TapNoteScore then
			local tap_score = ToEnumShortString(params.TapNoteScore)
			if tap_score ~= "Miss" and tap_score ~= "HitMine" then
				ECS.Player.LesPaulPoints = ECS.Player.LesPaulPoints + 3 * CountNotes(params.Notes)
			end
		end

		if broke_combo then
			local in_phrase = #active_sections > 0
			if in_phrase then
				active_sections = {}
				SetPhraseStealth(false)
				last_status = "Phrase canceled"
			end
			if in_phrase or star_power_active then
				SOUND:PlayOnce(THEME:GetPathG("", "_ECS/badnote.ogg"))
			end
		end
	end,
	OffCommand=function(self)
		SetPhraseStealth(false)
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
	LoadFont("Common Normal")..{
		Name="LesPaulDebug",
		InitCommand=function(self)
			self:xy(_screen.cx, _screen.cy):wrapwidthpixels(_screen.w - 40):horizalign(center):diffuse(Color.Yellow)
		end,
	},
}

return af
