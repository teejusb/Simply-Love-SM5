return Def.Actor{
	OffCommand=function(self)
		self:sleep(0.9)
		if GetDivision() == nil then return end

		if ECS.Mode == "ECS" then
			if GetDivision() == "upper" then
				local default = SONGMAN:FindSong("ECS12 - Upper/[24] [240] Fumisugi Annihilation")
				if default then
					GAMESTATE:SetPreferredSong(default)
				end
			elseif GetDivision() == "mid" then
				local default = SONGMAN:FindSong("ECS12 - Mid/[18] [180] The Second Circle - Lust")
				if default then
					GAMESTATE:SetPreferredSong(default)
				end
			else
				local default = SONGMAN:FindSong("ECS12 - Lower/[12] [120] Dancin KRONO Extended Remix")
				if default then
					GAMESTATE:SetPreferredSong(default)
				end
			end
		elseif ECS.Mode == "Speed" then
			local default = SONGMAN:FindSong("ECS12 - Speed/[24] [240] The Eighth Circle - Fraud")
			if default then
				GAMESTATE:SetPreferredSong(default)
			end
		elseif ECS.Mode == "Marathon" then
			if GetDivision() == "upper" then
				local default = SONGMAN:FindSong("ECS12 - Upper Marathon/PATH OF THE GREATS ~The Vast Gardens Of Elysium~")
				if default then
					GAMESTATE:SetPreferredSong(default)
				end
			elseif GetDivision() == "mid" then
				local default = SONGMAN:FindSong("ECS12 - Mid Marathon/TOTAL BLACKOUT ~The Flooded Plains Of Asphodel~")
				if default then
					GAMESTATE:SetPreferredSong(default)
				end
			else
				local default = SONGMAN:FindSong("ECS12 - Lower Marathon/NO ESCAPE ~The Deep Abyss Of Tartarus~")
				if default then
					GAMESTATE:SetPreferredSong(default)
				end
			end
		end
	end
}