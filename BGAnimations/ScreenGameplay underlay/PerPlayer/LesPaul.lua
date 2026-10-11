local player = ...
local pn = ToEnumShortString(player)
local mods = SL[pn].ActiveModifiers

local af = Def.ActorFrame{
  OnCommand=function(self)
    local playfield = SCREENMAN:GetTopScreen():GetChild('PlayerP1')
    if playfield then
      playfield:rotationx(-50)
    end
  end,

  Def.Sprite {
		Texture=THEME:GetPathG("", "_ECS/lespaul (doubleres).png"),
		InitCommand=function(self)
			self:Center():zoom(0.9)
		end,
	},

  Def.Sprite {
		Texture=THEME:GetPathG("", "_ECS/lespaul lane (doubleres).png"),
		InitCommand=function(self)
			self:xy(GetNotefieldX(player), _screen.cy ):zoom(0.9):zoomtowidth(GetNotefieldWidth() * 1.4)
		end,
	},
}

return af