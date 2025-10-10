return Def.Actor{
	OffCommand=function(self)
		self:sleep(0.9)
		if GetDivision() == nil then return end

		-- FindSong needs the song title + subtitle (from the simfile, not the folder name).

		if ECS.Mode == "ECS" then
			if GetDivision() == "upper" then
				local default = SONGMAN:FindSong("ECS14 - Upper/[25] [250] Apocalyptic Dawn FP 250")
				if default then
					GAMESTATE:SetPreferredSong(default)
				end
			elseif GetDivision() == "mid" then
				local default = SONGMAN:FindSong("ECS14 - Mid/[18] [180] Fractal Glitch Works (Part 3) Nirvikalpa Samadhi")
				if default then
					GAMESTATE:SetPreferredSong(default)
				end
			else
				local default = SONGMAN:FindSong("ECS14 - Lower/[12] [120] Colors of Love")
				if default then
					GAMESTATE:SetPreferredSong(default)
				end
			end
		elseif ECS.Mode == "Speed" then
			local default = SONGMAN:FindSong("ECS14 - Speed/[25] [250] The Ninth Circle - Treachery")
			if default then
				GAMESTATE:SetPreferredSong(default)
			end
		elseif ECS.Mode == "Marathon" then
			if GetDivision() == "upper" then
				local default = SONGMAN:FindSong("ECS14 - Upper Marathon/TrancemaniaXXX - HyperTranced")
				if default then
					GAMESTATE:SetPreferredSong(default)
				end
			elseif GetDivision() == "mid" then
				local default = SONGMAN:FindSong("ECS14 - Mid Marathon/They Be Groovin'")
				if default then
					GAMESTATE:SetPreferredSong(default)
				end
			else
				local default = SONGMAN:FindSong("ECS14 - Lower Marathon/Pem-D-Monium")
				if default then
					GAMESTATE:SetPreferredSong(default)
				end
			end
		end
	end
}