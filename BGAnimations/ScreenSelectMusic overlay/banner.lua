local path = "/"..THEME:GetCurrentThemeDirectory().."Graphics/_FallbackBanners/"..ThemePrefs.Get("VisualStyle")
local banner_directory = FILEMAN:DoesFileExist(path) and path or THEME:GetPathG("","_FallbackBanners/Arrows")

local SongOrCourse = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse() or GAMESTATE:GetCurrentSong()

local bannerWidth = 418
local bannerHeight = 164

local t = Def.ActorFrame{
	OnCommand=function(self)
		if IsUsingWideScreen() then
			self:zoom(0.7655)
			self:xy(_screen.cx - 170, 96)
		else
			self:zoom(0.75)
			self:xy(_screen.cx - 166, 96)
		end
	end
}

-- fallback banner
t[#t+1] = Def.Sprite{
	Name="FallbackBanner",
	Texture=banner_directory.."/banner"..SL.Global.ActiveColorIndex.." (doubleres).png",
	InitCommand=function(self) self:setsize(bannerWidth, bannerHeight) end,

	CurrentSongChangedMessageCommand=function(self) self:playcommand("Set") end,
	CurrentCourseChangedMessageCommand=function(self) self:playcommand("Set") end,

	SetCommand=function(self)
		-- if ShowBanners preference is false, always just show the fallback banner
		-- don't bother assessing whether to draw or not draw
		if PREFSMAN:GetPreference("ShowBanners") == false then return end

		if SongOrCourse and SongOrCourse:HasBanner() then
			self:visible(false)
		else
			self:visible(true)
		end
	end
}

if PREFSMAN:GetPreference("ShowBanners") then
	t[#t+1] = Def.ActorProxy{
		Name="BannerProxy",
		BeginCommand=function(self)
			local banner = SCREENMAN:GetTopScreen():GetChild('Banner')
			self:SetTarget(banner)
		end
	}
end

-- the MusicRate Quad and text
t[#t+1] = Def.ActorFrame{
	InitCommand=function(self)
		self:visible( SL.Global.ActiveModifiers.MusicRate ~= 1 ):y(75)
	end,

	--quad behind the music rate text
	Def.Quad{
		InitCommand=function(self) self:diffuse( color("#1E282FCC") ):zoomto(418,14) end
	},

	--the music rate text
	LoadFont("Common Normal")..{
		InitCommand=function(self) self:shadowlength(1):zoom(0.85) end,
		OnCommand=function(self)
			self:settext(("%g"):format(SL.Global.ActiveModifiers.MusicRate) .. "x " .. THEME:GetString("OptionTitles", "MusicRate"))
		end
	}
}

local SetSongPointText = function(self)
	local song = GAMESTATE:GetCurrentSong()

	if song == nil then
		self:settext("Min Song Points:")
		return
	end

	if not IsPlayingFromPackForDivision(song) then
		self:settext("Min Song Points:")
		return
	end

	local song_info = nil

	if ECS.Mode == "Speed" then
		song_info = ECS.SongInfo.Speed
	elseif GetDivision() == "upper" then
		song_info = ECS.SongInfo.Upper
	elseif GetDivision() == "mid" then
		song_info = ECS.SongInfo.Mid
	else
		song_info = ECS.SongInfo.Lower
	end

	local song_name = song:GetDisplayFullTitle()
	local song_data = FindEcsSong(song_name, song_info)
	if song_data == nil then
		self:settext("Min Song Points:")
		return
	end

	score, _ = CalculateScoreForSong(ECS.Players[PROFILEMAN:GetPlayerName(GAMESTATE:GetMasterPlayerNumber())], song_name, 0, {}, false)
	self:settext("Min Song Points: " .. tostring(score))
end

