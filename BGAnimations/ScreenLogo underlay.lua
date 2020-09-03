-- ECS Logo
return LoadActor(THEME:GetPathG("", "_logos/ecs (doubleres).png"))..{
	InitCommand=function(self) self:x(2):zoom(0.5):shadowlength(0.75) end,
	OffCommand=function(self) self:linear(0.5):shadowlength(0) end
}