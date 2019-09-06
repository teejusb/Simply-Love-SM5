local args = ...
local af = args.af

local path = "/Themes/" ..THEME:GetCurThemeName().. "/Graphics/_avatars/"
local files = FILEMAN:GetDirListing(path)

for file in ivalues(files) do
	-- attempt to filter out system files that start with "."
	if file:sub(1,1) ~= "." then

		local filename = StripSpriteHints(file)
		filename = filename:gsub(".jpg","")

		local file_ext = file:sub(-4)

		af[#af+1] = Def.Sprite{
			Name="Avatar_"..StripSpriteHints(file),
			Texture=THEME:GetPathG("","_avatars/"..file),
			InitCommand=function(self)
				local src_width  = self:GetTexture():GetSourceWidth()
				local src_height = self:GetTexture():GetSourceHeight()

				-- check for animated sprite textures
				local w, h = file:match("(%d+)x(%d+)")
				if w and h then
					src_width = src_width/w
					src_height = src_height/h
					self:SetAllStateDelays(0.035)
				end

				local img_width = 80
				local img_height = img_width * (src_height/src_width)

				self:zoomto(img_width, img_height):halign(0):valign(0):y(-100)
			end
		}
	end
end