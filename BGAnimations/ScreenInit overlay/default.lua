local quotes = {
	{
		{"I honestly wasn't sure if I'd make it through Slam.\nThis is by far the hardest thing I've passed.", -150, -10},
		{"- Zetorux, ECS1", 159, 25}
	},
	{
		{"Are you asking about my stamina cap ?", -100, -10},
		{"- aijbot", 138, 12}
	},
}

local body, author, picture
local w = 310
local quote_pics = 4
local rand_quote
-- ---------------------------------------

local af = Def.ActorFrame{
	InitCommand=function(self)
		self:Center()
		rand_quote = math.random(#quotes + quote_pics)
		if rand_quote <= quote_pics then
			picture:Load(THEME:GetPathG("", "_Mario/Quotes/" .. tostring(rand_quote)))
			body:settext("")
			author:settext("")
		else
			rand_quote = rand_quote - quote_pics
			local quote = quotes[rand_quote]
			body:settext(quote[1][1]):xy(quote[1][2],quote[1][3])
			author:settext(quote[2][1]):xy(quote[2][2],quote[2][3])
			picture:Load(nil)
		end
	end
}

-- check SM5 version, current game (dance, pump, etc.), and RTT support
af[#af+1] = LoadActor("./CompatibilityChecks.lua")

-- -----------------------------------------------------------------------

local slc = SL.Global.ActiveColorIndex

-- semitransparent black quad as background for 7 decorative arrows
af[#af+1] = Def.Quad{
	InitCommand=function(self) self:zoomto(_screen.w,0):diffuse(Color.Black) end,
	OnCommand=function(self) self:accelerate(0.3):zoomtoheight(128):diffusealpha(0.9):sleep(2.5) end,
	OffCommand=function(self) self:accelerate(0.3):zoomtoheight(0) end
}

-- loop to add 7 SM5 logo arrows to the primary ActorFrame
for i=1,7 do

	local arrow = Def.ActorFrame{
		InitCommand=function(self) self:x((i-4) * 50):diffusealpha(0) end,
		OnCommand=function(self)
			self:sleep(i*0.1 + 0.2)
			self:linear(0.75):diffusealpha(1):linear(0.75):diffusealpha(0)

			self:queuecommand("Hide")
		end,
		HideCommand=function(self) self:visible(false) end,
	}

	-- desaturated SM5 logo
	arrow[#arrow+1] = LoadActor("logo.png")..{
		InitCommand=function(self) self:zoom(0.1):diffuse(GetHexColor(slc-i-3, true)) end,
	}

	af[#af+1] = arrow
end

-- quote body
af[#af+1] = LoadFont("Common Normal")..{
	InitCommand=function(self)
		body = self
		self:diffuse(GetHexColor(slc)):diffusealpha(0):horizalign(left):vertspacing(-4)
	end,
	OnCommand=cmd(sleep,3; linear,0.25; diffusealpha,1),
	OffCommand=cmd(linear,0.25; diffusealpha,0)
}

-- quote author
af[#af+1] = LoadFont("Common Normal")..{
	InitCommand=function(self)
		author = self
		self:diffuse(GetHexColor(slc)):diffusealpha(0):horizalign(right)
	end,
	OnCommand=cmd(sleep,3; linear,0.25; diffusealpha,1),
	OffCommand=cmd(linear,0.25; diffusealpha,0)
}

af[#af+1] = Def.Sprite{
	InitCommand=function(self)
		self:diffusealpha(0)
		picture = self
	end,
	OnCommand=function(self)
		local zoom_value = math.min(128/self:GetHeight(), 320/self:GetWidth())
		self:zoom(zoom_value):sleep(3):linear(0.25):diffusealpha(1):queuecommand("MaybePlaySound")
	end,
	MaybePlaySoundCommand=function(self)
		if rand_quote == 4 then
			SOUND:PlayOnce(THEME:GetPathS("", "mario_hey_stinky.ogg"))
		end
	end,
	OffCommand=cmd(linear,0.25; zoomtoheight, 0; diffusealpha,0)
}

return af