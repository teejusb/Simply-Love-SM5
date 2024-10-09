local quotes = {
	{
		{"I honestly wasn't sure if I'd make it through Slam.\nThis is by far the hardest thing I've passed."},
		{"Zetorux, ECS1"}
	},
	{
		{"Are you asking about my stamina cap ?"},
		{"aijbot"}
	},
	{
		{"Turns out never play marathons"},
		{"Archi"}
	},
	{
		{"get deaded"},
		{"Archi"}
	},
	{
		{"yeah nobody really cares"},
		{"Archi"}
	},
	{
		{"Death is a natural part of life though"},
		{"Archi"}
	},
	{
		{"Quit making excuses"},
		{"Archi"}
	},
	{
		{"In an RO you just deal with it"},
		{"Archi"}
	},
	{
		{"yooo I finally qualified for lower letsgooo"},
		{"Dom ITG"}
	},
	{
		{"Ok"},
		{"daster131"}
	},
	{
		{"I think that you guys are underestimating how hard it is to do the thing"},
		{"Arvin"}
	},
	{
		{"Quit job and play marathon"},
		{"Archi"}
	},
}

local body, author, picture
local w = 310
----------------------------------------

local af = Def.ActorFrame{
	InitCommand=function(self)
		self:Center()
		local rand_quote = math.random(#quotes)
		local quote = quotes[rand_quote]
		body:settext(quote[1][1]):y(-15)
		author:settext(" - "..quote[2][1]):horizalign(left):x(body:GetWidth()/3):y(15)
		picture:Load(nil)
	end,
	OnCommand=function(self)
		if ThemePrefs.Get("VisualStyle") ~= "Hearts" or ThemePrefs.Get("RainbowMode") == true then
			ThemePrefs.Set("VisualStyle", "Hearts")
			ThemePrefs.Set("RainbowMode", false)
			ThemePrefs.Save()

			MESSAGEMAN:Broadcast("VisualStyleSelected")
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
	OnCommand=function(self) self:accelerate(0.3):zoomtoheight(128):diffusealpha(0.9) end,
	OffCommand=function(self) self:accelerate(0.3):zoomtoheight(0) end
}

-- loop to add 7 SM5 logo arrows to the primary ActorFrame
for i=1,7 do

	local arrow = Def.ActorFrame{
		InitCommand=function(self) self:x((i-4) * 50):diffusealpha(0) end,
		OnCommand=function(self)
			-- thonk
			if ThemePrefs.Get("VisualStyle")=="Thonk" then
				self:diffusealpha(1):rotationy(-90):sleep(i*0.1 + 0.2)
				self:smooth(0.25):rotationy(0):sleep(0.8):bouncebegin(0.8):y(_screen.h)
			-- everything else
			else
				self:sleep(i*0.1 + 0.2)
				self:linear(0.75):diffusealpha(1):linear(0.75):diffusealpha(0)
			end

			self:queuecommand("Hide")
		end,
		HideCommand=function(self) self:visible(false) end,
	}

	-- desaturated SM5 logo
	arrow[#arrow+1] = LoadActor("logo.png")..{
		InitCommand=function(self) self:zoom(0.1):diffuse(GetHexColor(slc-i-4, true)) end,
	}

	-- only add Thonk asset if needed
	if ThemePrefs.Get("VisualStyle")=="Thonk" then
		arrow[#arrow+1] = LoadActor("thonk.png")..{
			InitCommand=function(self) self:zoom(0.1):xy(6,-2) end,
		}
	end

	af[#af+1] = arrow
end

-- quote body
af[#af+1] = LoadFont("Common Normal")..{
	InitCommand=function(self)
		body = self
		self:diffuse(GetHexColor(slc)):diffusealpha(0):vertspacing(-4)
	end,
	OnCommand=cmd(sleep,2.1; linear,0.25; diffusealpha,1),
	OffCommand=cmd(accelerate,0.3; diffusealpha,0)
}

-- quote author
af[#af+1] = LoadFont("Common Normal")..{
	InitCommand=function(self)
		author = self
		self:diffuse(GetHexColor(slc)):diffusealpha(0)
	end,
	OnCommand=cmd(sleep,2.1; linear,0.25; diffusealpha,1),
	OffCommand=cmd(accelerate,0.3; diffusealpha,0)
}

af[#af+1] = Def.Sprite{
	InitCommand=function(self)
		self:diffusealpha(0)
		picture = self
	end,
	OnCommand=function(self)
		local zoom_value = math.min(128/self:GetHeight(), 320/self:GetWidth())
		self:zoom(zoom_value):sleep(2.1):linear(0.25):diffusealpha(1)
	end,
	OffCommand=cmd(accelerate,0.3; zoomtoheight, 0; diffusealpha,0)
}

return af
