return Def.Actor{
	OffCommand=function(self)
		self:sleep(0.9)

		if ECS.Mode == "ECS" then
			if PlayerIsUpper() == nil then return end

			if PlayerIsUpper() then 
				local girly_tekno_beats = SONGMAN:FindSong("ECS9 - Upper/[18] [190] 90's Girly Tekno Beats")
				if girly_tekno_beats then
					GAMESTATE:SetPreferredSong(girly_tekno_beats)
				end
			else
				local beyond_life = SONGMAN:FindSong("ECS9 - Lower/[12] [140] Beyond Life")
				if beyond_life then
					GAMESTATE:SetPreferredSong(beyond_life)
				else
					local asereje = SONGMAN:FindSong("ECS9 - Lower/[17] [185] Asereje")
					if asereje then
						GAMESTATE:SetPreferredSong(asereje)
					else
				end
			end
		elseif ECS.Mode == "Marathon" then
			-- TODO(teejusb)
			local masochisma = SONGMAN:FindSong("ECS9 - Upper Marathon/Masochisma Mk 0")
			if masochisma then
				GAMESTATE:SetPreferredSong(masochisma)
			end
		end
	end
}