-- ECS Information
t[#t+1] = Def.ActorFrame{
	InitCommand=function(self)
		self:addx(-175):addy(-60)
		if ECS.Mode ~= "ECS" or ECS.Mode ~= "Speed" then
			self:visible(false)
		end
	end,
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song == nil then
			self:visible(false)
			return
		end
		local group_name = song:GetGroupName()
		if IsPlayingFromPackForDivision() then
			self:visible(true)
		else
			self:visible(false)
		end
	end,
	Def.Quad{
		InitCommand=function(self) self:diffuse(color("#000000AA")):zoomto(370, 80):addx(175):addy(20) end
	},
	LoadFont("Common Normal")..{
		InitCommand=function(self) self:shadowlength(1):zoom(2):horizalign(left) end,
		OnCommand=function(self)
			local total_points = 0
			for i=1,7 do
				if ECS.Player.SongsPlayed[i] ~= nil then
					total_points = total_points + ECS.Player.SongsPlayed[i].points
				end
			end
			self:settext("Total Set Points: " .. tostring(total_points))
		end
	},
	LoadFont("Common Normal")..{
		InitCommand=function(self) self:shadowlength(1):zoom(2):addy(30):horizalign(left) end,
		OnCommand=SetSongPointText,
		CurrentSongChangedMessageCommand=SetSongPointText,
	},
	Def.Quad{
		Name="EndOfSetBg",
		InitCommand=function(self) self:diffuse(color("#ffffffaa")):zoomto(410, 80):addx(175):addy(100):visible(false) end
	},
	Def.Sprite{
		Texture=THEME:GetPathG("", "_relics/slimebadge.png"),
		InitCommand=function(self)
			self:zoom(0.28):addx(-8):addx(0):addy(100)
		end,
		OnCommand=function(self)
			local relic_used = false
			for i=1,7 do
				local song_played = ECS.Player.SongsPlayed[i]
				if song_played ~= nil and not song_played.failed then
					for relic in ivalues(song_played.relics_used) do
						if relic.name == "Slime Badge" then
							relic_used = true
						end
					end
				end
			end
			if relic_used then self:GetParent():GetChild("EndOfSetBg"):visible(true) end
			self:visible(relic_used)
		end,
	},
	Def.Sprite{
		Texture=THEME:GetPathG("", "_relics/agilitypotion.png"),
		InitCommand=function(self)
			self:zoom(0.28):addx(-8):addx(40):addy(100)
		end,
		OnCommand=function(self)
			local relic_used = false
			for i=1,7 do
				local song_played = ECS.Player.SongsPlayed[i]
				if song_played ~= nil and not song_played.failed then
					for relic in ivalues(song_played.relics_used) do
						if relic.name == "Agility Potion" then
							relic_used = true
						end
					end
				end
			end
			if relic_used then self:GetParent():GetChild("EndOfSetBg"):visible(true) end
			self:visible(relic_used)
		end,
	},
	Def.Sprite{
		Texture=THEME:GetPathG("", "_relics/staminapotion.png"),
		InitCommand=function(self)
			self:zoom(0.28):addx(-8):addx(80):addy(100)
		end,
		OnCommand=function(self)
			local relic_used = false
			for i=1,7 do
				local song_played = ECS.Player.SongsPlayed[i]
				if song_played ~= nil and not song_played.failed then
					for relic in ivalues(song_played.relics_used) do
						if relic.name == "Stamina Potion" then
							relic_used = true
						end
					end
				end
			end
			if relic_used then self:GetParent():GetChild("EndOfSetBg"):visible(true) end
			self:visible(relic_used)
		end,
	},
	Def.Sprite{
		Texture=THEME:GetPathG("", "_relics/accuracypotion.png"),
		InitCommand=function(self)
			self:zoom(0.28):addx(-8):addx(120):addy(100)
		end,
		OnCommand=function(self)
			local relic_used = false
			for i=1,7 do
				local song_played = ECS.Player.SongsPlayed[i]
				if song_played ~= nil and not song_played.failed then
					for relic in ivalues(song_played.relics_used) do
						if relic.name == "Accuracy Potion" then
							relic_used = true
						end
					end
				end
			end
			if relic_used then self:GetParent():GetChild("EndOfSetBg"):visible(true) end
			self:visible(relic_used)
		end,
	},
	Def.Sprite{
		Texture=THEME:GetPathG("", "_relics/tpastandard.png"),
		InitCommand=function(self)
			self:zoom(0.28):addx(-8):addx(160):addy(100)
		end,
		OnCommand=function(self)
			local relic_used = false
			for i=1,7 do
				local song_played = ECS.Player.SongsPlayed[i]
				if song_played ~= nil and not song_played.failed then
					for relic in ivalues(song_played.relics_used) do
						if relic.name == "TPA Standard" then
							relic_used = true
						end
					end
				end
			end
			if relic_used then self:GetParent():GetChild("EndOfSetBg"):visible(true) end
			self:visible(relic_used)
		end,
	},
	Def.Sprite{
		Texture=THEME:GetPathG("", "_relics/memepeaceberet.png"),
		InitCommand=function(self)
			self:zoom(0.28):addx(-8):addx(200):addy(100)
		end,
		OnCommand=function(self)
			local relic_used = false
			for i=1,7 do
				local song_played = ECS.Player.SongsPlayed[i]
				if song_played ~= nil and not song_played.failed then
					for relic in ivalues(song_played.relics_used) do
						if relic.name == "Memepeace Beret" then
							relic_used = true
						end
					end
				end
			end
			if relic_used then self:GetParent():GetChild("EndOfSetBg"):visible(true) end
			self:visible(relic_used)
		end,
	},
	Def.Sprite{
		Texture=THEME:GetPathG("", "_relics/exjam09.png"),
		InitCommand=function(self)
			self:zoom(0.28):addx(-8):addx(240):addy(100)
		end,
		OnCommand=function(self)
			local relic_used = false
			for i=1,7 do
				local song_played = ECS.Player.SongsPlayed[i]
				if song_played ~= nil and not song_played.failed then
					for relic in ivalues(song_played.relics_used) do
						if relic.name == "ExJam09" then
							relic_used = true
						end
					end
				end
			end
			if relic_used then self:GetParent():GetChild("EndOfSetBg"):visible(true) end
			self:visible(relic_used)
		end,
	},
	Def.Sprite{
		Texture=THEME:GetPathG("", "_relics/jarofpickles.png"),
		InitCommand=function(self)
			self:zoom(0.28):addx(-8):addx(280):addy(100)
		end,
		OnCommand=function(self)
			local relic_used = false
			for i=1,7 do
				local song_played = ECS.Player.SongsPlayed[i]
				if song_played ~= nil and not song_played.failed then
					for relic in ivalues(song_played.relics_used) do
						if relic.name == "Jar of Pickles" then
							relic_used = true
						end
					end
				end
			end
			if relic_used then self:GetParent():GetChild("EndOfSetBg"):visible(true) end
			self:visible(relic_used)
		end,
	},
	Def.Sprite{
		Texture=THEME:GetPathG("", "_relics/meteorite.png"),
		InitCommand=function(self)
			self:zoom(0.28):addx(-8):addx(320):addy(100)
		end,
		OnCommand=function(self)
			local relic_used = false
			for i=1,7 do
				local song_played = ECS.Player.SongsPlayed[i]
				if song_played ~= nil and not song_played.failed then
					for relic in ivalues(song_played.relics_used) do
						if relic.name == "Meteorite" then
							relic_used = true
						end
					end
				end
			end
			if relic_used then self:GetParent():GetChild("EndOfSetBg"):visible(true) end
			self:visible(relic_used)
		end,
	},
	Def.Sprite{
		Texture=THEME:GetPathG("", "_relics/despotschapeau.png"),
		InitCommand=function(self)
			self:zoom(0.28):addx(-8):addx(360):addy(100)
		end,
		OnCommand=function(self)
			local relic_used = false
			for i=1,7 do
				local song_played = ECS.Player.SongsPlayed[i]
				if song_played ~= nil and not song_played.failed then
					for relic in ivalues(song_played.relics_used) do
						if relic.name == "Despot's Chapeau" then
							relic_used = true
						end
					end
				end
			end
			if relic_used then self:GetParent():GetChild("EndOfSetBg"):visible(true) end
			self:visible(relic_used)
		end,
	},
}

