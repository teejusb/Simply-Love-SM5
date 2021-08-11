local path = "/"..THEME:GetCurrentThemeDirectory().."Graphics/_FallbackBanners/"..ThemePrefs.Get("VisualStyle")
local banner_directory = FILEMAN:DoesFileExist(path) and path or THEME:GetPathG("","_FallbackBanners/Arrows")

local SongOrCourse, banner

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
	InitCommand=function(self) self:setsize(418,164) end,

	CurrentSongChangedMessageCommand=function(self) self:playcommand("Set") end,
	CurrentCourseChangedMessageCommand=function(self) self:playcommand("Set") end,

	SetCommand=function(self)
		-- if ShowBanners preference is false, always just show the fallback banner
		-- don't bother assessing whether to draw or not draw
		if PREFSMAN:GetPreference("ShowBanners") == false then return end

		SongOrCourse = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse() or GAMESTATE:GetCurrentSong()
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
			banner = SCREENMAN:GetTopScreen():GetChild('Banner')
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
	local group_name = song:GetGroupName()
	if (group_name ~= "ECS9 - Upper" and
		group_name ~= "ECS9 - Lower" and 
		group_name ~= "ECS9 - Upper Marathon") then
		self:settext("Min Song Points:")
		return
	end
	local song_info = PlayerIsUpper() and ECS.SongInfo.Upper or ECS.SongInfo.Lower
	local song_name = song:GetDisplayFullTitle()
	local song_data = FindEcsSong(song_name, song_info)
	if song_data == nil then
		self:settext("Min Song Points:")
		return
	end
	self:settext("Min Song Points: " .. tostring(song_data.dp + song_data.ep + song_data.rp))
end

-- ECS Information
t[#t+1] = Def.ActorFrame{
	InitCommand=function(self)
		self:addx(-170):addy(-60)
		if ECS.Mode ~= "ECS" then
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
		if ((group_name == "ECS9 - Upper" and PlayerIsUpper()) or
			(group_name == "ECS9 - Lower" and not PlayerIsUpper())) then
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
	Def.Sprite{
		Texture=THEME:GetPathG("", "_relics/slimebadge.png"),
		InitCommand=function(self)
			self:zoom(0.4):addx(320):addy(100)
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

			self:visible(relic_used)
		end,
	},
	Def.Sprite{
		Texture=THEME:GetPathG("", "_relics/agilitypotion.png"),
		InitCommand=function(self)
			self:zoom(0.4):addx(170):addy(100)
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
			self:visible(relic_used)
		end,
	},
	Def.Sprite{
		Texture=THEME:GetPathG("", "_relics/staminapotion.png"),
		InitCommand=function(self)
			self:zoom(0.4):addx(20):addy(100)
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
			self:visible(relic_used)
		end,
	},
}
return t