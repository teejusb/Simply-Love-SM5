return Def.Actor{
	OffCommand=function(self)
		self:sleep(0.9)
		if GetDivision() == nil then return end

		if ECS.Mode == "ECS" then
			if GetDivision() == "upper" then
				local parallax = SONGMAN:FindSong("ECS11 - Upper/[23] [230] Parallax (Rerestep) FP 230")
				if parallax then
					GAMESTATE:SetPreferredSong(parallax)
				end
			elseif GetDivision() == "mid" then
				local falz = SONGMAN:FindSong("ECS11 - Mid/[17] [170] Falz Double Hunar Theme")
				if falz then
					GAMESTATE:SetPreferredSong(falz)
				end
			else
				local discovery = SONGMAN:FindSong("ECS11 - Lower/[12] [130] Discovery")
				if discovery then
					GAMESTATE:SetPreferredSong(discovery)
				end
			end
		elseif ECS.Mode == "Speed" then
			local eljektronnyi = SONGMAN:FindSong("ECS11 - Speed/[23] [240] Eljektronnyi Mir")
			if eljektronnyi then
				GAMESTATE:SetPreferredSong(eljektronnyi)
			end
		elseif ECS.Mode == "Marathon" then
			if GetDivision() == "upper" then
				local proof = SONGMAN:FindSong("ECS11 - Upper Marathon/Proof Of Will")
				if proof then
					GAMESTATE:SetPreferredSong(proof)
				end
			elseif GetDivision() == "mid" then
				local ballistic = SONGMAN:FindSong("ECS11 - Mid Marathon/Let's Go Ballistic")
				if ballistic then
					GAMESTATE:SetPreferredSong(ballistic)
				end
			else
				local chepers = SONGMAN:FindSong("ECS11 - Lower Marathon/Return Of The Chepers")
				if chepers then
					GAMESTATE:SetPreferredSong(chepers)
				end
			end
		end
	end
}