if not GAMESTATE:IsCourseMode() then
	t[#t+1] = Def.Sprite {
		OnCommand=function(self)
			self:draworder(101)
			self:playcommand("SetCD")
		end,
		OffCommand=function(self)
			self:bouncebegin(0.15)
		end,
		CurrentSongChangedMessageCommand=function(self) self:playcommand("SetCD") end,
		SwitchFocusToGroupsMessageCommand=function(self) self:GetChild("CdTitle"):visible(false) end,
		SetCDCommand=function(self)
			SongOrCourse = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse() or GAMESTATE:GetCurrentSong()
			if SongOrCourse and SongOrCourse:HasCDTitle() then
				self:visible(true)
				self:Load( GAMESTATE:GetCurrentSong():GetCDTitlePath() )
				local dim1, dim2 = math.max(self:GetWidth(), self:GetHeight()), math.min(self:GetWidth(), self:GetHeight())
				local ratio = math.max(dim1 / dim2, 2.5)

				local toScale = self:GetWidth() > self:GetHeight() and self:GetWidth() or self:GetHeight()
				self:xy((bannerWidth - 30) / 2, (bannerHeight - 30)/ 2)
				self:zoom(22 / toScale * ratio)
				self:finishtweening():addrotationy(0):linear(.5):addrotationy(360)
			else
				self:visible(false)
			end
		end
	}
end

return t