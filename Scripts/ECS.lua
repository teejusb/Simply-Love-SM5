ECS = {}

-- call this to (re)initialize per-player settings
InitializeECS = function()
	ECS.Mode = "Warmup"
	ECS.IsPracticeSet = false
	ECS.BreakTimer=(15 * 60)

	ECS.Player = {
		Profile=nil,
		Relics={},
		-- Use AddPlayedSongs to append to this table which will keep this table
		-- sorted in descending order of points.
		SongsPlayed={},
		TotalMarathonPoints=0,
	}
end

local BowEquipped = function(relics_used)
	for relic in ivalues(relics_used) do
		local name = relic.name
		if (name == "Short Bow" or name == "Composite Bow" or name == "Long Bow" or name == "Twisted Bow" or
			name == "Eurytos' Bow" or name == "Gastraphetes" or name == "Gandiva") then
			return true
		end
	end
	return false
end

local ArrowEquipped = function(relics_used)
	for relic in ivalues(relics_used) do
		local name = relic.name
		if (name == "Stone Arrow" or name == "Bronze Arrow" or name == "Mythril Arrow" or name == "Dragon Arrow") then
			return true
		end
	end
	return false
end

local GunEquipped = function(relics_used)
	for relic in ivalues(relics_used) do
		local name = relic.name
		if (name == "Annihilator" or name == "Death Penalty" or name == "Armageddon" or name == "Arquebus") then
			return true
		end
	end
	return false
end

local BulletEquipped = function(relics_used)
	for relic in ivalues(relics_used) do
		local name = relic.name
		if (name == "Bullet" or name == "Living Bullet") then
			return true
		end
	end
	return false
end

-- the master list
ECS.Relics = {
	{
		id=0,
		name="Stone Blade",
		desc="A low-level blade made from stone. Somewhat enhanced by the accuracy of your attacks.",
		effect="Lv. 1 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="stoneblade.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return math.floor(ap * 0.1)
		end,
	},
	{
		id=1,
		name="Stone Knife",
		desc="A low-level knife made from stone. Somewhat effective against fast opponents.",
		effect="Lv. 1 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="stoneknife.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return math.floor(song_data.dp * 0.1)
		end,
	},
	{
		id=2,
		name="Stone Axe",
		desc="A low-level axe made from stone. Somewhat effective against large opponents.",
		effect="Lv. 1 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="stoneaxe.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return math.floor(song_data.ep * 0.1)
		end,
	},
	{
		id=3,
		name="Short Bow",
		desc="A basic bow that won't impact the effectiveness of your arrows much, but will at least allow you to make use of them.",
		effect="+0 BP",
		is_consumable=false,
		is_marathon=false,
		img="shortbow.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			-- Technically returns 0 regardless of if arrow is equpped or not.
			return 0
		end,
	},
	{
		id=4,
		name="Stone Arrow",
		desc="A low-level arrow tipped with stone. Deals weak damage with a bow equipped. Single use.",
		effect="+125 BP with bow equipped",
		is_consumable=true,
		is_marathon=false,
		img="stonearrow.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if BowEquipped(relics_used) then
				return 125
			else
				return 0
			end
		end,
	},
	{
		id=5,
		name="Bronze Blade",
		desc="A mid-level blade made from bronze. Enhanced by the accuracy of your attacks.",
		effect="Lv. 2 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="bronzeblade.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return math.floor(ap * 0.2)
		end,
	},
	{
		id=6,
		name="Bronze Knife",
		desc="A mid-level knife made from bronze. Effective against fast opponents.",
		effect="Lv. 2 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="bronzeknife.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return math.floor(song_data.dp * 0.2)
		end,
	},
	{
		id=7,
		name="Bronze Axe",
		desc="A mid-level axe made from bronze. Effective against large opponents.",
		effect="Lv. 2 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="bronzeaxe.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return math.floor(song_data.ep * 0.2)
		end,
	},
	{
		id=8,
		name="Composite Bow",
		desc="Bow made from a synthesis of materials to allow for improved flexibility.",
		effect="+50 BP with arrow equipped",
		is_consumable=false,
		is_marathon=false,
		img="compositebow.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if ArrowEquipped(relics_used) then
				return 50
			else
				return 0
			end
		end,
	},
	{
		id=9,
		name="Bronze Arrow",
		desc="A mid-level arrow tipped with bronze. Deals good damage with a bow equipped. Single use.",
		effect="+225 BP with bow equipped",
		is_consumable=true,
		is_marathon=false,
		img="bronzearrow.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if BowEquipped(relics_used) then
				return 225
			else
				return 0
			end
		end,
	},
	{
		id=10,
		name="Mythril Blade",
		desc="A high-level blade made from mythril. Strongly enhanced by the accuracy of your attacks.",
		effect="Lv. 3 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="mythrilblade.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return math.floor(ap * 0.3)
		end,
	},
	{
		id=11,
		name="Mythril Knife",
		desc="A high-level knife made from mythril. Strongly effective against fast opponents.",
		effect="Lv. 3 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="mythrilknife.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return math.floor(song_data.dp * 0.3)
		end,
	},
	{
		id=12,
		name="Mythril Axe",
		desc="A high-level axe made from mythril. Strongly effective against large opponents.",
		effect="Lv. 3 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="mythrilaxe.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return math.floor(song_data.ep * 0.3)
		end,
	},
	{
		id=13,
		name="Long Bow",
		desc="A large, strong bow capable of subduing powerful monsters.",
		effect="+100 BP with arrow equipped",
		is_consumable=false,
		is_marathon=false,
		img="longbow.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if ArrowEquipped(relics_used) then
				return 100
			else
				return 0
			end
		end,
	},
	{
		id=14,
		name="Mythril Arrow",
		desc="A high-level arrow tipped with mythril. Deals strong damage with a bow equipped. Single use.",
		effect="+300 BP with bow equipped",
		is_consumable=true,
		is_marathon=false,
		img="mythrilarrow.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if BowEquipped(relics_used) then
				return 300
			else
				return 0
			end
		end,
	},
	{
		id=15,
		name="Bullet",
		desc="Lead bullet with good penetrating power. Deals incredible damage with a gun equipped. Single use.",
		effect="+500 BP with gun equipped",
		is_consumable=true,
		is_marathon=false,
		img="bullet.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if GunEquipped(relics_used) then
				return 500
			else
				return 0
			end
		end,
	},
	{
		id=16,
		name="Crystal Sword",
		desc="A stunningly beautiful crystal sword. Incredibly enhanced by the accuracy of your attacks.",
		effect="Lv. 4 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="crystalsword.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return math.floor(ap * 0.4)
		end,
	},
	{
		id=17,
		name="Diamond Sword",
		desc="An immaculate diamond sword. Maximally enhanced by the accuracy of your attacks.",
		effect="Lv. 5 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="diamondsword.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return math.floor(ap * 0.5)
		end,
	},
	{
		id=18,
		name="Silver Stopwatch",
		desc="Stopwatch imbued with time magic.",
		effect="45 seconds added to break timer",
		is_consumable=true,
		is_marathon=false,
		img="silverstopwatch.png",
		action=function(relics_used)
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEvaluationStage" then
				local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber())
				local failed = pss:GetFailed()
				if not failed then
					ECS.BreakTimer = ECS.BreakTimer + 45
				end
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 0
		end,
	},
	{
		id=19,
		name="Accuracy Potion",
		desc="An old DPRT concoction, this potion grows more potent as you accurately defeat enemies.",
		effect="At end of set, +BP equal to (1000^average song score) - 50",
		is_consumable=true,
		is_marathon=false,
		img="accuracypotion.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			-- End of set relics are handled in ScreenGameOver
			return 0
		end,
	},
	{
		id=20,
		name="Mammon",
		desc="A massive war axe fueled by the essence of avarice. Has the potential to be extremely deadly.",
		effect="+550 BP for Rank 1 on Lifetime Song Gold|+BP based on Lifetime Song Gold for Rank 2 and below (Max 400)",
		is_consumable=false,
		is_marathon=false,
		img="mammon.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			-- Determine Rank 1 gold by checking every player
			local all_gold_amounts = {}
			for name, player in pairs(ECS.Players) do
				all_gold_amounts[#all_gold_amounts + 1] = player.lifetime_song_gold
			end
			table.sort(all_gold_amounts)
			local max_gold = all_gold_amounts[#all_gold_amounts]
			if max_gold == nil then return 0 end
			-- We need the 2nd highest as well for those that weren't rank 1
			local second_highest = nil
			for i = #all_gold_amounts, 1, -1 do
				if all_gold_amounts[i] < max_gold then
					second_highest = all_gold_amounts[i]
					break
				end
			end
			if max_gold == ecs_player.lifetime_song_gold then
				return 550
			else
				local second_highest = all_gold_amounts[#all_gold_amounts-1]
				if second_highest == nil then return 0 end
				return math.floor(400 * (ecs_player.lifetime_song_gold / second_highest))
			end
		end,
	},
	{
		id=21,
		name="Baguette",
		desc="\"Oh come on ! It's the best France has to offer!\" Nuh-uh. It isn't because it's the most successful that it is the best. In my case, it is the true and tried classic, but it is not necessarily what I'd take above all.",
		effect="+BP equal to 100 * (Adj. Stream %)^3",
		is_consumable=true,
		is_marathon=false,
		img="baguette.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return math.floor(100 * (song_data.adj_stream ^ 3))
		end,
	},
	{
		id=22,
		name="Pain Viennois",
		desc="\"Oh please! This is not even French!\" Yup. Thank you Austria for this delicious contraption that can be used as a breakfast, or in certain elaborate sandwiches of which I am particularly affectionate.",
		effect="+BP equal to 175 * (Adj. Stream %)^3",
		is_consumable=true,
		is_marathon=false,
		img="painviennois.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return math.floor(175 * (song_data.adj_stream ^ 3))
		end,
	},
	{
		id=23,
		name="Pain Brioche",
		desc="\"Man, now its not even bread anymore.\" Well, depends on what your definition is, but this is the best sugary bread there is. Some might even use it for the legendary Saucisson Brioche, which is also an underrated french classic. ",
		effect="+BP equal to 250 * (Adj. Stream %)^3",
		is_consumable=true,
		is_marathon=false,
		img="painbrioche.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return math.floor(250 * (song_data.adj_stream ^ 3))
		end,
	},
	{
		id=24,
		name="Fougasse",
		desc="\"What does that even mean?\" Fogatza in ancient Occitan (old French dialect of the South Of France), which then turned into fogatza and then fougasse as time went by, this is a flatbread that you can use as a base for all kinds of pizza-style dishes, which can be as classic as the olive fougasse, or as exotic as raclette fougasse. ",
		effect="+BP equal to 325 * (Adj. Stream %)^3",
		is_consumable=true,
		is_marathon=false,
		img="fougasse.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return math.floor(325 * (song_data.adj_stream ^ 3))
		end,
	},
	{
		id=25,
		name="Faluche",
		desc="\"No idea what this is either. Is that some sort of FA-luchis shenanigans?\" The quintessential bread of the North branch of the French Coast Stamina. Neither a round nor flat bread but looks somewhat like a small deflated soccer ball, these deceiving looks hide true greatness. Can be used for breakfast, for lunch, for whatever you'd like, in forms ranging from just sugar inside, to what we call an "Americain", which is literally using this as a bun for a cheeseburger, then fill whatever space you have left with fries. Delicious isn't it?",
		effect="+BP equal to 400 * (Adj. Stream %)^3",
		is_consumable=true,
		is_marathon=false,
		img="faluche.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return math.floor(400 * (song_data.adj_stream ^ 3))
		end,
	},
	{
		id=26,
		name="BURGER",
		desc="The ultimate burger, formed from expertly chosen ingredients in perfect harmony with one another. You can practically taste the aura of delicious burgerness radiating from it. Truly a divine entree.",
		effect="+1000 BP|The BP here stands for Burger Points|The Burger Points don't do anything",
		is_consumable=true,
		is_marathon=false,
		img="burger.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 0
		end,
	},
	{
		id=27,
		name="Crystal Axe",
		desc="A stunningly beautiful crystal axe. Incredibly effective against large opponents.",
		effect="Lv. 4 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="crystalaxe.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return math.floor(song_data.ep * 0.4)
		end,
	},
	{
		id=28,
		name="Diamond Axe",
		desc="An immaculate diamond axe. Maximum effectiveness against large opponents.",
		effect="Lv. 5 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="diamondaxe.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return math.floor(song_data.ep * 0.5)
		end,
	},
	{
		id=29,
		name="Lance of Longinus",
		desc="Extremely rare holy lance. Very effective against marathon beasts.",
		effect="+3000 MP",
		is_consumable=false,
		is_marathon=true,
		img="lanceoflonginus.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			-- NOTE(teejusb): MP Relics will only show up during the marathon so
			-- returning the actual MP points is fine.
			return 3000
		end,
	},
	{
		id=30,
		name="Ornate Hourglass",
		desc="Hourglass imbued with time magic.",
		effect="45 seconds added to break timer",
		is_consumable=true,
		is_marathon=false,
		img="ornatehourglass.png",
		action=function(relics_used)
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEvaluationStage" then
				local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber())
				local failed = pss:GetFailed()
				if not failed then
					ECS.BreakTimer = ECS.BreakTimer + 45
				end
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 0
		end,
	},
	{
		id=31,
		name="Stamina Potion",
		desc="Commissioned the Stamina Corps, these potions grow more effective as large enemies are defeated. Single use.",
		effect="At end of set, +BP equal to total steps of passed songs divided by 45",
		is_consumable=true,
		is_marathon=false,
		img="staminapotion.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			-- End of set relics are handled in ScreenGameOver
			return 0
		end,
	},
	{
		id=32,
		name="Giant-Crusher",
		desc="A hammer made from a boulder, used in the war against the Grigori in ages past. One of the heftiest weapons across the Three Nations. After the Grigori were quelled, and man turned against man in violence, this weapon was all but forgotten. Man has grown feeble in comparison to his forebears. ",
		effect="+50 BP per minute of song length",
		is_consumable=false,
		is_marathon=false,
		img="giantcrusher.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return math.floor(song_data.length * 50)
		end,
	},
	{
		id=33,
		name="Crystal Dagger",
		desc="A stunningly beautiful crystal dagger. Incredibly effective against fast opponents.",
		effect="Lv. 4 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="crystaldagger.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return math.floor(song_data.dp * 0.4)
		end,
	},
	{
		id=34,
		name="Diamond Dagger",
		desc="An immaculate diamond dagger. Maximum effectiveness against fast opponents.",
		effect="Lv. 5 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="diamonddagger.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return math.floor(song_data.dp * 0.5)
		end,
	},
	{
		id=35,
		name="Twisted Bow",
		desc="Prized bow recovered from the Chambers of Xeric. Maximum effectiveness against difficult opponents.",
		effect="Lv. 5 RP Bonus with arrow equipped",
		is_consumable=false,
		is_marathon=false,
		img="twistedbow.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if ArrowEquipped(relics_used) then
				local max_division_rp = 1000 * (1 + (song_info.MaxBlockLevel-song_info.MinBlockLevel))
				return math.floor(song_data.rp/(max_division_rp/1000) * 0.5)
			else
				return 0
			end
		end,
	},
	{
		id=36,
		name="Dragon Arrow",
		desc="A vicious arrow tipped with a dragon fang. Strongly effective against fast opponents with a bow equipped. Single use.",
		effect="Lv. 3 DP Bonus with bow equipped|+200 BP with bow equipped",
		is_consumable=true,
		is_marathon=false,
		img="dragonarrow.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if BowEquipped(relics_used) then
				return math.floor(song_data.dp * 0.3) + 200
			else
				return 0
			end
		end,
	},
	{
		id=37,
		name="Living Bullet",
		desc="Banned from use in traditional warfare by various treaties, these black market bullets are formed through a sinister process rumored to involve human sacrifice. The resulting ammunition magically resonates with the strength of the one wielding it. Single use.",
		effect="+307 BP with a gun equipped|+1 BP for each skill level in tiers 240+ with a gun equipped",
		is_consumable=true,
		is_marathon=false,
		img="livingbullet.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if GunEquipped(relics_used) then
				local total_skill = 0
				for tier, skill in pairs(ecs_player.tier_skill) do
					if tier >= 240 then
						total_skill = total_skill + 1
					end
				end
				return 307 + total_skill
			else
				return 0
			end
		end,
	},
	{
		id=38,
		name="Omen Cleaver",
		desc="Heavy-bladed curved sword of colossal size awarded to Omen as a tool of war. This weapon is made to take advantage of brute strength.  The pattern etched upon the blade is the remnant of a deteriorating malediction. Indeed, when bestowing a weapon, preparations must be made for taking it away.",
		effect="+650 BP for Rank 1 on Lifetime JP|+BP based on Lifetime JP for Rank 2 and below (Max 475)",
		is_consumable=false,
		is_marathon=false,
		img="omencleaver.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			-- Determine Rank 1 JP by checking every player
			local all_jp_amounts = {}
			for name, player in pairs(ECS.Players) do
				all_jp_amounts[#all_jp_amounts + 1] = player.lifetime_jp
			end
			table.sort(all_jp_amounts)

			local max_jp = all_jp_amounts[#all_jp_amounts]
			if max_jp == nil then return 0 end

			-- We need the 2nd highest as well for those that weren't rank 1
			local second_highest = nil
			for i = #all_jp_amounts, 1, -1 do
				if all_jp_amounts[i] < max_jp then
					second_highest = all_jp_amounts[i]
					break
				end
			end

			if max_jp == ecs_player.lifetime_jp then
				return 650
			else
				local second_highest = all_jp_amounts[#all_jp_amounts-1]
				if second_highest == nil then return 0 end
				return math.floor(475 * (ecs_player.lifetime_jp / second_highest))
			end
		end,
	},
	{
		id=39,
		name="Antique Sundial",
		desc="Sundial imbued with time magic. Single use.",
		effect="45 seconds added to break timer",
		is_consumable=true,
		is_marathon=false,
		img="antiquesundial.png",
		action=function(relics_used)
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEvaluationStage" then
				local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber())
				local failed = pss:GetFailed()
				if not failed then
					ECS.BreakTimer = ECS.BreakTimer + 45
				end
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 0
		end,
	},
	{
		id=40,
		name="Agility Potion",
		desc="Brewed in the Footspeed Empire, this potion grows more effective as fast enemies are defeated. Single use.",
		effect="At end of set, +BP equal to (average BPM of passed songs-120)^1.3",
		is_consumable=true,
		is_marathon=false,
		img="agilitypotion.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			-- End of set relics are handled in ScreenGameOver
			return 0
		end,
	},
	{
		id=41,
		name="Kraken Club",
		desc="Immensely sought-after, this club is enchanted with a spell that hastens the wielder's swings, allowing consecutive blows in the time it would normally take to make one. Single use.",
		effect="+25 BP|+BP equal to total amount yielded by other relics",
		is_consumable=true,
		is_marathon=false,
		img="krakenclub.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			local other_bp = 0
			for relic in ivalues(relics_used) do
				if relic.name ~= "Kraken Club" then
					other_bp = relic.score(ecs_player, song_info, song_data, relics_used, ap, score)
				end
			end
			return 25 + other_bp
		end,
	},
	{
		id=42,
		name="Uchigatana",
		desc="A katana with a long single-edged curved blade. A unique weapon wielded by the samurai from Japan Coast Stamina. The blade, with its undulating design, boasts extraordinary sharpness, and its slash attacks cause blood loss.",
		effect="+BP equal to your skill in the speed tier",
		is_consumable=false,
		is_marathon=false,
		img="uchigatana.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return ecs_player.tier_skill[song_data.bpm_tier]
		end,
	},
	{
		id=43,
		name="Kikoku",
		desc="This reforged ninja knife is a relic from the distant past has been used for many clandestine acts over the course of Footspeed Empire history. Somewhat effective against fast opponents.",
		effect="Lv. 1 DP Bonus for 130 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="kikoku.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 130 then
				return math.floor(song_data.dp * 0.1)
			else
				return 0
			end
		end,
	},
	{
		id=44,
		name="Nagi",
		desc="From the epic stage of great eastern battles comes the tale of this dagger which, before entering into his possession, was once trained on the very heart of the Godfather while in the hands of an unknown female ninja. The story that survives tells us nothing more of her than that she was a failed acolyte at a shrine of some notoriety, from which she absconded the ceremonial blade in order to fuel her own twisted drive for power. The katana itself, they say, has at its beck and call all the fury and rage of the most unrelenting winds and torrential rains. Somewhat effective against opponents that are both large and fast.",
		effect="+100 BP for 130 BPM songs|Lv. 1 DP/EP Bonus for 130 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="nagi.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 130 then
				return 100 + math.floor(song_data.dp_ep * 0.1)
			else
				return 0
			end
		end,
	},
	{
		id=45,
		name="Kannagi",
		desc="In less civilized times, this empyrean ninja knife was used for purposes both great and ill, both on the field of battle and in covert operations. Effective against large opponents.",
		effect="+100 BP for 130 BPM songs|Lv. 2 EP Bonus for 130 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="kannagi.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 130 then
				return 100 + math.floor(song_data.ep * 0.2)
			else
				return 0
			end
		end,
	},
	{
		id=46,
		name="Spharai",
		desc="Relics from a bygone era of bloodshed, the Spharai typify caestus of their time and are notable for having been wielded by a general forgotten to time who resided in the present-day West Coast Stamina region of the Stamina Nation. Somewhat effective against fast opponents.",
		effect="Lv. 1 DP Bonus for 140 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="spharai.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 140 then
				return math.floor(song_data.dp * 0.1)
			else
				return 0
			end
		end,
	},
	{
		id=47,
		name="Glanzfaust",
		desc="As the name entails, these weapons transform the wearer's fists into instruments of glorious destruction. Many believe they will be one of the greatest legacies of the pugilist of the Footspeed Empire, YourVinished, dear friend to the Godfather of Stamina and undisputed champion of the Empire's martial games. Somewhat effective against opponents that are both large and fast.",
		effect="+100 BP for 140 BPM songs|Lv. 1 DP/EP Bonus for 140 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="glanzfaust.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 140 then
				return 100 + math.floor(song_data.dp_ep * 0.1)
			else
				return 0
			end
		end,
	},
	{
		id=48,
		name="Godhands",
		desc="Aeonic and grandiose, these claws were once held by a god, according to ancient tradition. Effective against large opponents.",
		effect="+100 BP for 140 BPM songs|Lv. 2 EP Bonus for 140 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="godhands.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 140 then
				return 100 + math.floor(song_data.ep * 0.2)
			else
				return 0
			end
		end,
	},
	{
		id=49,
		name="Bravura",
		desc="A relic axe noted in historical texts that resurfaced two years ago after being exhumed from a dig site near an old battlefield from the BBP age. Somewhat effective against fast opponents.",
		effect="Lv. 1 DP Bonus for 150 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="bravura.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 150 then
				return math.floor(song_data.dp * 0.1)
			else
				return 0
			end
		end,
	},
	{
		id=50,
		name="Conqueror",
		desc="This great axe, unconventional in design and unequaled in its powers of subjugation, was passed down along the line of the divine Emperor Mad Matt. In nobler days it was presented as an award once per generation by the emperor himself on the field of battle to the single general whose performance garnered the greatest of praise. It was by far the highest military commendation one could aspire to receive, and was much sought after by all for the visibility and clout it brought with it. Somewhat effective against opponents that are both large and fast.",
		effect="+100 BP for 150 BPM songs|Lv. 1 DP/EP Bonus for 150 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="conqueror.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 150 then
				return 100 + math.floor(song_data.dp_ep * 0.1)
			else
				return 0
			end
		end,
	},
	{
		id=51,
		name="Ukonvasara",
		desc="This massive axe is empyrean-class, and a storied weapon of renown, prized by those seeking to combat Eurobeat and Hardbass monsters. Effective against large opponents.",
		effect="+100 BP for 150 BPM songs|Lv. 2 EP Bonus for 150 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="ukonvasara.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 150 then
				return 100 + math.floor(song_data.ep * 0.2)
			else
				return 0
			end
		end,
	},
	{
		id=52,
		name="Mandau",
		desc="hey man(dau) Somewhat effective against fast opponents.",
		effect="Lv. 1 DP Bonus for 160 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="mandau.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 160 then
				return math.floor(song_data.dp * 0.1)
			else
				return 0
			end
		end,
	},
	{
		id=53,
		name="Vajra",
		desc="Forged from meteoric iron during the foregone age of the Bearpocalypse civilization, this unworldly dagger is fabled to have been wielded by the Emperor Mad Matt himself. Thought to have been forever lost within the dark passage of time, it was eventually excavated from within an ancient shrine surviving deep inside the bowels of the Mount Sigatrev subterrane. The recent discovery of a minute powering device embedded in the hilt has sparked heated intellectual fervor among the Footspeed Empire's alchemist community. Effective against opponents that are both large and fast.",
		effect="+100 BP for 160 BPM songs|Lv. 2 DP/EP Bonus for 160 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="vajra.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 160 then
				return 100 + math.floor(song_data.dp_ep * 0.2)
			else
				return 0
			end
		end,
	},
	{
		id=54,
		name="Aeneas",
		desc="Regarded favorably as one of the aeonic weapons, this dagger's usage throughout history has garnered it attention in the chronicles across the three realms. Effective against large opponents.",
		effect="+150 BP for 160 BPM songs|Lv. 2 EP Bonus for 160 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="aeneas.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 160 then
				return 150 + math.floor(song_data.ep * 0.2)
			else
				return 0
			end
		end,
	},
	{
		id=55,
		name="Warhawk's Talon",
		desc="Talon-swords are affixed to the legs of the Palace of Speed's warhawks, but this one has been repurposed for human use. The blade is thin and lightweight so as not to obstruct the hawk's mobility. Somewhat effective against fast opponents.",
		effect="Lv. 1 DP Bonus for 170 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="warhawkstalon.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 170 then
				return math.floor(song_data.dp * 0.1)
			else
				return 0
			end
		end,
	},
	{
		id=56,
		name="Murgleis",
		desc="The blade of this finely crafted sword is ingeniously armed with a fluke for disarming opponents, and is at its most effective when used in thrusting and stabbing attacks. After the passing of the great pastry chef @@, one of his patrons, Rynker, left the Stamina Nation in exile bearing the sword, and came to settle in the DPRT. Effective against opponents that are both large and fast.",
		effect="+100 BP for 170 BPM songs|Lv. 2 DP/EP Bonus for 170 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="murgleis.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 170 then
				return 100 + math.floor(song_data.dp_ep * 0.2)
			else
				return 0
			end
		end,
	},
	{
		id=57,
		name="Sequence",
		desc="Part of the pantheon of aeonic arms, this sword is an elegant weapon that only nobility and military leaders have been allowed to hold in past times. Effective against large opponents.",
		effect="+150 BP for 170 BPM songs|Lv. 2 EP Bonus for 170 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="sequence.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 170 then
				return 150 + math.floor(song_data.ep * 0.2)
			else
				return 0
			end
		end,
	},
	{
		id=58,
		name="Eurytos' Bow",
		desc="Legend has it that this unremarkable-looking bow was once a possession of a man who challenged a god. Somewhat effective against fast opponents with an arrow equipped.",
		effect="Lv. 1 DP Bonus for 180 BPM songs with an arrow equipped",
		is_consumable=false,
		is_marathon=false,
		img="eurytosbow.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if ArrowEquipped(relics_used) and song_data.bpm_tier == 180 then
				return math.floor(song_data.dp * 0.1)
			else
				return 0
			end
		end,
	},
	{
		id=59,
		name="Gastraphetes",
		desc="Equipped with an incredibly strong compound string, proper operation of this powerful bow typically requires the user to brace the stock against their stomach, from which its name, literally "belly bow," derives. At present, the empire furnishes automated pulling devices to accomplish the arduous task of reloading.  Effective against opponents that are both large and fast with an arrow equipped.",
		effect="+100 BP for 180 BPM songs with an arrow equipped|Lv. 2 DP/EP Bonus for 180 BPM songs with an arrow equipped",
		is_consumable=false,
		is_marathon=false,
		img="gastraphetes.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if ArrowEquipped(relics_used) and song_data.bpm_tier == 180 then
				return 100 + math.floor(song_data.dp_ep * 0.2)
			else
				return 0
			end
		end,
	},
	{
		id=60,
		name="Gandiva",
		desc="This divine, empyrean bow was once feared as a weapon used to fell not only great warriors, but the gods themselves. Effective against large opponents with an arrow equipped.",
		effect="+150 BP for 180 BPM songs with an arrow equipped|Lv. 2 EP Bonus for 180 BPM songs with an arrow equipped",
		is_consumable=false,
		is_marathon=false,
		img="gandiva.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if ArrowEquipped(relics_used) and song_data.bpm_tier == 180 then
				return 150 + math.floor(song_data.ep * 0.2)
			else
				return 0
			end
		end,
	},
	{
		id=61,
		name="Claustrum",
		desc="This staff from the elder days has been reforged into this form as a perfect mirror of the past relic. Effective against fast opponents.",
		effect="Lv. 2 DP Bonus for 190 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="claustrum.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 190 then
				return math.floor(song_data.dp * 0.2)
			else
				return 0
			end
		end,
	},
	{
		id=62,
		name="Laevateinn",
		desc="Passed down for generations in the myths and stories of the peoples of the Viking Coast is the World Tree motif, known to those intimately versed in such tales as Yggdrasil, or perhaps the Erdtree. One obscure legend tells of an ambitious marathon beast who ventured to the center of the tree to obtain the single branch fabled to grow there, the "Branch of Ruin." Known to sprout only the seemingly lifeless, skeletal frames of leaves in place of lush foliage, he plucked it at its base and made his way to the lands of the Viking Coast, whom he commissioned to fashion the branch into Laevateinn. Effective against opponents that are both large and fast.",
		effect="+100 BP for 190 BPM songs|Lv. 2 DP/EP Bonus for 190 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="laevateinn.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 190 then
				return 100 + math.floor(song_data.dp_ep * 0.2)
			else
				return 0
			end
		end,
	},
	{
		id=63,
		name="Khatvanga",
		desc="This aeonic staff has, over the course of its storied history, been used both as a weapon of war and as a sacred artifact during religious rituals. Strongly effective against large opponents.",
		effect="+100 BP for 190 BPM songs|Lv. 3 EP Bonus for 190 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="khatvanga.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 190 then
				return 100 + math.floor(song_data.ep * 0.3)
			else
				return 0
			end
		end,
	},
	{
		id=64,
		name="Amanomurakumo",
		desc="This unusual relic blade once belonged to an ancient and violent deity in Japan Coast Stamina. Effective against fast opponents.",
		effect="Lv. 2 DP Bonus for 200 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="amanomurakumo.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 200 then
				return math.floor(song_data.dp * 0.2)
			else
				return 0
			end
		end,
	},
	{
		id=65,
		name="Kogarasumaru",
		desc="Atypical among other members of the great katana tradition, the tip of this blade has been forged to hold two edges, one fashioned in the traditional eastern style, and the other in that of the west. Legend proclaims that the blade was presented to Archi after his defeat of the enemy general in an epic struggle. Strongly effective against opponents that are both large and fast.",
		effect="+100 BP for 200 BPM songs|Lv. 3 DP/EP Bonus for 200 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="kogarasumaru.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 200 then
				return 100 + math.floor(song_data.dp_ep * 0.3)
			else
				return 0
			end
		end,
	},
	{
		id=66,
		name="Dojikiri Yasutsuna",
		desc="Named after a mountain demon it is purported to have slain, this blade finds its origins in a folk story from Japan Coast Stamina. Strongly effective against large opponents.",
		effect="+150 BP for 200 BPM songs|Lv. 3 EP Bonus for 200 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="dojikiriyasutsuna.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 200 then
				return 150 + math.floor(song_data.ep * 0.3)
			else
				return 0
			end
		end,
	},
	{
		id=67,
		name="Grave Scythe",
		desc="Greatscythe comprised of a large blade affixed to a crooked stick. Weapon wielded by the aged grave keepers who tend the forgotten graveyards throughout the Three Nations. This weapon is said to have served as a charm against evil spirits in times of old. Effective against fast opponents.",
		effect="Lv. 2 DP Bonus for 210 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="gravescythe.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 210 then
				return math.floor(song_data.dp * 0.2)
			else
				return 0
			end
		end,
	},
	{
		id=68,
		name="Liberator",
		desc="Unorthodox by any assessment, this bifurcate scythe bears a name representative of its significant role in history. Archi's heroic efforts to quell the rebellions in the east are now a topic of common knowledge. It was on those campaigns that he directly encountered the leader of the insurgency to whom this scythe originally belonged. Strongly effective against opponents that are both large and fast.",
		effect="+150 BP for 210 BPM songs|Lv. 3 DP/EP Bonus for 210 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="liberator.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 210 then
				return 150 + math.floor(song_data.dp_ep * 0.3)
			else
				return 0
			end
		end,
	},
	{
		id=69,
		name="Redemption",
		desc="Sporting an unusual shape and design, Redemption is an empyrean scythe that was once held by a disgraced warrior seeking vengeance and renewed honor. Strongly effective against large opponents.",
		effect="+200 BP for 210 BPM songs|Lv. 3 EP Bonus for 210 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="redemption.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 210 then
				return 200 + math.floor(song_data.ep * 0.3)
			else
				return 0
			end
		end,
	},
	{
		id=70,
		name="Guttler",
		desc="A relic axe known to possess a strong affinity with beasts. Effective against fast opponents.",
		effect="Lv. 2 DP Bonus for 220 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="guttler.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 220 then
				return math.floor(song_data.dp * 0.2)
			else
				return 0
			end
		end,
	},
	{
		id=71,
		name="Aymur",
		desc="This axe, fashioned of the finest darksteel, bears the inlay of a majestic dragon, modeled after the Stamina Nation coat of arms. Its name allegedly derives from an ancient source and is symbolic of the inexplicable powers of influence the weapon seems to exert over others. It is said that the Godfather of Stamina forged the axe in an attempt to harness the power of the mighty marathon beasts. Strongly effective against opponents that are both large and fast.",
		effect="+150 BP for 220 BPM songs|Lv. 3 DP/EP Bonus for 220 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="aymur.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 220 then
				return 150 + math.floor(song_data.dp_ep * 0.3)
			else
				return 0
			end
		end,
	},
	{
		id=72,
		name="Farsha",
		desc="A one-handed axe amongst the empyrean weapons, Farsha has appeared in legends throughout the history of the Three Nations. Strongly effective against large opponents.",
		effect="+200 BP for 220 BPM songs|Lv. 3 EP Bonus for 220 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="farsha.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 220 then
				return 200 + math.floor(song_data.ep * 0.3)
			else
				return 0
			end
		end,
	},
	{
		id=73,
		name="Vyke's War Spear",
		desc="War spear singed and blistered by fingers, used by Vyke, former Knight of the Stamina Corps. Like Vyke himself, it has been tormented by the yellow flame of frenzy from within. Strongly effective against fast opponents.",
		effect="Lv. 3 DP Bonus for 230 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="vykeswarspear.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 230 then
				return math.floor(song_data.dp * 0.3)
			else
				return 0
			end
		end,
	},
	{
		id=74,
		name="Ryunohige",
		desc="Ryunohige is the notorious polearm obtained by Archi as an end result of his hundreds of battles with marathon beasts in the eastern theater of war. Forged in the image of the imposing beards of the formidable eastern wyrms, the undulating spearhead is said to harbor the powers of tumbling thunderclouds. Strongly effective against opponents that are both large and fast.",
		effect="+150 BP for 230 BPM songs|Lv. 3 DP/EP Bonus for 230 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="ryunohige.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 230 then
				return 150 + math.floor(song_data.dp_ep * 0.3)
			else
				return 0
			end
		end,
	},
	{
		id=75,
		name="Rhongomiant",
		desc="A powerful empyrean spear bearing no enchantments, tradition holds that this weapon was bequeathed unto an ancient king of British Coast Stamina by a god. Incredibly effective against large opponents.",
		effect="+150 BP for 230 BPM songs|Lv. 4 EP Bonus for 230 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="rhongomiant.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 230 then
				return 150 + math.floor(song_data.ep * 0.4)
			else
				return 0
			end
		end,
	},
	{
		id=76,
		name="Karambit",
		desc="Powerful knuckles that were perfected by the great mage Abdhaljs, though precious little else is known about their origins. Strongly effective against fast opponents.",
		effect="Lv. 3 DP Bonus for 240 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="karambit.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 240 then
				return math.floor(song_data.dp * 0.3)
			else
				return 0
			end
		end,
	},
	{
		id=77,
		name="Kenkonken",
		desc="The very devices that nearly claimed the eye of the Godfather, these ringed fist weapons are said to have been donned by the minion of an evil puppeteer. A vivid and detailed retelling of this encounter came to have a most profound effect upon the Stamina Corps. Incredibly effective against opponents that are both large and fast.",
		effect="+150 BP for 240 BPM songs|Lv. 4 DP/EP Bonus for 240 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="kenkonken.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 240 then
				return 150 + math.floor(song_data.dp_ep * 0.4)
			else
				return 0
			end
		end,
	},
	{
		id=78,
		name="Verethragna",
		desc="These empyrean claws were named after an ancient god of victory that smote countless thousands with righteous blows. Incredibly effective against large opponents.",
		effect="+200 BP for 240 BPM songs|Lv. 4 EP Bonus for 240 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="verethragna.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 240 then
				return 200 + math.floor(song_data.ep * 0.4)
			else
				return 0
			end
		end,
	},
	{
		id=79,
		name="Azur's Glintstone Staff",
		desc="Staff of the primeval glintstone sorcerer Azur. Only those who have glimpsed what lies beyond the wisdom of stone may wield it. Strongly effective against fast opponents.",
		effect="Lv. 3 DP Bonus for 250 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="azursglintstonestaff.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 250 then
				return math.floor(song_data.dp * 0.3)
			else
				return 0
			end
		end,
	},
	{
		id=80,
		name="Nirvana",
		desc="A powerful staff imbued with the state of gnostic enlightenment that its name implies. Once a sacred relic of the Palace of Speed, it was stolen by Archi to combat the twisted thaumaturgy of the denizens of the evil realms. After bonding to the Godfather and making his will its own, it was no longer able to be returned, and remained in his possession. The exact circumstances of this phenomenon are not altogether clear and shrouded in esoteric mystery. Incredibly effective against opponents that are both large and fast.",
		effect="+150 BP for 250 BPM songs|Lv. 4 DP/EP Bonus for 250 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="nirvana.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 250 then
				return 150 + math.floor(song_data.dp_ep * 0.4)
			else
				return 0
			end
		end,
	},
	{
		id=81,
		name="Hvergelmir",
		desc="Named for a mythical well ensconced deep within Viking Coast Stamina, this empyrean staff is brimming with the power of the old gods. Incredibly effective against large opponents.",
		effect="+200 BP for 250 BPM songs|Lv. 4 EP Bonus for 250 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="hvergelmir.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 250 then
				return 200 + math.floor(song_data.ep * 0.4)
			else
				return 0
			end
		end,
	},
	{
		id=82,
		name="Helphen's Steeple",
		desc="Greatsword patterned after the black steeple of the Helphen, the lampwood which guides the dead of the spirit world. The lamplight is similar to grace in appearance, only it is said that it can only be seen by those who met their death in battle. Strongly effective against fast opponents.",
		effect="Lv. 3 DP Bonus for 260 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="helphenssteeple.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 260 then
				return math.floor(song_data.dp * 0.3)
			else
				return 0
			end
		end,
	},
	{
		id=83,
		name="Burtgang",
		desc="This was once the long sword of the celebrated knight, rawinput, who is still often championed as the very embodiment of chivalry itself. Some say that on one memorable occasion, in an attempt to prove his unflinching loyalty and goodwill to his liege during a training bout, he intentionally sundered the blade. At present, however, the body shows no sign or scar of having been broken or remade. Incredibly effective against opponents that are both large and fast.",
		effect="+150 BP for 260 BPM songs|Lv. 4 DP/EP Bonus for 260 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="burtgang.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 260 then
				return 150 + math.floor(song_data.dp_ep * 0.4)
			else
				return 0
			end
		end,
	},
	{
		id=84,
		name="Almace",
		desc="Empyrean sword of legend from the French Coast, once gifted to a ruler of old. Incredibly effective against large opponents.",
		effect="+200 BP for 260 BPM songs|Lv. 4 EP Bonus for 260 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="almace.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 260 then
				return 200 + math.floor(song_data.ep * 0.4)
			else
				return 0
			end
		end,
	},
	{
		id=85,
		name="Dragonscale Blade",
		desc="A weapon made by sharpening a Gravel Stone scale, thought to bethe source of ancient dragon immortality, into an unclouded blade. Alas, the Dragonkin Soldiers never attained immortality, and perished as decrepit, pale imitations of their skyborn kin. Incredibly effective against fast opponents.",
		effect="Lv. 4 DP Bonus for 270 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="dragonscaleblade.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 270 then
				return math.floor(song_data.dp * 0.4)
			else
				return 0
			end
		end,
	},
	{
		id=86,
		name="Tizona",
		desc="The sword wielded by the Godfather in his younger days. While on his travels it was stripped of him after suffering the only defeat of his life at the hands of a certain mercenary. He later rose up anew, mustering the bravery to again challenge his newfound rival, this time achieving victory and reclaiming the blade. Afterwards the mercenary and Archi came to share a lasting friendship until the end of their days. Incredibly effective against opponents that are both large and fast.",
		effect="+150 BP for 270 BPM songs|Lv. 4 DP/EP Bonus for 270 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="tizona.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 270 then
				return 150 + math.floor(song_data.dp_ep * 0.4)
			else
				return 0
			end
		end,
	},
	{
		id=87,
		name="Caladbolg",
		desc="Rumored to have hewn the tops of mountains, this empyrean blade is feared for its remarkable strength. Maximum effectiveness against large opponents.",
		effect="+150 BP for 270 BPM songs|Lv. 5 EP Bonus for 270 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="caladbolg.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 270 then
				return 150 + math.floor(song_data.ep * 0.5)
			else
				return 0
			end
		end,
	},
	{
		id=88,
		name="Tauret",
		desc="Imbued with a godly essence by the great mage Abdhaljs, this powerful knife crackles with electricity. Incredibly effective against fast opponents.",
		effect="Lv. 4 DP Bonus for 280 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="tauret.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 280 then
				return math.floor(song_data.dp * 0.4)
			else
				return 0
			end
		end,
	},
	{
		id=89,
		name="Carnwenhan",
		desc="Wrought of pure silver and designed for self-defense, legend holds that this dagger was the original counterpart to the great Excalibur, designed to be borne simultaneously by the same divine king of old. Though handed down through generations of bards who carried on the tradition of singing that royal line's glories, it was seized by the Godfather and added to his collection, stating simply that bards, \"don't need daggers to sing.\" Maximum effectiveness against opponents that are both large and fast.",
		effect="+150 BP for 280 BPM songs|Lv. 5 DP/EP Bonus for 280 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="carnwenhan.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 280 then
				return 150 + math.floor(song_data.dp_ep * 0.5)
			else
				return 0
			end
		end,
	},
	{
		id=90,
		name="Twashtar",
		desc="An empyrean dagger named for a god. Its otherworldly beauty is as captivating as the blade is sharp. Maximum effectiveness against large opponents.",
		effect="+200 BP for 280 BPM songs|Lv. 5 EP Bonus for 280 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="twashtar.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 280 then
				return 200 + math.floor(song_data.ep * 0.5)
			else
				return 0
			end
		end,
	},
	{
		id=91,
		name="Annihilator",
		desc="A relic of the past, this early rifle design packs an enormous punch and has informed the engineering of many later generations of weapons. Incredibly effective against fast opponents with a bullet equipped.",
		effect="Lv. 4 DP Bonus for 290 BPM songs with a bullet equipped",
		is_consumable=false,
		is_marathon=false,
		img="annihilator.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if BulletEquipped(relics_used) and song_data.bpm_tier == 290 then
				return math.floor(song_data.dp * 0.4)
			else
				return 0
			end
		end,
	},
	{
		id=92,
		name="Death Penalty",
		desc="As its name implies, this high-caliber firearm earned its moniker by doling out swift and often fatal retribution. It was long the beloved weapon of choice of the infamous cattle rustler, Rust. Still somewhat unbelievable stories abound of the pistol's sheer destructive force, said to be such that it once sank a great battleship by blowing a hole clean through the hull. Maximum effectiveness against opponents that are both large and fast with a bullet equipped.",
		effect="+150 BP for 290 BPM songs with a bullet equipped|Lv. 5 DP/EP Bonus for 290 BPM songs with a bullet equipped",
		is_consumable=false,
		is_marathon=false,
		img="deathpenalty.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if BulletEquipped(relics_used) and song_data.bpm_tier == 290 then
				return 150 + math.floor(song_data.dp_ep * 0.5)
			else
				return 0
			end
		end,
	},
	{
		id=93,
		name="Armageddon",
		desc="This firearm is an empyrean masterpiece of worksmanship. Its keen and ornate design is rivaled only by its destructive capacity. Maximum effectiveness against large opponents with a bullet equipped.",
		effect="+200 BP for 290 BPM songs with a bullet equipped|Lv. 5 EP Bonus for 290 BPM songs with a bullet equipped",
		is_consumable=false,
		is_marathon=false,
		img="armageddon.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if BulletEquipped(relics_used) and song_data.bpm_tier == 290 then
				return 200 + math.floor(song_data.ep * 0.5)
			else
				return 0
			end
		end,
	},
	{
		id=94,
		name="Maxentius",
		desc="Named for an emperor of old, this wand has been augmented with immense energies by none other than the great mage Abdhaljs. Incredibly effective against fast opponents.",
		effect="Lv. 4 DP Bonus for 300 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="maxentius.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 300 then
				return math.floor(song_data.dp * 0.4)
			else
				return 0
			end
		end,
	},
	{
		id=95,
		name="Yagrush",
		desc="Also known by its alias, \"Chaser,\" this robust red sandalwood club is plated in phosphorescent gold and exquisitely encrusted with an array of magically imbued sacred stones. It is said to have been the weapon of choice for the legendary vicar, The Cosmic Pope, who commissioned its creation to master crafter priests specifically for high sea encounters with the dreaded Dragons of Force. Maximum effectiveness against opponents that are both large and fast.",
		effect="+150 BP for 300 BPM songs|Lv. 5 DP/EP Bonus for 300 BPM songs",
		is_consumable=false,
		is_marathon=false,
		img="yagrush.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			if song_data.bpm_tier == 300 then
				return 150 + math.floor(song_data.dp_ep * 0.5)
			else
				return 0
			end
		end,
	},
	{
		id=96,
		name="Mario For Enterprise",
		desc="Eschewing all ethical considerations, this Mario has pursued faster and more efficient business processes and grown his company (and his earnings) to immense proportions-- but with the twin specters of horrific worker exploitation and environmental disregard, he exists as a cautionary tale.",
		effect="None",
		is_consumable=true,
		is_marathon=false,
		img="marioforenterprise.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 0
		end,
	},
	{
		id=97,
		name="Shambling Mario",
		desc="Shambling Mario exists in a perpetual state of undeath, cursed to forever wander the realm as punishment for bygone transgressions against deities that have long fallen out of worship. Will the day come when he is freed from his everlasting torment?",
		effect="None",
		is_consumable=true,
		is_marathon=false,
		img="shamblingmario.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 0
		end,
	},
	{
		id=98,
		name="Mario the Elder",
		desc="In days long past, a young Mario grew up in a deeply agrarian community, and came to be respected by his neighbors as a wise and even-handed arbiter in disputes. After many years serving as the de facto village chief, well, this is that Mario.",
		effect="None",
		is_consumable=true,
		is_marathon=false,
		img="mariotheelder.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 0
		end,
	},
	{
		id=99,
		name="Arquebus",
		desc="A primitive but effective firearm, this heavy gun is a bit impractical. You'll be able to fire bullets from it at least, though!",
		effect="+0 BP",
		is_consumable=false,
		is_marathon=false,
		img="arquebus.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 0
		end,
	},
	{
		id=100,
		name="Kaja Sword",
		desc="Full of potential, the relic now known as 'Kaja Sword' seems to be an ancient blade with illegible engravings bearing a meaning lost to time.",
		effect="+175 BP",
		is_consumable=false,
		is_marathon=false,
		img="kajasword.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 175
		end,
	},
	{
		id=101,
		name="Abdhaljs Matter",
		desc="This undocumented material is rumored to be used for upgrading weapons, but otherwise, all that is known about this strange substance is that it's believed to have been created by the great mage Abdhaljs.",
		effect="None",
		is_consumable=false,
		is_marathon=false,
		img="abdhaljsmatter.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 0
		end,
	},
	{
		id=102,
		name="Router",
		desc="A pulse weapon once claimed by a great yztarg, this great axe is wreathed with inextinguishable flame.",
		effect="+100 BP",
		is_consumable=false,
		is_marathon=false,
		img="router.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 100
		end,
	},
	{
		id=103,
		name="Naegling",
		desc="Restored to its former glory, this weapon's runes and powerful aura recall its use as an arm of a famous hero of the Viking Coast. ",
		effect="+300 BP",
		is_consumable=false,
		is_marathon=false,
		img="naegling.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 300
		end,
	},
	{
		id=104,
		name="Pendulum Blade",
		desc="One of those swinging-blade dungeon traps. It's not clear how you would use this without inflicting injury on yourself. Incredibly effective against difficult opponents.",
		effect="+200 BP|Lv. 4 RP Bonus|Forces life 5",
		is_consumable=false,
		is_marathon=false,
		img="pendulumblade.png",
		action=function(relics_used)
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				local cur_life_scale = PREFSMAN:GetPreference("LifeDifficultyScale")
				if cur_life_scale == 1.0 or (cur_life_scale ~= 1.0 and cur_life_scale < 0.8) then
					PREFSMAN:SetPreference("LifeDifficultyScale", 0.8)
					SM("Set to Life 5")
				end
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			local max_division_rp = 1000 * (1 + (song_info.MaxBlockLevel-song_info.MinBlockLevel))
			return 200 + math.floor(song_data.rp/(max_division_rp/1000) * 0.4)
		end,
	},
	{
		id=105,
		name="Red Angus #72",
		desc="Moo cow",
		effect="None",
		is_consumable=true,
		is_marathon=false,
		img="redangus72.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 0
		end,
	},
	{
		id=106,
		name="Bedlam",
		desc="Cursed by Aulis, the ancient god of the Grigori, this corrupted blade is immensely threatening to foe and wielder alike.",
		effect="+700 BP|30 seconds removed from break timer",
		is_consumable=false,
		is_marathon=false,
		img="bedlam.png",
		action=function(relics_used)
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEvaluationStage" then
				ECS.BreakTimer = ECS.BreakTimer - 30
				if ECS.BreakTimer < 0 then
					ECS.BreakTimer = 0
				end
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 700
		end,
	},
	{
		id=107,
		name="Onion Sword",
		desc="Basic gear issued to staminadventurers by the Stamina Corps.",
		effect="+20 BP",
		is_consumable=false,
		is_marathon=false,
		img="onionsword.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 20
		end,
	},
	{
		id=108,
		name="Grains of Chronos Sand",
		desc="The sand in this pouch is said to have been stolen from the god of time. Perhaps in a time of need, it could help you reclaim some lost moments.",
		effect="30 seconds added to break timer",
		is_consumable=true,
		is_marathon=false,
		img="grainsofchronossand.png",
		action=function(relics_used)
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEvaluationStage" then
				local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber())
				local failed = pss:GetFailed()
				if not failed then
					ECS.BreakTimer = ECS.BreakTimer + 30
				end
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 0
		end,
	},
	{
		id=109,
		name="Shield Rod",
		desc="A many-eyed rod that draws out the hidden properties of shields.",
		effect="+100 BP|With Scrupulous Shield equipped: Lv. 6 AP Bonus|With Alacritous Aspis equipped: Lv. 5 DP Bonus|With Indefatigable Escutcheon equipped: Lv. 6 EP Bonus|With Ochain equipped: Forces life 2",
		is_consumable=true,
		is_marathon=false,
		img="shieldrod.png",
		action=function(relics_used)
			for relic in ivalues(relics_used) do
				local name = relic.name
				if name == "Ochain" then
					if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
						local cur_life_scale = PREFSMAN:GetPreference("LifeDifficultyScale")
						if cur_life_scale == 1.0 or (cur_life_scale ~= 1.0 and cur_life_scale < 1.6) then
							PREFSMAN:SetPreference("LifeDifficultyScale", 1.4)
							SM("Set to Life 2")
						end
					end
				end
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			local bp = 100

			for relic in ivalues(relics_used) do
				local name = relic.name
				if name == "Scrupulous Shield" then
					bp = bp + math.floor(ap * 0.6)
				end
				if name == "Alacritous Aspis" then
					bp = bp + math.floor(song_data.dp * 0.5)
				end
				if name == "Indefatigable Escutcheon" then
					bp = bp + math.floor(song_data.ep * 0.6)
				end
			end

			return bp
		end,
	},
	{
		id=110,
		name="Mablung Sword",
		desc="Legend has it this blade steeped in aetheric energy was the main arm of an elf from the age of myths. It has the ability to fortify the nature of any shield paired with it to tremendous effect.",
		effect="+300 BP|With Scrupulous Shield equipped: Lv. 12 AP Bonus|With Alacritous Aspis equipped: Lv. 11 DP Bonus|With Indefatigable Escutcheon equipped: Lv. 12 EP Bonus|With Ochain equipped: Forces life 1",
		is_consumable=true,
		is_marathon=false,
		img="mablungsword.png",
		action=function(relics_used)
			for relic in ivalues(relics_used) do
				local name = relic.name
				if name == "Ochain" then
					if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
						local cur_life_scale = PREFSMAN:GetPreference("LifeDifficultyScale")
						if cur_life_scale == 1.0 or (cur_life_scale ~= 1.0 and cur_life_scale < 1.6) then
							PREFSMAN:SetPreference("LifeDifficultyScale", 1.6)
							SM("Set to Life 1")
						end
					end
				end
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			local bp = 300

			for relic in ivalues(relics_used) do
				local name = relic.name
				if name == "Scrupulous Shield" then
					bp = bp + math.floor(ap * 12)
				end
				if name == "Alacritous Aspis" then
					bp = bp + math.floor(song_data.dp * 11)
				end
				if name == "Indefatigable Escutcheon" then
					bp = bp + math.floor(song_data.ep * 12)
				end
			end

			return bp
		end,
	},
	{
		id=111,
		name="Ochain",
		desc="This mighty shield, born of empyrean origins, offers unparalleled protection in combat.",
		effect="Forces life 3",
		is_consumable=true,
		is_marathon=false,
		img="ochain.png",
		action=function(relics_used)
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				local cur_life_scale = PREFSMAN:GetPreference("LifeDifficultyScale")
				if cur_life_scale == 1.0 or (cur_life_scale ~= 1.0 and cur_life_scale < 1.2) then
					PREFSMAN:SetPreference("LifeDifficultyScale", 1.2)
					SM("Set to Life 3")
				end
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 0
		end,
	},
	{
		id=112,
		name="Sword Familiar",
		desc="Formerly sealed in the form of a card, this sentient weapon's strength grows as you become more experienced.",
		effect="+BP based on Lifetime EXP (Max 200)",
		is_consumable=false,
		is_marathon=false,
		img="swordfamiliar.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return math.floor(200 * (ecs_player.level / 100))
		end,
	},
	{
		id=113,
		name="Bronze Trophy",
		desc="The Stamina Corps awards these trophies to fledgling staminadventurers as thanks for their good deeds.",
		effect="Access to #bronze-bistro on the Stamina Nation discord (upon request)",
		is_consumable=false,
		is_marathon=false,
		img="bronzetrophy.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 0
		end,
	},
	{
		id=114,
		name="Mythril Trophy",
		desc="A trophy made from a rare metal. Only given to those who have made substantial contributions to the Stamina Nation.",
		effect="Access to #mythril-lounge on the Stamina Nation discord (upon request)",
		is_consumable=false,
		is_marathon=false,
		img="mythriltrophy.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 0
		end,
	},
	{
		id=115,
		name="Crystal Trophy",
		desc="Awarded to high class staminadventurers for exceptional achievements.",
		effect="Access to #crystal-cafe on the Stamina Nation discord (upon request)",
		is_consumable=false,
		is_marathon=false,
		img="crystaltrophy.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 0
		end,
	},
	{
		id=116,
		name="Ivory Trophy",
		desc="Given only to the greatest staminadventurers across all the lands.",
		effect="Access to #ivory-tower on the Stamina Nation discord (upon request)",
		is_consumable=false,
		is_marathon=false,
		img="ivorytrophy.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 0
		end,
	},
	{
		id=117,
		name="TPA Standard",
		desc="A banner commonly flown in battle by TPA regiments.",
		effect="At end of set, +100 BP for each song with a 95% or higher",
		is_consumable=true,
		is_marathon=false,
		img="tpastandard.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			-- End of set relics are handled in ScreenGameOver
			return 0
		end,
	},
	{
		id=118,
		name="Scrupulous Shield",
		desc="A kite shield featuring DPRT heraldry. Enhanced by the accuracy of your attacks.",
		effect="Lv. 2 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="scrupulousshield.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return math.floor(ap * 0.2)
		end,
	},
	{
		id=119,
		name="Virtue Blade",
		desc="This holy sword is bursting with righteous energy, but is only capable of being used to its fullest extent by a precise swordsman. Strongly enhanced by the accuracy of your attacks,",
		effect="+100 BP if score is a 99% or higher|Lv. 3 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="virtueblade.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			local bp = 0
			if score >= 0.99 then
				bp = bp + 100
			end
			return bp + math.floor(ap * 0.3)
		end,
	},
	{
		id=120,
		name="Astral Ring",
		desc="Ring that possesses a magic enchantment to deter The Bois when you're facing marathon beasts.",
		effect="WayOffs/Decents Off",
		is_consumable=true,
		is_marathon=true,
		img="astralring.png",
		action=function(relics_used)
			-- TODO(teejusb): DO THIS DIFFERENTLY FOR ITGmania!
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				SL.Global.ActiveModifiers.TimingWindows = {true,true,true,false,false}
				PREFSMAN:SetPreference("TimingWindowSecondsW4", SL.Preferences.ITG.TimingWindowSecondsW3)
				PREFSMAN:SetPreference("TimingWindowSecondsW5", SL.Preferences.ITG.TimingWindowSecondsW3)
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 0
		end,
	},
	{
		id=121,
		name="Flawless Iluvatar ",
		desc="A divine blade passed down through generations of DPRT warriors, this perfect sword can only be truly harnessed by those who can wield it impeccably. Transcendentally enhanced by the accuracy of your attacks.",
		effect="+200 BP if score is a 99% or higher|Lv. 6 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="flawlessiluvatar.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			local bp = 0
			if score >= 0.99 then
				bp = bp + 200
			end
			return bp + math.floor(ap * 0.6)
		end,
	},
	{
		id=122,
		name="Memepeace Beret",
		desc="Standard-issue headwear for new Memepeace employees.",
		effect="At end of set, +100 BP for each song with a different speed tier 210 and above",
		is_consumable=true,
		is_marathon=false,
		img="memepeaceberet.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			-- End of set relics are handled in ScreenGameOver
			return 0
		end,
	},
	{
		id=123,
		name="Alacritous Aspis",
		desc="A small shield emblazoned with the colors of the Footspeed Empire. Strongly effective against fast opponents.",
		effect="Lv. 3 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="alacritousaspis.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return math.floor(song_data.dp * 0.3)
		end,
	},
	{
		id=124,
		name="Principia",
		desc="A magically enhanced dagger that can be difficult to use. Strongly effective against fast opponents.",
		effect="+300 BP|Lv. 3 DP Bonus|Forces 1.02x rate",
		is_consumable=false,
		is_marathon=false,
		img="principia.png",
		action=function(relics_used)
			if SCREENMAN:GetTopScreen():GetName() == "ScreenGameplay" then
				GAMESTATE:ApplyGameCommand("mod,1.02xmusic")
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 300 + math.floor(song_data.dp * 0.3)
		end,
	},
	{
		id=125,
		name="Arvin's Gambit",
		desc="Well-known set of playing cards from the Footspeed Empire. Highly prized for their magical qualities.",
		effect="If equipped, and you fail the marathon, you may reattempt it immediately with up to 20 additional minutes to warm up/fix the pads.",
		is_consumable=true,
		is_marathon=true,
		img="arvinsgambit.png",
		action=function(relics_used)
			-- NOTE(teejusb): Handled in Graphics/_header.lua
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 0
		end,
	},
	{
		id=126,
		name="Almagest",
		desc="Enchanted with magic that can bring forth concentrated hurricane-force winds, few are capable of wielding this ultimate dagger. Transcendentally effective against fast opponents.",
		effect="+300 BP|Lv. 10 DP Bonus|Forces 1.05x rate",
		is_consumable=false,
		is_marathon=false,
		img="almagest.png",
		action=function(relics_used)
			if SCREENMAN:GetTopScreen():GetName() == "ScreenGameplay" then
				local songOptions = GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred")
				GAMESTATE:ApplyGameCommand("mod,1.05xmusic")
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 300 + math.floor(song_data.dp * 1.0)
		end,
	},
	{
		id=127,
		name="Slime Badge",
		desc="A cheaply made badge presented to you by the Stamina Corps for services rendered.",
		effect="At end of set, +100 BP for each song with a different speed tier 200 and below",
		is_consumable=true,
		is_marathon=false,
		img="slimebadge.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			-- End of set relics are handled in ScreenGameOver
			return 0
		end,
	},
	{
		id=128,
		name="Indefatigable Escutcheon",
		desc="Shield bearing the coat of arms of the Stamina Nation. Effective against large opponents.",
		effect="Lv. 2 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="indefatigableescutcheon.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return math.floor(song_data.ep * 0.2)
		end,
	},
	{
		id=129,
		name="Bloody Helice",
		desc="Ominous piercing sword with a winding blade. Carried by the noble servants of the Lord of Blood. Designed to bore into flesh, causing severe blood loss at the wound. The extracted blood trickles gracefully down the length of the blade.",
		effect="+20 BP per minute of song length|9% of song length added to break timer",
		is_consumable=false,
		is_marathon=false,
		img="bloodyhelice.png",
		action=function(relics_used)
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEvaluationStage" then
				local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber())
				local failed = pss:GetFailed()
				if not failed then
					local length = GAMESTATE:GetCurrentSong():MusicLengthSeconds()
					if length then
						-- BreakTimer is in seconds.
						ECS.BreakTimer = ECS.BreakTimer + (length * 0.09)
					end
				end
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return math.floor(song_data.length * 20)
		end,
	},
	{
		id=130,
		name="Faust's Scalpel",
		desc="This massive scalpel has the ability to split marathon beasts in two.",
		effect="If equipped, the marathon is split into two parts, and you may take up to five minutes of break between them.",
		is_consumable=true,
		is_marathon=true,
		img="faustsscalpel.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 0
		end,
	},
	{
		id=131,
		name="Muramasa",
		desc="An ancient and bloodthirsty weapon from Japan Coast Stamina, this katana's effectivity against large opponents is peerless.",
		effect="+50 BP per minute of song length|18% of song length added to break timer",
		is_consumable=false,
		is_marathon=false,
		img="muramasa.png",
		action=function(relics_used)
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEvaluationStage" then
				local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber())
				local failed = pss:GetFailed()
				if not failed then
					local length = GAMESTATE:GetCurrentSong():MusicLengthSeconds()
					if length then
						-- BreakTimer is in seconds.
						ECS.BreakTimer = ECS.BreakTimer + (length * 0.18)
					end
				end
			end
		end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return math.floor(song_data.length * 50)
		end,
	},
	{
		id=132,
		name="Order of Ambrosia",
		desc="The greatest of honors bestowed upon staminadventurers.",
		effect="Allows user to equip an additional two relics",
		is_consumable=true,
		is_marathon=false,
		img="orderofambrosia.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 0
		end,
	},
	{
		id=133,
		name="Champion Belt",
		desc="Belt presented to the greatest champions of Stamina Nation. Single use.",
		effect="+100 BP|Allows user to equip one additional relic",
		is_consumable=true,
		is_marathon=false,
		img="championbelt.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 100
		end,
	},
	{
		id=134,
		name="Godfather's Token",
		desc="The Godfather of Stamina presents this literal token of his gratitude in thanks for financial contributions to the Stamina Nation.",
		effect="None",
		is_consumable=false,
		is_marathon=false,
		img="godfatherstoken.png",
		action=function(relics_used) end,
		score=function(ecs_player, song_info, song_data, relics_used, ap, score)
			return 0
		end,
	},
}



ECS.GetRelicNames = function( list )
	-- if a player's list of relics isn't passed, use the master list
	if not list then list = ECS.Relics end

	local names = {}
	for relic in ivalues(list) do
		names[#names+1] = relic.name
	end
	return names
end

-- ------------------------------------------------------
-- Song Data

ECS.SongInfo = {}
ECS.SongInfo.Lower = {
	-- These values will be calculated and set below.
	MinBpm = 0,
	MaxBpm = 0,
	MinScaled16ths = 0,
	MaxScaled16ths = 0,
	MinBlockLevel = 0,
	MaxBlockLevel = 0,
	MinLength = 0,
	Songs = {
		{
			id=1,
			name="[12] [130] Discovery",
			stepartist="StoryTime",
			pack="StoryTime Chapter 1",
			difficulty=12,
			steps=1931,
			bpm_tier=130,
			measures=110,
			adj_stream=0.7971,
			bpm=130,
			length=4.4,
			dp=0, ep=1000, dp_ep=363, rp=1000,
		},
		{
			id=2,
			name="[12] [136] The Ones We Loved (Dogzilla Remix)",
			stepartist="t0ni",
			pack="TranceMania 3",
			difficulty=12,
			steps=1927,
			bpm_tier=130,
			measures=86,
			adj_stream=0.6772,
			bpm=136,
			length=4.94,
			dp=200, ep=800, dp_ep=363, rp=1000,
		},
		{
			id=3,
			name="[12] [133] Crazy Loop (Mm Ma Ma)",
			stepartist="Xynn",
			pack="Xynn's LVTS 2",
			difficulty=12,
			steps=1457,
			bpm_tier=130,
			measures=82,
			adj_stream=0.7664,
			bpm=133,
			length=3.55,
			dp=100, ep=934, dp_ep=410, rp=1000,
		},
		{
			id=4,
			name="[12] [135] I'm Coming",
			stepartist="sorae",
			pack="Big Waves",
			difficulty=12,
			steps=1113,
			bpm_tier=130,
			measures=54,
			adj_stream=0.7297,
			bpm=135,
			length=2.9,
			dp=167, ep=600, dp_ep=46, rp=1000,
		},
		{
			id=5,
			name="[12] [140] Higanbana (Autobahn Remix)",
			stepartist="t3a",
			pack="moimoimoimoimoi",
			difficulty=12,
			steps=1784,
			bpm_tier=140,
			measures=89,
			adj_stream=0.6544,
			bpm=140,
			length=4.43,
			dp=334, ep=734, dp_ep=456, rp=1000,
		},
		{
			id=6,
			name="[12] [145] Pernicious Deed",
			stepartist="Nav",
			pack="Nav's Spicy Singles",
			difficulty=12,
			steps=1892,
			bpm_tier=140,
			measures=84,
			adj_stream=0.5316,
			bpm=145,
			length=5.6,
			dp=500, ep=534, dp_ep=410, rp=1000,
		},
		{
			id=7,
			name="[12] [146] Wastelands",
			stepartist="Janus5k",
			pack="Mozee Metal",
			difficulty=12,
			steps=1807,
			bpm_tier=140,
			measures=81,
			adj_stream=0.609,
			bpm=146,
			length=4.55,
			dp=534, ep=667, dp_ep=638, rp=1000,
		},
		{
			id=8,
			name="[12] [140] Zi-Zi's Journey",
			stepartist="Okami",
			pack="Lindsey Stirling",
			difficulty=12,
			steps=1373,
			bpm_tier=140,
			measures=77,
			adj_stream=0.7476,
			bpm=140,
			length=3.29,
			dp=334, ep=867, dp_ep=638, rp=1000,
		},
		{
			id=9,
			name="[12] [150] The Sampling Paradise (Extended)",
			stepartist="Rems",
			pack="SlowStreamz",
			difficulty=12,
			steps=2126,
			bpm_tier=150,
			measures=64,
			adj_stream=0.3596,
			bpm=150,
			length=5.12,
			dp=667, ep=267, dp_ep=273, rp=1000,
		},
		{
			id=10,
			name="[12] [150] Lifelight (Camellia's Hardstyle Bootleg)",
			stepartist="Okami",
			pack="StS",
			difficulty=12,
			steps=1435,
			bpm_tier=150,
			measures=55,
			adj_stream=0.4911,
			bpm=150,
			length=4.03,
			dp=667, ep=334, dp_ep=365, rp=1000,
		},
		{
			id=11,
			name="[12] [150] Blood Is Pumpin' (Hard)",
			stepartist="Rems",
			pack="SlowStreamz",
			difficulty=12,
			steps=1891,
			bpm_tier=150,
			measures=49,
			adj_stream=0.3063,
			bpm=150,
			length=5.52,
			dp=667, ep=67, dp_ep=0, rp=1000,
		},
		{
			id=12,
			name="[12] [156] Wheelpower & Go",
			stepartist="Zaia",
			pack="Eurobeat Is Fantastic",
			difficulty=12,
			steps=1528,
			bpm_tier=150,
			measures=43,
			adj_stream=0.3094,
			bpm=156,
			length=3.77,
			dp=867, ep=0, dp_ep=182, rp=1000,
		},
		{
			id=13,
			name="[12] [160] Drink",
			stepartist="Janus5k",
			pack="Squirrel Metal II",
			difficulty=12,
			steps=1612,
			bpm_tier=160,
			measures=62,
			adj_stream=0.5536,
			bpm=160,
			length=3.32,
			dp=1000, ep=467, dp_ep=1000, rp=1000,
		},
		{
			id=14,
			name="[12] [160] Gimme Your Desire (Hard)",
			stepartist="Rems",
			pack="Eurobeat Is Fantastic - Second Stage",
			difficulty=12,
			steps=1273,
			bpm_tier=160,
			measures=55,
			adj_stream=0.5914,
			bpm=160,
			length=2.9,
			dp=1000, ep=400, dp_ep=909, rp=1000,
		},
		{
			id=15,
			name="[12] [160] When the Sun Goes Down (Medium)",
			stepartist="Arvin",
			pack="Eurobeat Is Fantastic",
			difficulty=12,
			steps=1638,
			bpm_tier=160,
			measures=53,
			adj_stream=0.4015,
			bpm=160,
			length=4.35,
			dp=1000, ep=200, dp_ep=636, rp=1000,
		},
		{
			id=16,
			name="[12] [160] Stay Awake (Hard)",
			stepartist="ITGAlex",
			pack="Hospitality",
			difficulty=12,
			steps=1114,
			bpm_tier=160,
			measures=47,
			adj_stream=0.4123,
			bpm=160,
			length=3.4,
			dp=1000, ep=134, dp_ep=546, rp=1000,
		},
		{
			id=17,
			name="[13] [138] Deep Jungle Walk",
			stepartist="yutsi",
			pack="yutsi-type beats",
			difficulty=13,
			steps=3478,
			bpm_tier=130,
			measures=198,
			adj_stream=0.8082,
			bpm=138,
			length=7.62,
			dp=140, ep=1000, dp_ep=805, rp=2000,
		},
		{
			id=18,
			name="[13] [138] Alone Tonight (Ronski Speed Remix)",
			stepartist="Rems",
			pack="SlowStreamz",
			difficulty=13,
			steps=3305,
			bpm_tier=130,
			measures=190,
			adj_stream=0.819,
			bpm=138,
			length=7.33,
			dp=140, ep=948, dp_ep=723, rp=2000,
		},
		{
			id=19,
			name="[13] [132] No Shields",
			stepartist="Fietsemaker",
			pack="SlowStreamz",
			difficulty=13,
			steps=2290,
			bpm_tier=130,
			measures=135,
			adj_stream=0.8766,
			bpm=132,
			length=5.21,
			dp=0, ep=895, dp_ep=418, rp=2000,
		},
		{
			id=20,
			name="[13] [134] March of the ants",
			stepartist="Tuuc",
			pack="The Starter Pack of Stamina",
			difficulty=13,
			steps=1652,
			bpm_tier=130,
			measures=101,
			adj_stream=0.9902,
			bpm=134,
			length=3.43,
			dp=47, ep=790, dp_ep=327, rp=2000,
		},
		{
			id=21,
			name="[13] [145] Sa'eed",
			stepartist="Okami",
			pack="SlowStreamz",
			difficulty=13,
			steps=2881,
			bpm_tier=140,
			measures=153,
			adj_stream=0.6955,
			bpm=145,
			length=6.62,
			dp=303, ep=685, dp_ep=565, rp=2000,
		},
		{
			id=22,
			name="[13] [140] Set Me On Fire (Novice)",
			stepartist="Archi",
			pack="Pendulum Act III",
			difficulty=13,
			steps=2391,
			bpm_tier=140,
			measures=142,
			adj_stream=0.8402,
			bpm=140,
			length=5.09,
			dp=187, ep=843, dp_ep=631, rp=2000,
		},
		{
			id=23,
			name="[13] [148] Virtual Pilgrim",
			stepartist="Okami",
			pack="StS",
			difficulty=13,
			steps=2146,
			bpm_tier=140,
			measures=119,
			adj_stream=0.8623,
			bpm=148,
			length=4.22,
			dp=373, ep=737, dp_ep=758, rp=2000,
		},
		{
			id=24,
			name="[13] [140] Switch !",
			stepartist="Rems",
			pack="Eurobeat Is Fantastic",
			difficulty=13,
			steps=2259,
			bpm_tier=140,
			measures=117,
			adj_stream=0.7905,
			bpm=140,
			length=5.03,
			dp=187, ep=632, dp_ep=299, rp=2000,
		},
		{
			id=25,
			name="[13] [155] Aphasia",
			stepartist="Okami",
			pack="Team Grimoire",
			difficulty=13,
			steps=2057,
			bpm_tier=150,
			measures=97,
			adj_stream=0.6736,
			bpm=155,
			length=3.98,
			dp=535, ep=527, dp_ep=682, rp=2000,
		},
		{
			id=26,
			name="[13] [154] Deja Vu",
			stepartist="Arvin & Rems",
			pack="Eurobeat Is Fantastic",
			difficulty=13,
			steps=1996,
			bpm_tier=150,
			measures=94,
			adj_stream=0.6763,
			bpm=154,
			length=4.13,
			dp=512, ep=474, dp_ep=562, rp=2000,
		},
		{
			id=27,
			name="[13] [150] CHAOS",
			stepartist="Okami",
			pack="Cytus II",
			difficulty=13,
			steps=1732,
			bpm_tier=150,
			measures=91,
			adj_stream=0.7339,
			bpm=150,
			length=3.71,
			dp=419, ep=579, dp_ep=581, rp=2000,
		},
		{
			id=28,
			name="[13] [150] Louder",
			stepartist="Kyy",
			pack="Hardbass Madness",
			difficulty=13,
			steps=2021,
			bpm_tier=150,
			measures=86,
			adj_stream=0.5772,
			bpm=150,
			length=4.4,
			dp=419, ep=211, dp_ep=0, rp=2000,
		},
		{
			id=29,
			name="[13] [162] Uh...Man",
			stepartist="StoryTime",
			pack="Jayrocking",
			difficulty=13,
			steps=1890,
			bpm_tier=160,
			measures=91,
			adj_stream=0.6408,
			bpm=162,
			length=3.78,
			dp=698, ep=369, dp_ep=690, rp=2000,
		},
		{
			id=30,
			name="[13] [160] Fright March",
			stepartist="StarrySergal",
			pack="itg! Rhythm is just a step away",
			difficulty=13,
			steps=1280,
			bpm_tier=160,
			measures=68,
			adj_stream=0.7907,
			bpm=160,
			length=2.72,
			dp=652, ep=422, dp_ep=701, rp=2000,
		},
		{
			id=31,
			name="[13] [165] P.L.U.C.K. (Medium)",
			stepartist="Aoreo",
			pack="System of a Down",
			difficulty=13,
			steps=1520,
			bpm_tier=160,
			measures=67,
			adj_stream=0.6505,
			bpm=165,
			length=3.42,
			dp=768, ep=106, dp_ep=385, rp=2000,
		},
		{
			id=32,
			name="[13] [160] The Top",
			stepartist="Zaia",
			pack="Eurobeat Is Fantastic",
			difficulty=13,
			steps=1457,
			bpm_tier=160,
			measures=62,
			adj_stream=0.6019,
			bpm=160,
			length=3.22,
			dp=652, ep=53, dp_ep=119, rp=2000,
		},
		{
			id=33,
			name="[13] [175] Timeleap",
			stepartist="Rems",
			pack="Comiket 95",
			difficulty=13,
			steps=2023,
			bpm_tier=170,
			measures=86,
			adj_stream=0.6232,
			bpm=165,
			length=4.23,
			dp=768, ep=316, dp_ep=717, rp=2000,
		},
		{
			id=34,
			name="[13] [170] Alphaseeker",
			stepartist="ITGAlex",
			pack="Bass Chasers",
			difficulty=13,
			steps=1194,
			bpm_tier=170,
			measures=66,
			adj_stream=0.6804,
			bpm=170,
			length=3.27,
			dp=884, ep=158, dp_ep=650, rp=2000,
		},
		{
			id=35,
			name="[13] [175] Sakura Fubuki (Ata Remix)",
			stepartist="ITGAlex",
			pack="ITGAlex's Stamina Safari",
			difficulty=13,
			steps=1237,
			bpm_tier=170,
			measures=63,
			adj_stream=0.7159,
			bpm=175,
			length=2.83,
			dp=1000, ep=264, dp_ep=1000, rp=2000,
		},
		{
			id=36,
			name="[13] [174] Come & Get It",
			stepartist="StoryTime",
			pack="Hospitality",
			difficulty=13,
			steps=1267,
			bpm_tier=170,
			measures=57,
			adj_stream=0.5534,
			bpm=174,
			length=3.03,
			dp=977, ep=0, dp_ep=548, rp=2000,
		},
		{
			id=37,
			name="[14] [143] Eskimo & Icebird Megamix",
			stepartist="Xynn",
			pack="Xynn's LVTS 2",
			difficulty=14,
			steps=8302,
			bpm_tier=140,
			measures=461,
			adj_stream=0.7317,
			bpm=140,
			length=18.37,
			dp=0, ep=1000, dp_ep=286, rp=3000,
		},
		{
			id=38,
			name="[14] [140] Dreamenddischarger",
			stepartist="Okami",
			pack="SlowStreamz",
			difficulty=14,
			steps=4638,
			bpm_tier=140,
			measures=277,
			adj_stream=0.8602,
			bpm=140,
			length=9.37,
			dp=0, ep=950, dp_ep=143, rp=3000,
		},
		{
			id=39,
			name="[14] [144] Dog Days Bliss (Album Edit)",
			stepartist="yutsi",
			pack="yutsi-type beats",
			difficulty=14,
			steps=4436,
			bpm_tier=140,
			measures=249,
			adj_stream=0.8527,
			bpm=144,
			length=8.89,
			dp=100, ep=850, dp_ep=143, rp=3000,
		},
		{
			id=40,
			name="[14] [147] Moscow 3980",
			stepartist="Al_Isa",
			pack="SlowStreamz",
			difficulty=14,
			steps=4273,
			bpm_tier=140,
			measures=249,
			adj_stream=0.9055,
			bpm=147,
			length=7.97,
			dp=175, ep=900, dp_ep=500, rp=3000,
		},
		{
			id=41,
			name="[14] [145] Mala",
			stepartist="Rems",
			pack="SlowStreamz",
			difficulty=14,
			steps=3508,
			bpm_tier=140,
			measures=209,
			adj_stream=0.9048,
			bpm=145,
			length=7.37,
			dp=125, ep=800, dp_ep=72, rp=3000,
		},
		{
			id=42,
			name="[14] [158] Full Circle",
			stepartist="Fietsemaker",
			pack="Big Waves",
			difficulty=14,
			steps=3459,
			bpm_tier=150,
			measures=174,
			adj_stream=0.719,
			bpm=158,
			length=7.44,
			dp=450, ep=650, dp_ep=572, rp=3000,
		},
		{
			id=43,
			name="[14] [154] Gas Gas Gas",
			stepartist="Honk",
			pack="Eurobeat Is Fantastic",
			difficulty=14,
			steps=2443,
			bpm_tier=150,
			measures=143,
			adj_stream=0.8363,
			bpm=154,
			length=4.52,
			dp=350, ep=750, dp_ep=572, rp=3000,
		},
		{
			id=44,
			name="[14] [158] Granblaze",
			stepartist="ITGAlex",
			pack="ITGAlex's Stamina Singles",
			difficulty=14,
			steps=2113,
			bpm_tier=150,
			measures=121,
			adj_stream=0.761,
			bpm=158,
			length=4.58,
			dp=450, ep=550, dp_ep=286, rp=3000,
		},
		{
			id=45,
			name="[14] [155] Grimoire of Blue",
			stepartist="Okami",
			pack="Team Grimoire",
			difficulty=14,
			steps=1784,
			bpm_tier=150,
			measures=104,
			adj_stream=1,
			bpm=155,
			length=3.87,
			dp=375, ep=700, dp_ep=500, rp=3000,
		},
		{
			id=46,
			name="[14] [160] Katamari on the Rocks",
			stepartist="Xynn",
			pack="Xynn's LVTS 2",
			difficulty=14,
			steps=3144,
			bpm_tier=160,
			measures=148,
			adj_stream=0.682,
			bpm=160,
			length=5.88,
			dp=500, ep=600, dp_ep=572, rp=3000,
		},
		{
			id=47,
			name="[14] [160] Hooligans",
			stepartist="Rems",
			pack="Eurobeat Is Fantastic",
			difficulty=14,
			steps=2100,
			bpm_tier=160,
			measures=105,
			adj_stream=0.7343,
			bpm=160,
			length=4.08,
			dp=500, ep=400, dp_ep=0, rp=3000,
		},
		{
			id=48,
			name="[14] [161] 80808",
			stepartist="Loak",
			pack="Death Grips",
			difficulty=14,
			steps=1797,
			bpm_tier=160,
			measures=100,
			adj_stream=0.7812,
			bpm=161,
			length=3.23,
			dp=525, ep=450, dp_ep=215, rp=3000,
		},
		{
			id=49,
			name="[14] [163] Adrenaline",
			stepartist="Rems",
			pack="Eurobeat Is Fantastic - Second Stage",
			difficulty=14,
			steps=1663,
			bpm_tier=160,
			measures=97,
			adj_stream=0.8584,
			bpm=163,
			length=2.87,
			dp=575, ep=500, dp_ep=500, rp=3000,
		},
		{
			id=50,
			name="[14] [170] Akatsuki",
			stepartist="Janus5k",
			pack="Squirrel Metal II",
			difficulty=14,
			steps=2533,
			bpm_tier=170,
			measures=116,
			adj_stream=0.5979,
			bpm=170,
			length=5.36,
			dp=750, ep=300, dp_ep=429, rp=3000,
		},
		{
			id=51,
			name="[14] [175] kagetsu",
			stepartist="Benpai",
			pack="Stamina Showcase 2",
			difficulty=14,
			steps=2554,
			bpm_tier=170,
			measures=111,
			adj_stream=0.5812,
			bpm=175,
			length=5.05,
			dp=875, ep=150, dp_ep=358, rp=3000,
		},
		{
			id=52,
			name="[14] [174] Black Church",
			stepartist="Zaia",
			pack="Cirque du Miura",
			difficulty=14,
			steps=1862,
			bpm_tier=170,
			measures=96,
			adj_stream=0.7273,
			bpm=174,
			length=4.09,
			dp=850, ep=350, dp_ep=858, rp=3000,
		},
		{
			id=53,
			name="[14] [174] Tension",
			stepartist="StoryTime",
			pack="Hospitality",
			difficulty=14,
			steps=1811,
			bpm_tier=170,
			measures=89,
			adj_stream=0.6593,
			bpm=174,
			length=4.8,
			dp=850, ep=100, dp_ep=143, rp=3000,
		},
		{
			id=54,
			name="[14] [180] Way Away",
			stepartist="Aoreo",
			pack="Big Waves",
			difficulty=14,
			steps=1846,
			bpm_tier=180,
			measures=95,
			adj_stream=0.6738,
			bpm=180,
			length=3.38,
			dp=1000, ep=250, dp_ep=1000, rp=3000,
		},
		{
			id=55,
			name="[14] [180] squartatrice",
			stepartist="Zaia",
			pack="Cirque du Enzo",
			difficulty=14,
			steps=2338,
			bpm_tier=180,
			measures=87,
			adj_stream=0.5437,
			bpm=180,
			length=4.8,
			dp=1000, ep=50, dp_ep=429, rp=3000,
		},
		{
			id=56,
			name="[14] [180] Digital Warrior",
			stepartist="ITGAlex",
			pack="Bass Chasers",
			difficulty=14,
			steps=1614,
			bpm_tier=180,
			measures=86,
			adj_stream=0.688,
			bpm=180,
			length=3.58,
			dp=1000, ep=200, dp_ep=858, rp=3000,
		},
		{
			id=57,
			name="[14] [180] Vertex ALPHA (Hard)",
			stepartist="Rems",
			pack="BaguetteStreamz 2",
			difficulty=14,
			steps=1830,
			bpm_tier=180,
			measures=75,
			adj_stream=0.5102,
			bpm=180,
			length=4.07,
			dp=1000, ep=0, dp_ep=286, rp=3000,
		},
		{
			id=58,
			name="[15] [140] Trance Trance Revolution",
			stepartist="Implode & Rems & Zaia",
			pack="Barber Cuts 3",
			difficulty=15,
			steps=16677,
			bpm_tier=140,
			measures=994,
			adj_stream=0.8606,
			bpm=140,
			length=33.29,
			dp=0, ep=1000, dp_ep=467, rp=4000,
		},
		{
			id=59,
			name="[15] [150] kunkka-kunkka",
			stepartist="Rikame",
			pack="All The Rounds 4",
			difficulty=15,
			steps=4991,
			bpm_tier=150,
			measures=312,
			adj_stream=1,
			bpm=150,
			length=8.61,
			dp=197, ep=950, dp_ep=673, rp=4000,
		},
		{
			id=60,
			name="[15] [155] G e n g a o z o -Noize of Nocent-",
			stepartist="Redzone",
			pack="Stamina Secret Santa 2019",
			difficulty=15,
			steps=4500,
			bpm_tier=150,
			measures=269,
			adj_stream=0.934,
			bpm=155,
			length=8.03,
			dp=295, ep=900, dp_ep=740, rp=4000,
		},
		{
			id=61,
			name="[15] [155] Night Of Fire v2",
			stepartist="Rems",
			pack="Eurobeat Is Fantastic",
			difficulty=15,
			steps=2919,
			bpm_tier=150,
			measures=179,
			adj_stream=0.9728,
			bpm=155,
			length=4.85,
			dp=295, ep=850, dp_ep=670, rp=4000,
		},
		{
			id=62,
			name="[15] [159] REASON for RED (Hard)",
			stepartist="Janus5k",
			pack="Stamina Showcase 2",
			difficulty=15,
			steps=2628,
			bpm_tier=150,
			measures=149,
			adj_stream=0.9141,
			bpm=159,
			length=4.58,
			dp=373, ep=700, dp_ep=569, rp=4000,
		},
		{
			id=63,
			name="[15] [163] GENE",
			stepartist="sorae",
			pack="fsorae's fstamina ffuckeronis",
			difficulty=15,
			steps=3260,
			bpm_tier=160,
			measures=194,
			adj_stream=0.8362,
			bpm=163,
			length=6.04,
			dp=451, ep=800, dp_ep=818, rp=4000,
		},
		{
			id=64,
			name="[15] [168] Ice Angel",
			stepartist="StoryTime",
			pack="StoryTime Chapter 1",
			difficulty=15,
			steps=3305,
			bpm_tier=160,
			measures=193,
			adj_stream=0.7782,
			bpm=168,
			length=6,
			dp=550, ep=750, dp_ep=887, rp=4000,
		},
		{
			id=65,
			name="[15] [165] Zusammengehorigkeit Hommarju Remix",
			stepartist="Rems",
			pack="BaguetteStreamz",
			difficulty=15,
			steps=3176,
			bpm_tier=160,
			measures=175,
			adj_stream=0.8102,
			bpm=165,
			length=5.79,
			dp=491, ep=650, dp_ep=664, rp=4000,
		},
		{
			id=66,
			name="[15] [160] Battle Train -HOT SOTA MIX-",
			stepartist="Xynn",
			pack="Xynn's LVTS 2",
			difficulty=15,
			steps=2793,
			bpm_tier=160,
			measures=162,
			adj_stream=0.8438,
			bpm=160,
			length=5.18,
			dp=393, ep=600, dp_ep=457, rp=4000,
		},
		{
			id=67,
			name="[15] [174] Salt in the Wounds",
			stepartist="Archi",
			pack="Pendulum Act III",
			difficulty=15,
			steps=3117,
			bpm_tier=170,
			measures=141,
			adj_stream=0.6589,
			bpm=174,
			length=6.38,
			dp=667, ep=500, dp_ep=701, rp=4000,
		},
		{
			id=68,
			name="[15] [175] Wrong (Muzzy Remix)",
			stepartist="Rems",
			pack="Hospitality",
			difficulty=15,
			steps=3146,
			bpm_tier=170,
			measures=138,
			adj_stream=0.5679,
			bpm=175,
			length=6.72,
			dp=687, ep=350, dp_ep=519, rp=4000,
		},
		{
			id=69,
			name="[15] [174] Dimension Ninja",
			stepartist="Zaia",
			pack="Cirque du Enzo",
			difficulty=15,
			steps=2425,
			bpm_tier=170,
			measures=100,
			adj_stream=0.4785,
			bpm=174,
			length=4.9,
			dp=667, ep=0, dp_ep=0, rp=4000,
		},
		{
			id=70,
			name="[15] [174] Satellite (Sewerslvt Edit)",
			stepartist="ITGAlex",
			pack="Bass Chasers",
			difficulty=15,
			steps=1638,
			bpm_tier=170,
			measures=100,
			adj_stream=0.9091,
			bpm=174,
			length=2.6,
			dp=667, ep=550, dp_ep=771, rp=4000,
		},
		{
			id=71,
			name="[15] [180] Get Over the Barrier! (-Evolution!!-)",
			stepartist="Arvin",
			pack="Trails of Cold Stream II",
			difficulty=15,
			steps=2017,
			bpm_tier=180,
			measures=115,
			adj_stream=0.7188,
			bpm=180,
			length=3.91,
			dp=785, ep=450, dp_ep=796, rp=4000,
		},
		{
			id=72,
			name="[15] [180] Epimedium",
			stepartist="ITGAlex",
			pack="Bass Chasers",
			difficulty=15,
			steps=1652,
			bpm_tier=180,
			measures=94,
			adj_stream=0.6912,
			bpm=180,
			length=3.51,
			dp=785, ep=200, dp_ep=446, rp=4000,
		},
		{
			id=73,
			name="[15] [180] A Town With An Ocean View (el Poco Maro Remix)",
			stepartist="Rust",
			pack="Hospitality",
			difficulty=15,
			steps=1748,
			bpm_tier=180,
			measures=91,
			adj_stream=0.7054,
			bpm=180,
			length=3.36,
			dp=785, ep=250, dp_ep=516, rp=4000,
		},
		{
			id=74,
			name="[15] [188] Virtual Paradise",
			stepartist="StarrySergal",
			pack="The Joy of Streaming",
			difficulty=15,
			steps=1376,
			bpm_tier=180,
			measures=79,
			adj_stream=0.7054,
			bpm=188,
			length=3.11,
			dp=942, ep=100, dp_ep=526, rp=4000,
		},
		{
			id=75,
			name="[15] [190] Dawn Of Victory",
			stepartist="Rems",
			pack="BaguetteStreamz 2",
			difficulty=15,
			steps=2630,
			bpm_tier=190,
			measures=126,
			adj_stream=0.6238,
			bpm=190,
			length=4.72,
			dp=981, ep=400, dp_ep=1000, rp=4000,
		},
		{
			id=76,
			name="[15] [191] Wolves Standing Towards Enemies",
			stepartist="sorae",
			pack="The Joy of Streaming",
			difficulty=15,
			steps=1560,
			bpm_tier=190,
			measures=81,
			adj_stream=0.7431,
			bpm=191,
			length=2.85,
			dp=1000, ep=150, dp_ep=677, rp=4000,
		},
		{
			id=77,
			name="[15] [191] AO-INFINITY",
			stepartist="Zaia",
			pack="Cirque du Enzo",
			difficulty=15,
			steps=1747,
			bpm_tier=190,
			measures=72,
			adj_stream=0.6667,
			bpm=191,
			length=3.56,
			dp=1000, ep=50, dp_ep=537, rp=4000,
		},
		{
			id=78,
			name="[15] [190] Unreliable Narrator",
			stepartist="Admiral M&Ms",
			pack="Resistance Device",
			difficulty=15,
			steps=1362,
			bpm_tier=190,
			measures=68,
			adj_stream=0.8608,
			bpm=190,
			length=2.61,
			dp=981, ep=300, dp_ep=860, rp=4000,
		},
		{
			id=79,
			name="[16] [165] The Epic of Zektbach",
			stepartist="ITGAlex",
			pack="Big Waves",
			difficulty=16,
			steps=10035,
			bpm_tier=160,
			measures=561,
			adj_stream=0.7879,
			bpm=165,
			length=18.5,
			dp=105, ep=1000, dp_ep=858, rp=5000,
		},
		{
			id=80,
			name="[16] [160] Eurobeat Is Fantastic ~Part 3~",
			stepartist="Rems",
			pack="Eurobeat Is Fantastic",
			difficulty=16,
			steps=5614,
			bpm_tier=160,
			measures=330,
			adj_stream=0.8684,
			bpm=160,
			length=9.82,
			dp=0, ep=950, dp_ep=368, rp=5000,
		},
		{
			id=81,
			name="[16] [165] Eastern Dream",
			stepartist="Reyllyoc",
			pack="Demetori ACT 1",
			difficulty=16,
			steps=5762,
			bpm_tier=160,
			measures=324,
			adj_stream=0.8438,
			bpm=165,
			length=10.33,
			dp=105, ep=850, dp_ep=383, rp=5000,
		},
		{
			id=82,
			name="[16] [162] Entity",
			stepartist="ITGAlex",
			pack="ITGAlex's Stamina Safari",
			difficulty=16,
			steps=4797,
			bpm_tier=160,
			measures=291,
			adj_stream=0.9238,
			bpm=162,
			length=7.93,
			dp=42, ep=900, dp_ep=342, rp=5000,
		},
		{
			id=83,
			name="[16] [167] unnatural",
			stepartist="ZoG- & StarrySergal",
			pack="Goreshit 2020",
			difficulty=16,
			steps=3939,
			bpm_tier=160,
			measures=238,
			adj_stream=0.9835,
			bpm=167,
			length=6.35,
			dp=146, ep=800, dp_ep=355, rp=5000,
		},
		{
			id=84,
			name="[16] [174] Meteor Shower",
			stepartist="Zaia",
			pack="Cirque du Enzo",
			difficulty=16,
			steps=3719,
			bpm_tier=170,
			measures=224,
			adj_stream=0.875,
			bpm=174,
			length=5.98,
			dp=292, ep=750, dp_ep=659, rp=5000,
		},
		{
			id=85,
			name="[16] [173] Just One Second",
			stepartist="Rems",
			pack="Hospitality",
			difficulty=16,
			steps=3392,
			bpm_tier=170,
			measures=201,
			adj_stream=0.9013,
			bpm=173,
			length=5.46,
			dp=271, ep=700, dp_ep=434, rp=5000,
		},
		{
			id=86,
			name="[16] [175] United (L.A.O.S. Remix)",
			stepartist="StoryTime",
			pack="Hospitality",
			difficulty=16,
			steps=3124,
			bpm_tier=170,
			measures=166,
			adj_stream=0.8469,
			bpm=175,
			length=5.41,
			dp=313, ep=600, dp_ep=250, rp=5000,
		},
		{
			id=87,
			name="[16] [174] Crush",
			stepartist="Archi",
			pack="Pendulum Act III",
			difficulty=16,
			steps=1921,
			bpm_tier=170,
			measures=120,
			adj_stream=1,
			bpm=174,
			length=3.06,
			dp=292, ep=550, dp_ep=26, rp=5000,
		},
		{
			id=88,
			name="[16] [180] I'm Not Crazy",
			stepartist="NAOKI",
			pack="The Joy of Streaming 2",
			difficulty=16,
			steps=4312,
			bpm_tier=180,
			measures=198,
			adj_stream=0.6828,
			bpm=180,
			length=7.47,
			dp=417, ep=500, dp_ep=263, rp=5000,
		},
		{
			id=89,
			name="[16] [184] Cybernecia Catharsis",
			stepartist="ITGAlex",
			pack="ITGAlex's Stamina Singles",
			difficulty=16,
			steps=2512,
			bpm_tier=180,
			measures=138,
			adj_stream=0.7797,
			bpm=184,
			length=4.59,
			dp=500, ep=350, dp_ep=51, rp=5000,
		},
		{
			id=90,
			name="[16] [186] Fly Away",
			stepartist="ITGAlex",
			pack="ITGAlex's Stamina Safari",
			difficulty=16,
			steps=2283,
			bpm_tier=180,
			measures=134,
			adj_stream=0.8375,
			bpm=186,
			length=3.48,
			dp=542, ep=450, dp_ep=500, rp=5000,
		},
		{
			id=91,
			name="[16] [184] Heretic Witch",
			stepartist="Archi",
			pack="SHARPNELSTREAMZ v3 Part 2",
			difficulty=16,
			steps=2155,
			bpm_tier=180,
			measures=133,
			adj_stream=0.9925,
			bpm=184,
			length=3.06,
			dp=500, ep=650, dp_ep=1000, rp=5000,
		},
		{
			id=92,
			name="[16] [192] Night sky",
			stepartist="ITGAlex",
			pack="ITGAlex's Stamina Safari",
			difficulty=16,
			steps=2708,
			bpm_tier=190,
			measures=148,
			adj_stream=0.7668,
			bpm=192,
			length=4.44,
			dp=667, ep=400, dp_ep=738, rp=5000,
		},
		{
			id=93,
			name="[16] [192] Salvation",
			stepartist="Zaia",
			pack="Cirque du Enzo",
			difficulty=16,
			steps=2674,
			bpm_tier=190,
			measures=130,
			adj_stream=0.6373,
			bpm=192,
			length=4.92,
			dp=667, ep=300, dp_ep=421, rp=5000,
		},
		{
			id=94,
			name="[16] [192] Say Hello to HOLLOWood feat. Nene Akagawa",
			stepartist="Okami",
			pack="BaguetteStreamz 2",
			difficulty=16,
			steps=2520,
			bpm_tier=190,
			measures=127,
			adj_stream=0.6318,
			bpm=192,
			length=4.56,
			dp=667, ep=250, dp_ep=263, rp=5000,
		},
		{
			id=95,
			name="[16] [196] Aragami",
			stepartist="Zaia",
			pack="xi preview",
			difficulty=16,
			steps=1909,
			bpm_tier=190,
			measures=94,
			adj_stream=0.7344,
			bpm=196,
			length=3.45,
			dp=750, ep=150, dp_ep=209, rp=5000,
		},
		{
			id=96,
			name="[16] [200] Heaven's Fall 2016 Rebuild",
			stepartist="Zaia",
			pack="Helblinde 2016",
			difficulty=16,
			steps=2623,
			bpm_tier=200,
			measures=127,
			adj_stream=0.6287,
			bpm=200,
			length=4.24,
			dp=834, ep=200, dp_ep=633, rp=5000,
		},
		{
			id=97,
			name="[16] [207] BroGamer (Extended Mix)",
			stepartist="Okami",
			pack="BaguetteStreamz 2.5",
			difficulty=16,
			steps=1991,
			bpm_tier=200,
			measures=93,
			adj_stream=0.6596,
			bpm=207,
			length=3.38,
			dp=980, ep=100, dp_ep=779, rp=5000,
		},
		{
			id=98,
			name="[16] [208] Deus ex Machina",
			stepartist="Zaia",
			pack="Cirque du Enzo",
			difficulty=16,
			steps=1877,
			bpm_tier=200,
			measures=87,
			adj_stream=0.6541,
			bpm=208,
			length=2.94,
			dp=1000, ep=50, dp_ep=684, rp=5000,
		},
		{
			id=99,
			name="[16] [200] Liberator feat. blaxervant",
			stepartist="Admiral M&Ms",
			pack="Resistance Device",
			difficulty=16,
			steps=1655,
			bpm_tier=200,
			measures=78,
			adj_stream=0.6903,
			bpm=200,
			length=3.56,
			dp=834, ep=0, dp_ep=0, rp=5000,
		},
		{
			id=100,
			name="[17] [175] Space Box",
			stepartist="@@",
			pack="Scrapyard Kent",
			difficulty=17,
			steps=9735,
			bpm_tier=170,
			measures=575,
			adj_stream=0.8557,
			bpm=175,
			length=15.86,
			dp=23, ep=950, dp_ep=677, rp=6000,
		},
		{
			id=101,
			name="[17] [179] Bio Tunnel Magnetic Transport",
			stepartist="Rems",
			pack="Hospitality",
			difficulty=17,
			steps=5743,
			bpm_tier=170,
			measures=336,
			adj_stream=0.7636,
			bpm=179,
			length=10.3,
			dp=114, ep=750, dp_ep=419, rp=6000,
		},
		{
			id=102,
			name="[17] [174] Toxic Shock (Novice)",
			stepartist="Archi",
			pack="Pendulum Act IV",
			difficulty=17,
			steps=5139,
			bpm_tier=170,
			measures=317,
			adj_stream=0.9463,
			bpm=174,
			length=8,
			dp=0, ep=900, dp_ep=504, rp=6000,
		},
		{
			id=103,
			name="[17] [179] Lift Off FB 179",
			stepartist="@@",
			pack="Scrapyard Kent",
			difficulty=17,
			steps=4570,
			bpm_tier=170,
			measures=279,
			adj_stream=0.9555,
			bpm=179,
			length=7.24,
			dp=114, ep=850, dp_ep=655, rp=6000,
		},
		{
			id=104,
			name="[17] [180] Global Down",
			stepartist="ITGAlex",
			pack="Bass Chasers",
			difficulty=17,
			steps=4742,
			bpm_tier=180,
			measures=288,
			adj_stream=0.8944,
			bpm=180,
			length=7.31,
			dp=137, ep=800, dp_ep=592, rp=6000,
		},
		{
			id=105,
			name="[17] [187] Destination Talos",
			stepartist="Zaia",
			pack="Cranked Pastry",
			difficulty=17,
			steps=4937,
			bpm_tier=180,
			measures=270,
			adj_stream=0.8157,
			bpm=187,
			length=7.47,
			dp=296, ep=550, dp_ep=376, rp=6000,
		},
		{
			id=106,
			name="[17] [180] Signal (Girl's Vocal Mix)",
			stepartist="Rems",
			pack="BaguetteStreamz 2",
			difficulty=17,
			steps=4253,
			bpm_tier=180,
			measures=250,
			adj_stream=0.8621,
			bpm=180,
			length=6.87,
			dp=137, ep=600, dp_ep=119, rp=6000,
		},
		{
			id=107,
			name="[17] [185] Asereje (Speed Mix)",
			stepartist="Aoreo",
			pack="Jimmy Jawns 4",
			difficulty=17,
			steps=3349,
			bpm_tier=180,
			measures=208,
			adj_stream=0.9858,
			bpm=185,
			length=4.67,
			dp=250, ep=700, dp_ep=622, rp=6000,
		},
		{
			id=108,
			name="[17] [191] Denjin K Megamix (Restep)",
			stepartist="Archi",
			pack="Big Waves",
			difficulty=17,
			steps=14147,
			bpm_tier=190,
			measures=794,
			adj_stream=0.7153,
			bpm=178,
			length=26.51,
			dp=91, ep=1000, dp_ep=956, rp=6000,
		},
		{
			id=109,
			name="[17] [190] I Miss You",
			stepartist="Honk",
			pack="Trails of Cold Stream",
			difficulty=17,
			steps=3868,
			bpm_tier=190,
			measures=232,
			adj_stream=0.917,
			bpm=190,
			length=5.37,
			dp=364, ep=650, dp_ep=774, rp=6000,
		},
		{
			id=110,
			name="[17] [198] Rebirth the end (Part I - Sasanqua)",
			stepartist="ITGAlex",
			pack="Noah",
			difficulty=17,
			steps=3967,
			bpm_tier=190,
			measures=219,
			adj_stream=0.7374,
			bpm=198,
			length=6.71,
			dp=546, ep=400, dp_ep=613, rp=6000,
		},
		{
			id=111,
			name="[17] [190] La Morale De La Fable",
			stepartist="ExJam09",
			pack="ExJam09 Jams",
			difficulty=17,
			steps=3888,
			bpm_tier=190,
			measures=207,
			adj_stream=0.7841,
			bpm=190,
			length=6.08,
			dp=364, ep=500, dp_ep=419, rp=6000,
		},
		{
			id=112,
			name="[17] [191] Difficulty-G",
			stepartist="TYLR",
			pack="SHARPNELSTREAMZ v3 Part 2",
			difficulty=17,
			steps=2815,
			bpm_tier=190,
			measures=141,
			adj_stream=0.8393,
			bpm=191,
			length=4.24,
			dp=387, ep=300, dp_ep=0, rp=6000,
		},
		{
			id=113,
			name="[17] [203] Whispers In The Dark",
			stepartist="Chief Skittles",
			pack="Skittles Stream Collection",
			difficulty=17,
			steps=3489,
			bpm_tier=200,
			measures=212,
			adj_stream=0.7571,
			bpm=203,
			length=6.03,
			dp=660, ep=450, dp_ep=1000, rp=6000,
		},
		{
			id=114,
			name="[17] [205] Little Lies",
			stepartist="ITGAlex & Aoreo",
			pack="ITGAlex's Stamina Safari",
			difficulty=17,
			steps=3072,
			bpm_tier=200,
			measures=169,
			adj_stream=0.6815,
			bpm=205,
			length=5.4,
			dp=705, ep=250, dp_ep=634, rp=6000,
		},
		{
			id=115,
			name="[17] [208] Yui & I",
			stepartist="Zaia",
			pack="Helblinde PDTA",
			difficulty=17,
			steps=3158,
			bpm_tier=200,
			measures=164,
			adj_stream=0.6189,
			bpm=208,
			length=5.51,
			dp=773, ep=150, dp_ep=558, rp=6000,
		},
		{
			id=116,
			name="[17] [204] New Odyssey",
			stepartist="ITGAlex",
			pack="ITGAlex's Stamina Safari",
			difficulty=17,
			steps=2945,
			bpm_tier=200,
			measures=162,
			adj_stream=0.7788,
			bpm=204,
			length=4.75,
			dp=682, ep=350, dp_ep=816, rp=6000,
		},
		{
			id=117,
			name="[17] [210] Unsainted",
			stepartist="Aoreo",
			pack="Jimmy Jawns 4",
			difficulty=17,
			steps=2380,
			bpm_tier=210,
			measures=123,
			adj_stream=0.7834,
			bpm=210,
			length=3.83,
			dp=819, ep=200, dp_ep=785, rp=6000,
		},
		{
			id=118,
			name="[17] [210] Outbreak (P*Light & DJ Myosuke Remix)",
			stepartist="Okami",
			pack="Stamina Selects",
			difficulty=17,
			steps=2414,
			bpm_tier=210,
			measures=117,
			adj_stream=0.6126,
			bpm=210,
			length=4.3,
			dp=819, ep=50, dp_ep=431, rp=6000,
		},
		{
			id=119,
			name="[17] [212] Zap Your Channel",
			stepartist="Zaia",
			pack="Rebuild of Sharpnel",
			difficulty=17,
			steps=2125,
			bpm_tier=210,
			measures=107,
			adj_stream=0.6859,
			bpm=212,
			length=3.15,
			dp=864, ep=100, dp_ep=655, rp=6000,
		},
		{
			id=120,
			name="[17] [218] Goblin Humpa",
			stepartist="Kyy",
			pack="Kyypakkaus 2",
			difficulty=17,
			steps=1739,
			bpm_tier=210,
			measures=79,
			adj_stream=0.594,
			bpm=218,
			length=2.81,
			dp=1000, ep=0, dp_ep=740, rp=6000,
		},
	}
}

ECS.SongInfo.Mid = {
	-- These values will be calculated and set below.
	MinBpm = 0,
	MaxBpm = 0,
	MinScaled16ths = 0,
	MaxScaled16ths = 0,
	MinBlockLevel = 0,
	MaxBlockLevel = 0,
	MinLength = 0,
	Songs = {
		{
			id=1,
			name="[17] [175] Sukure",
			stepartist="@@",
			pack="Big Waves",
			difficulty=17,
			steps=5266,
			bpm_tier=170,
			measures=319,
			adj_stream=0.9088,
			bpm=175,
			length=8.14,
			dp=0, ep=924, dp_ep=494, rp=1000,
		},
		{
			id=2,
			name="[17] [178] Exelion FB 178",
			stepartist="Sefirot",
			pack="The Joy of Streaming",
			difficulty=17,
			steps=4091,
			bpm_tier=170,
			measures=253,
			adj_stream=0.9336,
			bpm=178,
			length=6.16,
			dp=79, ep=847, dp_ep=499, rp=1000,
		},
		{
			id=3,
			name="[17] [183] The Star of Collapse Acts I & II",
			stepartist="Chief Skittles",
			pack="Skittles Stream Collection",
			difficulty=17,
			steps=4447,
			bpm_tier=180,
			measures=261,
			adj_stream=0.8729,
			bpm=183,
			length=6.98,
			dp=211, ep=693, dp_ep=442, rp=1000,
		},
		{
			id=4,
			name="[17] [180] Extends Levant",
			stepartist="ITGAlex",
			pack="ITGAlex's Stamina Singles ep.1",
			difficulty=17,
			steps=4174,
			bpm_tier=180,
			measures=243,
			adj_stream=0.924,
			bpm=180,
			length=6.48,
			dp=132, ep=770, dp_ep=437, rp=1000,
		},
		{
			id=5,
			name="[17] [180] Terminal Slam",
			stepartist="yutsi",
			pack="yutsi-type beats",
			difficulty=17,
			steps=3273,
			bpm_tier=180,
			measures=192,
			adj_stream=1,
			bpm=180,
			length=5.04,
			dp=132, ep=616, dp_ep=39, rp=1000,
		},
		{
			id=6,
			name="[17] [191] Denjin K Megamix (Restep)",
			stepartist="Archi",
			pack="Big Waves",
			difficulty=17,
			steps=14147,
			bpm_tier=190,
			measures=794,
			adj_stream=0.7153,
			bpm=178,
			length=26.51,
			dp=79, ep=1000, dp_ep=895, rp=1000,
		},
		{
			id=7,
			name="[17] [190] Strawberry Crisis !",
			stepartist="Rems",
			pack="BaguetteStreamz 2",
			difficulty=17,
			steps=2675,
			bpm_tier=190,
			measures=164,
			adj_stream=0.9762,
			bpm=190,
			length=3.6,
			dp=395, ep=539, dp_ep=520, rp=1000,
		},
		{
			id=8,
			name="[17] [197] fleshbound",
			stepartist="StarrySergal",
			pack="Goreshit 2020",
			difficulty=17,
			steps=3086,
			bpm_tier=190,
			measures=159,
			adj_stream=0.6709,
			bpm=197,
			length=6.27,
			dp=579, ep=154, dp_ep=0, rp=1000,
		},
		{
			id=9,
			name="[17] [195] Orca",
			stepartist="ITGAlex",
			pack="ITGAlex's Stamina Safari",
			difficulty=17,
			steps=2583,
			bpm_tier=190,
			measures=145,
			adj_stream=0.8192,
			bpm=195,
			length=4.1,
			dp=527, ep=308, dp_ep=264, rp=1000,
		},
		{
			id=10,
			name="[17] [200] The Story of Mob",
			stepartist="BasedHonk & ChasePines",
			pack="The Joy of Streaming",
			difficulty=17,
			steps=3947,
			bpm_tier=200,
			measures=225,
			adj_stream=0.7143,
			bpm=200,
			length=6.48,
			dp=658, ep=462, dp_ep=1000, rp=1000,
		},
		{
			id=11,
			name="[17] [200] Brooklyn Underground",
			stepartist="Nav",
			pack="Psychedelia 2",
			difficulty=17,
			steps=3804,
			bpm_tier=200,
			measures=212,
			adj_stream=0.7114,
			bpm=200,
			length=6.08,
			dp=658, ep=385, dp_ep=802, rp=1000,
		},
		{
			id=12,
			name="[17] [205] Saikyo Stronger",
			stepartist="Mango",
			pack="Mango's Microrave Samplur",
			difficulty=17,
			steps=2734,
			bpm_tier=200,
			measures=149,
			adj_stream=0.7884,
			bpm=205,
			length=4.08,
			dp=790, ep=231, dp_ep=745, rp=1000,
		},
		{
			id=13,
			name="[17] [210] Midnight City",
			stepartist="StarrySergal",
			pack="Enjou Stamina Package",
			difficulty=17,
			steps=1903,
			bpm_tier=210,
			measures=104,
			adj_stream=0.619,
			bpm=210,
			length=3.7,
			dp=922, ep=0, dp_ep=489, rp=1000,
		},
		{
			id=14,
			name="[17] [213] One Shot",
			stepartist="Kyy",
			pack="Kyypakkaus 2",
			difficulty=17,
			steps=1860,
			bpm_tier=210,
			measures=93,
			adj_stream=0.6643,
			bpm=213,
			length=3.38,
			dp=1000, ep=77, dp_ep=889, rp=1000,
		},
		{
			id=15,
			name="[18] [180] Colliding Skies - Dawn",
			stepartist="Raijin",
			pack="The Joy of Streaming 2",
			difficulty=18,
			steps=16000,
			bpm_tier=180,
			measures=946,
			adj_stream=0.8687,
			bpm=180,
			length=24.36,
			dp=0, ep=1000, dp_ep=618, rp=2000,
		},
		{
			id=16,
			name="[18] [183] Eurobeat Is Fantastic ~Part 2~ FB 183",
			stepartist="Zaia & ITGAlex & YourVinished",
			pack="Eurobeat Is Fantastic - Second Stage",
			difficulty=18,
			steps=8755,
			bpm_tier=180,
			measures=512,
			adj_stream=0.8678,
			bpm=183,
			length=12.98,
			dp=67, ep=924, dp_ep=598, rp=2000,
		},
		{
			id=17,
			name="[18] [186] Trails of Cold Stream SC (Part 1) FP 186",
			stepartist="YourVinished & Janus5k",
			pack="Trails of Cold Stream II",
			difficulty=18,
			steps=6474,
			bpm_tier=180,
			measures=384,
			adj_stream=0.9922,
			bpm=186,
			length=9.44,
			dp=134, ep=847, dp_ep=576, rp=2000,
		},
		{
			id=18,
			name="[18] [195] ESCAPE",
			stepartist="yutsi",
			pack="Dark Psychungus",
			difficulty=18,
			steps=5584,
			bpm_tier=190,
			measures=332,
			adj_stream=0.9222,
			bpm=195,
			length=7.59,
			dp=334, ep=770, dp_ep=847, rp=2000,
		},
		{
			id=19,
			name="[18] [190] Precious Song Dedicated to the Stars",
			stepartist="ITGAlex",
			pack="ITGAlex's Stamina Singles ep.2",
			difficulty=18,
			steps=5302,
			bpm_tier=190,
			measures=324,
			adj_stream=0.9076,
			bpm=190,
			length=7.71,
			dp=223, ep=693, dp_ep=433, rp=2000,
		},
		{
			id=20,
			name="[18] [195] Embrace the Endless Ocean",
			stepartist="Janus5k",
			pack="Squirrel Metal II",
			difficulty=18,
			steps=4092,
			bpm_tier=190,
			measures=223,
			adj_stream=0.7825,
			bpm=195,
			length=6.3,
			dp=334, ep=385, dp_ep=0, rp=2000,
		},
		{
			id=21,
			name="[18] [200] Cheatreal Remake",
			stepartist="yutsi",
			pack="selected yutsi works",
			difficulty=18,
			steps=3729,
			bpm_tier=200,
			measures=226,
			adj_stream=0.9339,
			bpm=200,
			length=4.92,
			dp=445, ep=616, dp_ep=752, rp=2000,
		},
		{
			id=22,
			name="[18] [200] Fly",
			stepartist="nv & yutsi",
			pack="Chimichangas",
			difficulty=18,
			steps=3776,
			bpm_tier=200,
			measures=221,
			adj_stream=0.9057,
			bpm=200,
			length=5.28,
			dp=445, ep=539, dp_ep=583, rp=2000,
		},
		{
			id=23,
			name="[18] [208] one way to hannover",
			stepartist="StarrySergal",
			pack="Goreshit 2020",
			difficulty=18,
			steps=2903,
			bpm_tier=200,
			measures=155,
			adj_stream=0.7014,
			bpm=208,
			length=5,
			dp=623, ep=154, dp_ep=128, rp=2000,
		},
		{
			id=24,
			name="[18] [212] Aaron",
			stepartist="StarrySergal",
			pack="StarrySergal's Flamin Hot Munchies",
			difficulty=18,
			steps=3378,
			bpm_tier=210,
			measures=193,
			adj_stream=0.8655,
			bpm=212,
			length=4.43,
			dp=712, ep=462, dp_ep=1000, rp=2000,
		},
		{
			id=25,
			name="[18] [210] Rocking Bye",
			stepartist="StarrySergal",
			pack="The Joy of Streaming",
			difficulty=18,
			steps=3507,
			bpm_tier=210,
			measures=188,
			adj_stream=0.6836,
			bpm=210,
			length=5.6,
			dp=667, ep=231, dp_ep=394, rp=2000,
		},
		{
			id=26,
			name="[18] [216] What a Horrible Night to Have a Curse",
			stepartist="zaniel",
			pack="Junts 2",
			difficulty=18,
			steps=2845,
			bpm_tier=210,
			measures=158,
			adj_stream=0.798,
			bpm=216,
			length=3.83,
			dp=800, ep=308, dp_ep=855, rp=2000,
		},
		{
			id=27,
			name="[18] [220] Go To Hell",
			stepartist="ExJam09",
			pack="ExJam09 Jams 2",
			difficulty=18,
			steps=2294,
			bpm_tier=220,
			measures=107,
			adj_stream=0.6815,
			bpm=220,
			length=3.71,
			dp=889, ep=77, dp_ep=543, rp=2000,
		},
		{
			id=28,
			name="[18] [225] Usseewa (DJKurara Remix)",
			stepartist="Mango",
			pack="Mango Showcase",
			difficulty=18,
			steps=2375,
			bpm_tier=220,
			measures=97,
			adj_stream=0.5951,
			bpm=225,
			length=4.09,
			dp=1000, ep=0, dp_ep=618, rp=2000,
		},
		{
			id=29,
			name="[19] [194] Enjoy The Flight (Side B) (Restep) FB 194",
			stepartist="Rems",
			pack="Hospitality",
			difficulty=19,
			steps=14292,
			bpm_tier=190,
			measures=785,
			adj_stream=0.7162,
			bpm=194,
			length=23.38,
			dp=53, ep=1000, dp_ep=424, rp=3000,
		},
		{
			id=30,
			name="[19] [192] You Touched The Kore, and Now You're Going to Die",
			stepartist="Xynn",
			pack="The Joy of Streaming 2",
			difficulty=19,
			steps=7444,
			bpm_tier=190,
			measures=456,
			adj_stream=0.9913,
			bpm=192,
			length=10.06,
			dp=0, ep=924, dp_ep=57, rp=3000,
		},
		{
			id=31,
			name="[19] [198] After End Start Before FP 198",
			stepartist="@@",
			pack="Scrapyard Kent",
			difficulty=19,
			steps=6864,
			bpm_tier=190,
			measures=408,
			adj_stream=0.9488,
			bpm=198,
			length=9.36,
			dp=158, ep=847, dp_ep=287, rp=3000,
		},
		{
			id=32,
			name="[19] [200] 5H4D0W",
			stepartist="yutsi",
			pack="yutsi-type beats",
			difficulty=19,
			steps=6537,
			bpm_tier=200,
			measures=394,
			adj_stream=0.8795,
			bpm=200,
			length=9.42,
			dp=211, ep=693, dp_ep=0, rp=3000,
		},
		{
			id=33,
			name="[19] [200] Cold Fusion",
			stepartist="yutsi",
			pack="selected yutsi works",
			difficulty=19,
			steps=5649,
			bpm_tier=200,
			measures=350,
			adj_stream=0.9915,
			bpm=200,
			length=7.46,
			dp=211, ep=770, dp_ep=219, rp=3000,
		},
		{
			id=34,
			name="[19] [203] Peyotech",
			stepartist="Nav",
			pack="Psychedelia 2",
			difficulty=19,
			steps=4964,
			bpm_tier=200,
			measures=306,
			adj_stream=0.9839,
			bpm=203,
			length=6.36,
			dp=290, ep=616, dp_ep=6, rp=3000,
		},
		{
			id=35,
			name="[19] [212] In my life, my mind (Restep)",
			stepartist="Zaia",
			pack="Big Waves",
			difficulty=19,
			steps=4012,
			bpm_tier=210,
			measures=249,
			adj_stream=0.9842,
			bpm=212,
			length=4.84,
			dp=527, ep=539, dp_ep=461, rp=3000,
		},
		{
			id=36,
			name="[19] [215] Yosakoi Rave Fuck That!!! (Overdrive)",
			stepartist="Archi",
			pack="Masochisma Mk 1",
			difficulty=19,
			steps=3755,
			bpm_tier=210,
			measures=225,
			adj_stream=0.9109,
			bpm=215,
			length=5.08,
			dp=606, ep=462, dp_ep=466, rp=3000,
		},
		{
			id=37,
			name="[19] [216] Momentary Life",
			stepartist="Zaia",
			pack="Saitama's Ultimate Weapon",
			difficulty=19,
			steps=2673,
			bpm_tier=210,
			measures=161,
			adj_stream=0.936,
			bpm=216,
			length=3.33,
			dp=632, ep=385, dp_ep=322, rp=3000,
		},
		{
			id=38,
			name="[19] [220] Coffin Dance (Astronomia Frenchcore Remix)",
			stepartist="zaniel",
			pack="Simfile Torah",
			difficulty=19,
			steps=2916,
			bpm_tier=220,
			measures=153,
			adj_stream=0.7183,
			bpm=220,
			length=4.29,
			dp=737, ep=231, dp_ep=182, rp=3000,
		},
		{
			id=39,
			name="[19] [228] Big Blue",
			stepartist="Zaia",
			pack="Saitama's Ultimate Weapon",
			difficulty=19,
			steps=2945,
			bpm_tier=220,
			measures=150,
			adj_stream=0.8065,
			bpm=228,
			length=4.05,
			dp=948, ep=308, dp_ep=1000, rp=3000,
		},
		{
			id=40,
			name="[19] [224] ENAMEL",
			stepartist="StoryTime",
			pack="Jayrocking",
			difficulty=19,
			steps=2356,
			bpm_tier=220,
			measures=135,
			adj_stream=0.7258,
			bpm=224,
			length=3.59,
			dp=843, ep=154, dp_ep=265, rp=3000,
		},
		{
			id=41,
			name="[19] [230] BGM 04",
			stepartist="StarrySergal",
			pack="Videogame Streamables 2",
			difficulty=19,
			steps=1682,
			bpm_tier=230,
			measures=94,
			adj_stream=0.9038,
			bpm=230,
			length=2.12,
			dp=1000, ep=77, dp_ep=492, rp=3000,
		},
		{
			id=42,
			name="[19] [230] Sky High",
			stepartist="nv",
			pack="streammania IIDX",
			difficulty=19,
			steps=1400,
			bpm_tier=230,
			measures=69,
			adj_stream=0.8846,
			bpm=230,
			length=2.04,
			dp=1000, ep=0, dp_ep=273, rp=3000,
		},
		{
			id=43,
			name="[20] [200] Ha(Ne)rdcore OTAKU Connectionz zane & feedbacker's OP",
			stepartist="zaniel & feedbacker",
			pack="Junts 2",
			difficulty=20,
			steps=20511,
			bpm_tier=200,
			measures=1189,
			adj_stream=0.7921,
			bpm=200,
			length=30.38,
			dp=0, ep=1000, dp_ep=352, rp=4000,
		},
		{
			id=44,
			name="[20] [204] Trails of Cold Stream FC (Part 1) FB 204",
			stepartist="YourVinished",
			pack="Trails of Cold Stream II",
			difficulty=20,
			steps=7994,
			bpm_tier=200,
			measures=488,
			adj_stream=0.9819,
			bpm=204,
			length=10.4,
			dp=98, ep=924, dp_ep=420, rp=4000,
		},
		{
			id=45,
			name="[20] [208] Naruto RMX FP 208",
			stepartist="yutsi",
			pack="yutsi-type beats",
			difficulty=20,
			steps=7451,
			bpm_tier=200,
			measures=444,
			adj_stream=0.9098,
			bpm=208,
			length=10.73,
			dp=196, ep=847, dp_ep=485, rp=4000,
		},
		{
			id=46,
			name="[20] [218] Repeating Memories",
			stepartist="yutsi",
			pack="selected yutsi works",
			difficulty=20,
			steps=4424,
			bpm_tier=210,
			measures=269,
			adj_stream=0.9406,
			bpm=218,
			length=5.91,
			dp=440, ep=770, dp_ep=1000, rp=4000,
		},
		{
			id=47,
			name="[20] [218] Sounds of Life (Medium)",
			stepartist="Aoreo",
			pack="Pendulum Act III",
			difficulty=20,
			steps=4199,
			bpm_tier=210,
			measures=253,
			adj_stream=0.9301,
			bpm=218,
			length=5.13,
			dp=440, ep=616, dp_ep=525, rp=4000,
		},
		{
			id=48,
			name="[20] [217] the end",
			stepartist="StarrySergal",
			pack="Goreshit 2020",
			difficulty=20,
			steps=3940,
			bpm_tier=210,
			measures=236,
			adj_stream=0.9833,
			bpm=217,
			length=4.76,
			dp=415, ep=693, dp_ep=686, rp=4000,
		},
		{
			id=49,
			name="[20] [220] Suwa Foughten Field",
			stepartist="Archi",
			pack="Big Waves",
			difficulty=20,
			steps=3811,
			bpm_tier=220,
			measures=226,
			adj_stream=0.9496,
			bpm=220,
			length=4.55,
			dp=488, ep=539, dp_ep=436, rp=4000,
		},
		{
			id=50,
			name="[20] [220] The Sound Of Hard",
			stepartist="Zaia",
			pack="Big Waves",
			difficulty=20,
			steps=3947,
			bpm_tier=220,
			measures=219,
			adj_stream=0.8622,
			bpm=220,
			length=5,
			dp=488, ep=462, dp_ep=198, rp=4000,
		},
		{
			id=51,
			name="[20] [224] Counter Hunter Stage (Megaman X2)",
			stepartist="StarrySergal",
			pack="Enjou Stamina Package",
			difficulty=20,
			steps=2241,
			bpm_tier=220,
			measures=140,
			adj_stream=1,
			bpm=224,
			length=2.55,
			dp=586, ep=308, dp_ep=25, rp=4000,
		},
		{
			id=52,
			name="[20] [230] Lust SIN II",
			stepartist="Chief Skittles",
			pack="Skittles Stream Collection",
			difficulty=20,
			steps=3563,
			bpm_tier=230,
			measures=207,
			adj_stream=0.8625,
			bpm=230,
			length=4.56,
			dp=732, ep=385, dp_ep=713, rp=4000,
		},
		{
			id=53,
			name="[20] [230] Voltaic Black Knight",
			stepartist="Mango",
			pack="Mango Showcase",
			difficulty=20,
			steps=2805,
			bpm_tier=230,
			measures=162,
			adj_stream=0.8265,
			bpm=230,
			length=3.57,
			dp=732, ep=154, dp_ep=0, rp=4000,
		},
		{
			id=54,
			name="[20] [232] Scarlet Tempest (Medium) Super Arrange",
			stepartist="Chief Skittles",
			pack="Trails of Cold Stream IV",
			difficulty=20,
			steps=2570,
			bpm_tier=230,
			measures=147,
			adj_stream=0.8909,
			bpm=233,
			length=3.17,
			dp=805, ep=231, dp_ep=463, rp=4000,
		},
		{
			id=55,
			name="[20] [241] Heavenly caress",
			stepartist="ITGAlex",
			pack="Noah",
			difficulty=20,
			steps=1633,
			bpm_tier=240,
			measures=94,
			adj_stream=0.7705,
			bpm=241,
			length=2.19,
			dp=1000, ep=77, dp_ep=590, rp=4000,
		},
		{
			id=56,
			name="[20] [240] Spirit Of Children",
			stepartist="Kyy",
			pack="Kyypakkaus",
			difficulty=20,
			steps=1491,
			bpm_tier=240,
			measures=77,
			adj_stream=0.6875,
			bpm=240,
			length=2.17,
			dp=976, ep=0, dp_ep=278, rp=4000,
		},
		{
			id=57,
			name="[21] [210] stamina training",
			stepartist="YUZU",
			pack="Enjou Stamina Package",
			difficulty=21,
			steps=20678,
			bpm_tier=210,
			measures=1185,
			adj_stream=0.7472,
			bpm=210,
			length=31.12,
			dp=0, ep=1000, dp_ep=679, rp=5000,
		},
		{
			id=58,
			name="[21] [216] goretrance x (serbian fuckboy edition) (Side A) FP 216",
			stepartist="zaniel",
			pack="Goreshit 2020",
			difficulty=21,
			steps=7065,
			bpm_tier=210,
			measures=438,
			adj_stream=0.9733,
			bpm=216,
			length=8.63,
			dp=131, ep=924, dp_ep=1000, rp=5000,
		},
		{
			id=59,
			name="[21] [218] Ride the Centaurus FB 218",
			stepartist="@@",
			pack="Scrapyard Kent",
			difficulty=21,
			steps=6820,
			bpm_tier=210,
			measures=406,
			adj_stream=0.9291,
			bpm=218,
			length=8.77,
			dp=174, ep=847, dp_ep=802, rp=5000,
		},
		{
			id=60,
			name="[21] [220] The Body Cosmic",
			stepartist="Chief Skittles",
			pack="Skittles Stream Collection",
			difficulty=21,
			steps=6952,
			bpm_tier=220,
			measures=425,
			adj_stream=0.8817,
			bpm=220,
			length=9,
			dp=218, ep=770, dp_ep=609, rp=5000,
		},
		{
			id=61,
			name="[21] [220] Stay Safe",
			stepartist="yutsi",
			pack="Dark Psychungus",
			difficulty=21,
			steps=6346,
			bpm_tier=220,
			measures=374,
			adj_stream=0.8926,
			bpm=220,
			length=8.02,
			dp=218, ep=693, dp_ep=158, rp=5000,
		},
		{
			id=62,
			name="[21] [229] Cyberware Factory",
			stepartist="yutsi",
			pack="selected yutsi works",
			difficulty=21,
			steps=4326,
			bpm_tier=220,
			measures=254,
			adj_stream=0.8581,
			bpm=229,
			length=5.65,
			dp=414, ep=616, dp_ep=854, rp=5000,
		},
		{
			id=63,
			name="[21] [230] Venus Fire (Hard)",
			stepartist="YourVinished",
			pack="Saitama's Ultimate Weapon",
			difficulty=21,
			steps=4517,
			bpm_tier=230,
			measures=262,
			adj_stream=0.8371,
			bpm=230,
			length=5.83,
			dp=435, ep=539, dp_ep=527, rp=5000,
		},
		{
			id=64,
			name="[21] [233] CAFO (Hard)",
			stepartist="yutsi",
			pack="yutsi-type beats",
			difficulty=21,
			steps=4617,
			bpm_tier=230,
			measures=259,
			adj_stream=0.7194,
			bpm=233,
			length=6.53,
			dp=500, ep=385, dp_ep=6, rp=5000,
		},
		{
			id=65,
			name="[21] [234] Cerveau (Pattern J Remix) FB 234",
			stepartist="Kyy",
			pack="Kyypakkaus 2",
			difficulty=21,
			steps=3536,
			bpm_tier=230,
			measures=206,
			adj_stream=0.8306,
			bpm=234,
			length=4.5,
			dp=522, ep=462, dp_ep=585, rp=5000,
		},
		{
			id=66,
			name="[21] [240] Murder Liner",
			stepartist="Kyy",
			pack="Kyypakkaus 2",
			difficulty=21,
			steps=2933,
			bpm_tier=240,
			measures=157,
			adj_stream=0.7269,
			bpm=240,
			length=4.1,
			dp=653, ep=308, dp_ep=451, rp=5000,
		},
		{
			id=67,
			name="[21] [240] Jesus is the Answer",
			stepartist="zaniel",
			pack="Junts 2",
			difficulty=21,
			steps=2708,
			bpm_tier=240,
			measures=154,
			adj_stream=0.7299,
			bpm=240,
			length=3.78,
			dp=653, ep=231, dp_ep=0, rp=5000,
		},
		{
			id=68,
			name="[21] [248] Soul Surrender",
			stepartist="Kyy",
			pack="Kyypakkaus 2",
			difficulty=21,
			steps=1967,
			bpm_tier=240,
			measures=106,
			adj_stream=0.6235,
			bpm=248,
			length=2.87,
			dp=827, ep=77, dp_ep=117, rp=5000,
		},
		{
			id=69,
			name="[21] [250] The Morning After The Storm (Hard)",
			stepartist="Chief Skittles",
			pack="Trails of Cold Stream IV",
			difficulty=21,
			steps=2739,
			bpm_tier=250,
			measures=144,
			adj_stream=0.6729,
			bpm=250,
			length=3.49,
			dp=870, ep=154, dp_ep=819, rp=5000,
		},
		{
			id=70,
			name="[21] [256] Witches Brew",
			stepartist="Aoreo",
			pack="Content Cop - Tachyon Epsilon",
			difficulty=21,
			steps=1262,
			bpm_tier=250,
			measures=64,
			adj_stream=0.64,
			bpm=256,
			length=2.23,
			dp=1000, ep=0, dp_ep=679, rp=5000,
		},
		{
			id=71,
			name="[22] [225] Nachmancore",
			stepartist="nv & ChasePines & StarrySergal",
			pack="Big Waves",
			difficulty=22,
			steps=13281,
			bpm_tier=220,
			measures=768,
			adj_stream=0.8828,
			bpm=225,
			length=16.14,
			dp=122, ep=1000, dp_ep=595, rp=6000,
		},
		{
			id=72,
			name="[22] [220] Spacetime FB 220",
			stepartist="Nav",
			pack="Big Waves",
			difficulty=22,
			steps=8449,
			bpm_tier=220,
			measures=528,
			adj_stream=1,
			bpm=220,
			length=9.82,
			dp=0, ep=924, dp_ep=29, rp=6000,
		},
		{
			id=73,
			name="[22] [227] Lunar Butterfly FB 227",
			stepartist="Nav",
			pack="Big Waves",
			difficulty=22,
			steps=7834,
			bpm_tier=220,
			measures=472,
			adj_stream=0.8551,
			bpm=227,
			length=10.5,
			dp=171, ep=770, dp_ep=78, rp=6000,
		},
		{
			id=74,
			name="[22] [230] Sujetjas Tanjec",
			stepartist="Kyy",
			pack="Kyypakkaus 2",
			difficulty=22,
			steps=9367,
			bpm_tier=230,
			measures=543,
			adj_stream=0.7858,
			bpm=230,
			length=12.49,
			dp=244, ep=847, dp_ep=506, rp=6000,
		},
		{
			id=75,
			name="[22] [230] Robot Brain Era FB 230",
			stepartist="Zaia",
			pack="Cirque du Huayra",
			difficulty=22,
			steps=5535,
			bpm_tier=230,
			measures=324,
			adj_stream=0.8757,
			bpm=230,
			length=6.68,
			dp=244, ep=693, dp_ep=66, rp=6000,
		},
		{
			id=76,
			name="[22] [237] Ralph Wiggum",
			stepartist="yutsi",
			pack="selected yutsi works",
			difficulty=22,
			steps=2690,
			bpm_tier=230,
			measures=168,
			adj_stream=1,
			bpm=237,
			length=2.91,
			dp=415, ep=616, dp_ep=335, rp=6000,
		},
		{
			id=77,
			name="[22] [240] Plastic Love (Night Tempo 100% Pure Remastered)",
			stepartist="Zaia",
			pack="City Pop",
			difficulty=22,
			steps=3210,
			bpm_tier=240,
			measures=188,
			adj_stream=0.8868,
			bpm=240,
			length=3.97,
			dp=488, ep=539, dp_ep=323, rp=6000,
		},
		{
			id=78,
			name="[22] [242] Nyan-Nyan Naughty Night",
			stepartist="nv",
			pack="epic",
			difficulty=22,
			steps=2156,
			bpm_tier=240,
			measures=132,
			adj_stream=0.9706,
			bpm=242,
			length=2.38,
			dp=537, ep=462, dp_ep=243, rp=6000,
		},
		{
			id=79,
			name="[22] [248] Tragedy",
			stepartist="Aoreo",
			pack="BangerZ 3",
			difficulty=22,
			steps=2589,
			bpm_tier=240,
			measures=130,
			adj_stream=0.6989,
			bpm=248,
			length=3.84,
			dp=683, ep=231, dp_ep=0, rp=6000,
		},
		{
			id=80,
			name="[22] [256] Musician (mitei bootleg)",
			stepartist="Zaia",
			pack="Big Waves",
			difficulty=22,
			steps=2954,
			bpm_tier=250,
			measures=162,
			adj_stream=0.7364,
			bpm=256,
			length=3.64,
			dp=879, ep=385, dp_ep=1000, rp=6000,
		},
		{
			id=81,
			name="[22] [252] Truckers Delight (Hard)",
			stepartist="yutsi",
			pack="yutsi-type beats",
			difficulty=22,
			steps=2391,
			bpm_tier=250,
			measures=140,
			adj_stream=0.7778,
			bpm=252,
			length=3.27,
			dp=781, ep=308, dp_ep=500, rp=6000,
		},
		{
			id=82,
			name="[22] [255] Yamada Stream",
			stepartist="Zaia",
			pack="Content Cop - Tachyon Epsilon",
			difficulty=22,
			steps=1679,
			bpm_tier=250,
			measures=95,
			adj_stream=0.8407,
			bpm=255,
			length=1.91,
			dp=854, ep=154, dp_ep=269, rp=6000,
		},
		{
			id=83,
			name="[22] [261] Fergalicious For Businalicious 261",
			stepartist="Aoreo",
			pack="BangerZ 3",
			difficulty=22,
			steps=2567,
			bpm_tier=260,
			measures=122,
			adj_stream=0.4919,
			bpm=261,
			length=4.02,
			dp=1000, ep=0, dp_ep=246, rp=6000,
		},
		{
			id=84,
			name="[22] [260] Illegal Function Call (Hard)",
			stepartist="yutsi",
			pack="streammania IIDX",
			difficulty=22,
			steps=1550,
			bpm_tier=260,
			measures=92,
			adj_stream=0.7541,
			bpm=260,
			length=1.97,
			dp=976, ep=77, dp_ep=398, rp=6000,
		},
	}
}

ECS.SongInfo.Upper = {
	-- These values will be calculated and set below.
	MinBpm = 0,
	MaxBpm = 0,
	MinScaled16ths = 0,
	MaxScaled16ths = 0,
	MinBlockLevel = 0,
	MaxBlockLevel = 0,
	MinLength = 0,
	Songs = {
		{
			id=1,
			name="[22] [225] Nachmancore",
			stepartist="nv & ChasePines & StarrySergal",
			pack="Big Waves",
			difficulty=22,
			steps=13281,
			bpm_tier=220,
			measures=768,
			adj_stream=0.8828,
			bpm=225,
			length=16.14,
			dp=122, ep=1000, dp_ep=595, rp=1000,
		},
		{
			id=2,
			name="[22] [220] Spacetime FB 220",
			stepartist="Nav",
			pack="Big Waves",
			difficulty=22,
			steps=8449,
			bpm_tier=220,
			measures=528,
			adj_stream=1,
			bpm=220,
			length=9.82,
			dp=0, ep=924, dp_ep=29, rp=1000,
		},
		{
			id=3,
			name="[22] [227] Lunar Butterfly FB 227",
			stepartist="Nav",
			pack="Big Waves",
			difficulty=22,
			steps=7834,
			bpm_tier=220,
			measures=472,
			adj_stream=0.8551,
			bpm=227,
			length=10.5,
			dp=171, ep=770, dp_ep=78, rp=1000,
		},
		{
			id=4,
			name="[22] [230] Sujetjas Tanjec",
			stepartist="Kyy",
			pack="Kyypakkaus 2",
			difficulty=22,
			steps=9367,
			bpm_tier=230,
			measures=543,
			adj_stream=0.7858,
			bpm=230,
			length=12.49,
			dp=244, ep=847, dp_ep=506, rp=1000,
		},
		{
			id=5,
			name="[22] [230] Robot Brain Era FB 230",
			stepartist="Zaia",
			pack="Cirque du Huayra",
			difficulty=22,
			steps=5535,
			bpm_tier=230,
			measures=324,
			adj_stream=0.8757,
			bpm=230,
			length=6.68,
			dp=244, ep=693, dp_ep=66, rp=1000,
		},
		{
			id=6,
			name="[22] [237] Ralph Wiggum",
			stepartist="yutsi",
			pack="selected yutsi works",
			difficulty=22,
			steps=2690,
			bpm_tier=230,
			measures=168,
			adj_stream=1,
			bpm=237,
			length=2.91,
			dp=415, ep=616, dp_ep=335, rp=1000,
		},
		{
			id=7,
			name="[22] [240] Plastic Love (Night Tempo 100% Pure Remastered)",
			stepartist="Zaia",
			pack="City Pop",
			difficulty=22,
			steps=3210,
			bpm_tier=240,
			measures=188,
			adj_stream=0.8868,
			bpm=240,
			length=3.97,
			dp=488, ep=539, dp_ep=323, rp=1000,
		},
		{
			id=8,
			name="[22] [242] Nyan-Nyan Naughty Night",
			stepartist="nv",
			pack="epic",
			difficulty=22,
			steps=2156,
			bpm_tier=240,
			measures=132,
			adj_stream=0.9706,
			bpm=242,
			length=2.38,
			dp=537, ep=462, dp_ep=243, rp=1000,
		},
		{
			id=9,
			name="[22] [248] Tragedy",
			stepartist="Aoreo",
			pack="BangerZ 3",
			difficulty=22,
			steps=2589,
			bpm_tier=240,
			measures=130,
			adj_stream=0.7065,
			bpm=248,
			length=3.84,
			dp=683, ep=231, dp_ep=0, rp=1000,
		},
		{
			id=10,
			name="[22] [256] Musician (mitei bootleg)",
			stepartist="Zaia",
			pack="Big Waves",
			difficulty=22,
			steps=2954,
			bpm_tier=250,
			measures=162,
			adj_stream=0.7364,
			bpm=256,
			length=3.64,
			dp=879, ep=385, dp_ep=1000, rp=1000,
		},
		{
			id=11,
			name="[22] [252] Truckers Delight (Hard)",
			stepartist="yutsi",
			pack="yutsi-type beats",
			difficulty=22,
			steps=2391,
			bpm_tier=250,
			measures=140,
			adj_stream=0.7778,
			bpm=252,
			length=3.27,
			dp=781, ep=308, dp_ep=500, rp=1000,
		},
		{
			id=12,
			name="[22] [255] Yamada Stream",
			stepartist="Zaia",
			pack="Content Cop - Tachyon Epsilon",
			difficulty=22,
			steps=1679,
			bpm_tier=250,
			measures=95,
			adj_stream=0.8407,
			bpm=255,
			length=1.91,
			dp=854, ep=154, dp_ep=269, rp=1000,
		},
		{
			id=13,
			name="[22] [261] Fergalicious For Businalicious 261",
			stepartist="Aoreo",
			pack="BangerZ 3",
			difficulty=22,
			steps=2567,
			bpm_tier=260,
			measures=122,
			adj_stream=0.4919,
			bpm=261,
			length=4.02,
			dp=1000, ep=0, dp_ep=246, rp=1000,
		},
		{
			id=14,
			name="[22] [260] Illegal Function Call (Hard)",
			stepartist="yutsi",
			pack="streammania IIDX",
			difficulty=22,
			steps=1550,
			bpm_tier=260,
			measures=92,
			adj_stream=0.7541,
			bpm=260,
			length=1.97,
			dp=976, ep=77, dp_ep=398, rp=1000,
		},
		{
			id=15,
			name="[23] [230] Animu Music Triad FB 230",
			stepartist="Archi",
			pack="Big Waves",
			difficulty=23,
			steps=24155,
			bpm_tier=230,
			measures=1432,
			adj_stream=0.8529,
			bpm=221,
			length=31.68,
			dp=0, ep=1000, dp_ep=224, rp=2000,
		},
		{
			id=16,
			name="[23] [237] Stars FB 237",
			stepartist="Zaia",
			pack="Big Waves",
			difficulty=23,
			steps=6317,
			bpm_tier=230,
			measures=381,
			adj_stream=0.9525,
			bpm=237,
			length=7.32,
			dp=327, ep=875, dp_ep=1000, rp=2000,
		},
		{
			id=17,
			name="[23] [240] Nose Feeder",
			stepartist="yutsi",
			pack="yutsi-type beats",
			difficulty=23,
			steps=4200,
			bpm_tier=240,
			measures=260,
			adj_stream=0.9811,
			bpm=240,
			length=4.6,
			dp=388, ep=750, dp_ep=754, rp=2000,
		},
		{
			id=18,
			name="[23] [248] Descendant of Genos",
			stepartist="ITGAlex",
			pack="Trails of Cold Stream III",
			difficulty=23,
			steps=2893,
			bpm_tier=240,
			measures=168,
			adj_stream=0.8485,
			bpm=248,
			length=3.85,
			dp=552, ep=625, dp_ep=904, rp=2000,
		},
		{
			id=19,
			name="[23] [250] Raven",
			stepartist="Kyy",
			pack="Kyypakkaus 2",
			difficulty=23,
			steps=2444,
			bpm_tier=250,
			measures=144,
			adj_stream=0.8944,
			bpm=250,
			length=2.75,
			dp=592, ep=500, dp_ep=577, rp=2000,
		},
		{
			id=20,
			name="[23] [258] Writhe in Pain",
			stepartist="nv",
			pack="epic",
			difficulty=23,
			steps=2115,
			bpm_tier=250,
			measures=108,
			adj_stream=0.871,
			bpm=258,
			length=2.59,
			dp=756, ep=250, dp_ep=247, rp=2000,
		},
		{
			id=21,
			name="[23] [260] Free Will",
			stepartist="Zaia",
			pack="Big Waves",
			difficulty=23,
			steps=1633,
			bpm_tier=260,
			measures=96,
			adj_stream=1,
			bpm=260,
			length=1.88,
			dp=796, ep=375, dp_ep=881, rp=2000,
		},
		{
			id=22,
			name="[23] [261] Dear You",
			stepartist="StarrySergal",
			pack="itg! Rhythm is just a step away",
			difficulty=23,
			steps=1642,
			bpm_tier=260,
			measures=93,
			adj_stream=0.823,
			bpm=261,
			length=1.95,
			dp=817, ep=125, dp_ep=0, rp=2000,
		},
		{
			id=23,
			name="[23] [270] Bad Guy",
			stepartist="Aoreo",
			pack="BangerZ 3",
			difficulty=23,
			steps=1325,
			bpm_tier=270,
			measures=75,
			adj_stream=0.7353,
			bpm=270,
			length=1.9,
			dp=1000, ep=0, dp_ep=224, rp=2000,
		},
		{
			id=24,
			name="[24] [245] Accel Zero FB 245",
			stepartist="Chief Skittles",
			pack="Big Waves",
			difficulty=24,
			steps=15940,
			bpm_tier=240,
			measures=864,
			adj_stream=0.7359,
			bpm=245,
			length=19.77,
			dp=0, ep=1000, dp_ep=597, rp=3000,
		},
		{
			id=25,
			name="[24] [248] promise",
			stepartist="nv",
			pack="epic",
			difficulty=24,
			steps=4014,
			bpm_tier=240,
			measures=240,
			adj_stream=0.9677,
			bpm=248,
			length=4.47,
			dp=86, ep=875, dp_ep=471, rp=3000,
		},
		{
			id=26,
			name="[24] [253] Over The Fullerene Acid Trip (mashup by glory limited)",
			stepartist="Rust",
			pack="Feelin' Rusty 4",
			difficulty=24,
			steps=3072,
			bpm_tier=250,
			measures=192,
			adj_stream=1,
			bpm=253,
			length=3.15,
			dp=229, ep=750, dp_ep=530, rp=3000,
		},
		{
			id=27,
			name="[24] [256] Molten Crater",
			stepartist="yutsi",
			pack="the",
			difficulty=24,
			steps=2978,
			bpm_tier=250,
			measures=182,
			adj_stream=0.9785,
			bpm=256,
			length=3.27,
			dp=315, ep=500, dp_ep=0, rp=3000,
		},
		{
			id=28,
			name="[24] [260] Fuuga",
			stepartist="Zaia",
			pack="Saitama's Ultimate Weapon",
			difficulty=24,
			steps=3642,
			bpm_tier=260,
			measures=213,
			adj_stream=0.9064,
			bpm=260,
			length=3.83,
			dp=429, ep=625, dp_ep=771, rp=3000,
		},
		{
			id=29,
			name="[24] [266] Liquid (Hard) (Paul Rosenthal Remix)",
			stepartist="yutsi",
			pack="itg! Rhythm is just a step away",
			difficulty=24,
			steps=2192,
			bpm_tier=260,
			measures=128,
			adj_stream=0.8,
			bpm=266,
			length=3.16,
			dp=600, ep=375, dp_ep=517, rp=3000,
		},
		{
			id=30,
			name="[24] [270] Fur and Claw",
			stepartist="Aoreo",
			pack="Big Waves",
			difficulty=24,
			steps=1797,
			bpm_tier=270,
			measures=92,
			adj_stream=0.807,
			bpm=270,
			length=2.31,
			dp=715, ep=250, dp_ep=484, rp=3000,
		},
		{
			id=31,
			name="[24] [276] Amor de Verao",
			stepartist="nv",
			pack="streammania IIDX",
			difficulty=24,
			steps=1628,
			bpm_tier=270,
			measures=84,
			adj_stream=0.6885,
			bpm=276,
			length=2,
			dp=886, ep=0, dp_ep=230, rp=3000,
		},
		{
			id=32,
			name="[24] [280] Fire Hive (Hard)",
			stepartist="yutsi",
			pack="itg! Rhythm is just a step away",
			difficulty=24,
			steps=1286,
			bpm_tier=280,
			measures=60,
			adj_stream=1,
			bpm=280,
			length=1.97,
			dp=1000, ep=125, dp_ep=1000, rp=3000,
		},
		{
			id=33,
			name="[25] [240] Get Deaded (Rerestep) FP 240",
			stepartist="Nav & Zaia & StarrySergal & Levitas",
			pack="Big Waves",
			difficulty=25,
			steps=18045,
			bpm_tier=240,
			measures=1082,
			adj_stream=0.9201,
			bpm=240,
			length=20.7,
			dp=0, ep=1000, dp_ep=140, rp=4000,
		},
		{
			id=34,
			name="[25] [256] Paranoid",
			stepartist="Levitas",
			pack="Big Waves",
			difficulty=25,
			steps=4548,
			bpm_tier=250,
			measures=273,
			adj_stream=0.9286,
			bpm=257,
			length=5.01,
			dp=340, ep=875, dp_ep=1000, rp=4000,
		},
		{
			id=35,
			name="[25] [260] Image Material <Version 0>",
			stepartist="nv",
			pack="itg! Rhythm is just a step away",
			difficulty=25,
			steps=5071,
			bpm_tier=260,
			measures=302,
			adj_stream=0.858,
			bpm=260,
			length=6.46,
			dp=400, ep=750, dp_ep=740, rp=4000,
		},
		{
			id=36,
			name="[25] [266] Avid (Ayatori DnB Edit)",
			stepartist="Zaia",
			pack="Big Waves",
			difficulty=25,
			steps=3918,
			bpm_tier=260,
			measures=228,
			adj_stream=0.8669,
			bpm=266,
			length=4.54,
			dp=520, ep=625, dp_ep=720, rp=4000,
		},
		{
			id=37,
			name="[25] [272] Ashes on The Fire",
			stepartist="Zaia",
			pack="Big Waves",
			difficulty=25,
			steps=3174,
			bpm_tier=270,
			measures=178,
			adj_stream=0.7807,
			bpm=272,
			length=3.82,
			dp=640, ep=375, dp_ep=200, rp=4000,
		},
		{
			id=38,
			name="[25] [274] Scias",
			stepartist="Chief Skittles",
			pack="Trails of Cold Stream IV",
			difficulty=25,
			steps=2838,
			bpm_tier=270,
			measures=171,
			adj_stream=0.9,
			bpm=274,
			length=2.92,
			dp=680, ep=500, dp_ep=860, rp=4000,
		},
		{
			id=39,
			name="[25] [280] Ruby Illusions",
			stepartist="Zaia",
			pack="The Sound of Speed",
			difficulty=25,
			steps=1984,
			bpm_tier=280,
			measures=108,
			adj_stream=0.806,
			bpm=280,
			length=2.2,
			dp=800, ep=250, dp_ep=340, rp=4000,
		},
		{
			id=40,
			name="[25] [282] Oblivion ~Rockin' Night Style~",
			stepartist="Zaia",
			pack="fof 2",
			difficulty=25,
			steps=1359,
			bpm_tier=280,
			measures=71,
			adj_stream=0.9595,
			bpm=282,
			length=1.93,
			dp=840, ep=125, dp_ep=0, rp=4000,
		},
		{
			id=41,
			name="[25] [290] PARANOIA survivor MAX",
			stepartist="Zaia",
			pack="Dump Dump Revolution",
			difficulty=25,
			steps=1418,
			bpm_tier=290,
			measures=78,
			adj_stream=0.7879,
			bpm=290,
			length=1.58,
			dp=1000, ep=0, dp_ep=140, rp=4000,
		},
		{
			id=42,
			name="[26] [260] Apocalyptic Dawn",
			stepartist="Zaia & Archi & StarrySergal",
			pack="Big Waves",
			difficulty=26,
			steps=16956,
			bpm_tier=260,
			measures=1018,
			adj_stream=0.8164,
			bpm=260,
			length=20.97,
			dp=0, ep=1000, dp_ep=400, rp=5000,
		},
		{
			id=43,
			name="[26] [267] Hunting For Your Dream",
			stepartist="Levitas",
			pack="Big Waves",
			difficulty=26,
			steps=4805,
			bpm_tier=260,
			measures=284,
			adj_stream=0.8987,
			bpm=267,
			length=4.97,
			dp=180, ep=858, dp_ep=556, rp=5000,
		},
		{
			id=44,
			name="[26] [272] Scarlet Devil",
			stepartist="Chief Skittles",
			pack="Bigger Waves",
			difficulty=26,
			steps=4520,
			bpm_tier=270,
			measures=267,
			adj_stream=0.8783,
			bpm=272,
			length=4.82,
			dp=308, ep=715, dp_ep=494, rp=5000,
		},
		{
			id=45,
			name="[26] [274] Gens d'Leges 5",
			stepartist="Arvin",
			pack="fof",
			difficulty=26,
			steps=2717,
			bpm_tier=270,
			measures=167,
			adj_stream=1,
			bpm=274,
			length=2.73,
			dp=359, ep=572, dp_ep=119, rp=5000,
		},
		{
			id=46,
			name="[26] [287] Doomsday Zone",
			stepartist="StarrySergal",
			pack="The Sound of Speed",
			difficulty=26,
			steps=2100,
			bpm_tier=280,
			measures=128,
			adj_stream=0.9846,
			bpm=288,
			length=2.06,
			dp=718, ep=429, dp_ep=1000, rp=5000,
		},
		{
			id=47,
			name="[26] [284] Soar ~Stay With Me~",
			stepartist="Zaia",
			pack="fof 2",
			difficulty=26,
			steps=1977,
			bpm_tier=280,
			measures=120,
			adj_stream=1,
			bpm=284,
			length=1.89,
			dp=616, ep=286, dp_ep=0, rp=5000,
		},
		{
			id=48,
			name="[26] [299] Southcoast Calling (Medium)",
			stepartist="Aoreo",
			pack="BangerZ 3",
			difficulty=26,
			steps=2750,
			bpm_tier=290,
			measures=141,
			adj_stream=0.5755,
			bpm=299,
			length=3.46,
			dp=1000, ep=0, dp_ep=400, rp=5000,
		},
		{
			id=49,
			name="[26] [291] SpaceRage",
			stepartist="Levitas",
			pack="Theoretical Chiptune Pack",
			difficulty=26,
			steps=1947,
			bpm_tier=290,
			measures=116,
			adj_stream=0.8169,
			bpm=291,
			length=2.35,
			dp=795, ep=143, dp_ep=147, rp=5000,
		},
		{
			id=50,
			name="[27] [265] untitled djkurara mix FB 265",
			stepartist="Rust & Zaia & Zaniel",
			pack="Big Waves",
			difficulty=27,
			steps=17783,
			bpm_tier=260,
			measures=1032,
			adj_stream=0.81,
			bpm=265,
			length=19.79,
			dp=0, ep=1000, dp_ep=382, rp=6000,
		},
		{
			id=51,
			name="[27] [276] Lovelyteks FP 184",
			stepartist="Levitas",
			pack="Theoretical Sharpnel Pack",
			difficulty=27,
			steps=4998,
			bpm_tier=270,
			measures=312,
			adj_stream=0.9811,
			bpm=276,
			length=4.65,
			dp=440, ep=667, dp_ep=1000, rp=6000,
		},
		{
			id=52,
			name="[27] [280] Pushing Onwards",
			stepartist="Levitas",
			pack="Theoretical Chiptune Pack",
			difficulty=27,
			steps=3790,
			bpm_tier=280,
			measures=234,
			adj_stream=1,
			bpm=280,
			length=3.66,
			dp=600, ep=334, dp_ep=0, rp=6000,
		},
		{
			id=53,
			name="[27] [290] Bye Bye Baby Balloon",
			stepartist="Aoreo",
			pack="BangerZ 3",
			difficulty=27,
			steps=2465,
			bpm_tier=290,
			measures=148,
			adj_stream=0.9024,
			bpm=290,
			length=2.47,
			dp=1000, ep=0, dp_ep=382, rp=6000,
		},
	}
}


local InitializeSongStats = function(SongInfo)
	for song_data in ivalues(SongInfo.Songs) do
		SongInfo.MinBpm = SongInfo.MinBpm == 0 and song_data.bpm or math.min(SongInfo.MinBpm, song_data.bpm)
		SongInfo.MaxBpm = SongInfo.MaxBpm == 0 and song_data.bpm or math.max(SongInfo.MaxBpm, song_data.bpm)
		SongInfo.MinScaled16ths = SongInfo.MinScaled16ths == 0 and song_data.measures or math.min(SongInfo.MinScaled16ths, song_data.measures)
		SongInfo.MaxScaled16ths = SongInfo.MaxScaled16ths == 0 and song_data.measures or math.max(SongInfo.MaxScaled16ths, song_data.measures)
		SongInfo.MinBlockLevel = SongInfo.MinBlockLevel == 0 and song_data.difficulty or math.min(SongInfo.MinBlockLevel, song_data.difficulty)
		SongInfo.MaxBlockLevel = SongInfo.MaxBlockLevel == 0 and song_data.difficulty or math.max(SongInfo.MaxBlockLevel, song_data.difficulty)
		SongInfo.MinLength = SongInfo.MinLength == 0 and song_data.length or math.min(SongInfo.MinLength, song_data.length)
	end
end

InitializeSongStats(ECS.SongInfo.Lower)
InitializeSongStats(ECS.SongInfo.Mid)
InitializeSongStats(ECS.SongInfo.Upper)

-- ------------------------------------------------------
-- Player Data

-- initial player relic data
ECS.Players = {}

ECS.Players["Lord Farquaad"] = {
	id=66683,
	division="upper",
	country="Canada",
	level=99,
	exp=4561311,
	relics = {
		{name="Gilded Gallows", quantity=1},
		{name="Agility Potion", quantity=2},
		{name="Swift Abaddon", quantity=1},
		{name="Broken Katana", quantity=1},
		{name="Cleft Spear", quantity=1},
		{name="Worn Kunai", quantity=1},
		{name="Kikoku", quantity=1},
		{name="Yagyu Darkblade", quantity=1},
		{name="Shattered Greatsword", quantity=1},
		{name="Atma Weapon", quantity=1},
		{name="Ultima Weapon", quantity=1},
		{name="Tauret", quantity=1},
		{name="Twashtar", quantity=1},
		{name="Armajejjon", quantity=1},
		{name="Anointed Mario", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Shield Rod", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Crystal Trophy", quantity=1},
		{name="Ivory Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Alacritous Aspis", quantity=1},
		{name="Principia", quantity=1},
		{name="Arvin's Gambit", quantity=1},
		{name="Almagest", quantity=1},
	},
	tier_skill = {[120]=76, [130]=22, [140]=10, [150]=12, [160]=11, [170]=7, [180]=1, [190]=1, [200]=5, [210]=5, [220]=14, [230]=24, [240]=63, [250]=73, [260]=99, [270]=99, [280]=99, [290]=99},
	affinities = {dp=0, ep=0, rp=800, ap=0},
	lifetime_song_gold = 30354,
	lifetime_jp = 3217492,
}

ECS.Players["CardboardBox"] = {
	id=7260,
	division="upper",
	country="Canada",
	level=99,
	exp=3957248,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Busted Scythe", quantity=1},
		{name="Loose Hatchet", quantity=1},
		{name="Broken Katana", quantity=1},
		{name="Cleft Spear", quantity=1},
		{name="Worn Kunai", quantity=1},
		{name="Kikoku", quantity=1},
		{name="Shattered Greatsword", quantity=1},
		{name="Atma Weapon", quantity=1},
		{name="Tauret", quantity=1},
		{name="Twashtar", quantity=1},
		{name="Armajejjon", quantity=1},
		{name="Mario For Pleasure", quantity=1},
		{name="Juicer Mario", quantity=1},
		{name="Anointed Mario", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Chicken Knife", quantity=1},
		{name="Speed Shoes", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Shield Rod", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Corps Captain Uniform", quantity=1},
		{name="Corps General Uniform", quantity=1},
		{name="Cultist Robes", quantity=1},
		{name="Claiomh Solais", quantity=1},
		{name="Aegis", quantity=1},
		{name="Throne", quantity=1},
		{name="Perish", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Crystal Trophy", quantity=1},
		{name="Ivory Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Scrupulous Shield", quantity=1},
		{name="Virtue Blade", quantity=1},
		{name="Astral Ring", quantity=1},
		{name="Flawless Iluvatar ", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Alacritous Aspis", quantity=1},
		{name="Principia", quantity=1},
		{name="Arvin's Gambit", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Indefatigable Escutcheon", quantity=1},
		{name="Vampiric Longsword", quantity=1},
		{name="Faust's Scalpel", quantity=1},
		{name="Muramasa", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=52, [150]=58, [160]=53, [170]=60, [180]=55, [190]=39, [200]=48, [210]=36, [220]=62, [230]=38, [240]=53, [250]=46, [260]=99, [270]=99, [280]=99, [290]=99},
	affinities = {dp=350, ep=0, rp=350, ap=100},
	lifetime_song_gold = 100121,
	lifetime_jp = 1580825,
}

ECS.Players["Rust ITG"] = {
	id=66550,
	division="upper",
	country="U.S.A.",
	level=99,
	exp=4092393,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Busted Scythe", quantity=1},
		{name="Loose Hatchet", quantity=1},
		{name="Cleft Spear", quantity=1},
		{name="Worn Kunai", quantity=1},
		{name="Kikoku", quantity=1},
		{name="Shattered Greatsword", quantity=1},
		{name="Tauret", quantity=1},
		{name="Juicer Mario", quantity=1},
		{name="Anointed Mario", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Chicken Knife", quantity=1},
		{name="Speed Shoes", quantity=1},
		{name="Shield Rod", quantity=1},
		{name="Alucard Shield", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Corps Captain Uniform", quantity=1},
		{name="Corps General Uniform", quantity=1},
		{name="Cultist Robes", quantity=1},
		{name="Claiomh Solais", quantity=1},
		{name="Aegis", quantity=1},
		{name="Throne", quantity=1},
		{name="Perish", quantity=1},
		{name="Champion Belt", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Crystal Trophy", quantity=1},
		{name="Ivory Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Alacritous Aspis", quantity=1},
		{name="Principia", quantity=1},
		{name="Arvin's Gambit", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Indefatigable Escutcheon", quantity=1},
		{name="Vampiric Longsword", quantity=1},
		{name="Faust's Scalpel", quantity=1},
	},
	tier_skill = {[120]=99, [130]=26, [140]=17, [150]=26, [160]=25, [170]=22, [180]=34, [190]=21, [200]=38, [210]=36, [220]=33, [230]=31, [240]=22, [250]=49, [260]=99, [270]=52, [280]=43, [290]=63},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 10021,
	lifetime_jp = 2352759,
}

ECS.Players["mattm"] = {
	id=6657,
	division="upper",
	country="U.S.A.",
	level=99,
	exp=3349696,
	relics = {
		{name="Mythril Knife", quantity=1},
		{name="Silver Stopwatch", quantity=1},
		{name="Baguette", quantity=99},
		{name="Pain Brioche", quantity=1},
		{name="Faluche", quantity=1},
		{name="BURGER", quantity=99},
		{name="Lance of Longinus", quantity=1},
		{name="Ornate Hourglass", quantity=4},
		{name="Swift Abaddon", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Loose Hatchet", quantity=1},
		{name="Kulutues", quantity=1},
		{name="Broken Katana", quantity=1},
		{name="Enma", quantity=1},
		{name="Cleft Spear", quantity=1},
		{name="Silence Glaive", quantity=1},
		{name="Worn Kunai", quantity=1},
		{name="Shattered Greatsword", quantity=1},
		{name="Tauret", quantity=1},
		{name="Mario For Pleasure", quantity=1},
		{name="Juicer Mario", quantity=1},
		{name="Anointed Mario", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Chicken Knife", quantity=1},
		{name="Speed Shoes", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Shield Rod", quantity=1},
		{name="Alucard Shield", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Corps Captain Uniform", quantity=1},
		{name="Corps General Uniform", quantity=1},
		{name="Cultist Robes", quantity=1},
		{name="Claiomh Solais", quantity=1},
		{name="Aegis", quantity=1},
		{name="Throne", quantity=1},
		{name="Perish", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Crystal Trophy", quantity=1},
		{name="Ivory Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Scrupulous Shield", quantity=1},
		{name="Virtue Blade", quantity=1},
		{name="Astral Ring", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Alacritous Aspis", quantity=1},
		{name="Principia", quantity=1},
		{name="Arvin's Gambit", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Indefatigable Escutcheon", quantity=1},
		{name="Vampiric Longsword", quantity=1},
		{name="Faust's Scalpel", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=77, [140]=60, [150]=66, [160]=42, [170]=70, [180]=47, [190]=34, [200]=32, [210]=23, [220]=24, [230]=99, [240]=99, [250]=99, [260]=80, [270]=54, [280]=74, [290]=59},
	affinities = {dp=371, ep=129, rp=300, ap=0},
	lifetime_song_gold = 61392,
	lifetime_jp = 1049511,
}

ECS.Players["JNero"] = {
	id=4707,
	division="upper",
	country="Canada",
	level=93,
	exp=1915600,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Cleft Spear", quantity=1},
		{name="Shattered Greatsword", quantity=1},
		{name="Tauret", quantity=1},
		{name="Mario For Pleasure", quantity=1},
		{name="Juicer Mario", quantity=1},
		{name="Anointed Mario", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Speed Shoes", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Corps Captain Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Crystal Trophy", quantity=1},
		{name="Ivory Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Alacritous Aspis", quantity=1},
		{name="Principia", quantity=1},
		{name="Arvin's Gambit", quantity=1},
		{name="Slime Badge", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=69, [160]=55, [170]=65, [180]=56, [190]=33, [200]=28, [210]=27, [220]=15, [230]=20, [240]=15, [250]=34, [260]=21, [270]=45, [280]=75, [290]=46},
	affinities = {dp=379, ep=0, rp=300, ap=0},
	lifetime_song_gold = 54973,
	lifetime_jp = 721327,
}

ECS.Players["Rawinput"] = {
	id=1975,
	division="upper",
	country="U.S.A.",
	level=84,
	exp=884546,
	relics = {
		{name="Stone Arrow", quantity=26},
		{name="Ornate Hourglass", quantity=2},
		{name="Crystal Dagger", quantity=1},
		{name="Twisted Bow", quantity=1},
		{name="Worn Kunai", quantity=1},
		{name="Shattered Greatsword", quantity=1},
		{name="Tauret", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Champion Belt", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Crystal Trophy", quantity=1},
		{name="Ivory Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
	},
	tier_skill = {[120]=50, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=5, [190]=1, [200]=1, [210]=2, [220]=3, [230]=6, [240]=17, [250]=19, [260]=30, [270]=37, [280]=54, [290]=1},
	affinities = {dp=0, ep=0, rp=540, ap=0},
	lifetime_song_gold = 966,
	lifetime_jp = 376595,
}

ECS.Players["Yuzuddr"] = {
	id=104911,
	division="upper",
	country="Japan",
	level=99,
	exp=3641814,
	relics = {
		{name="Bronze Arrow", quantity=1},
		{name="Baguette", quantity=1},
		{name="Pain Viennois", quantity=1},
		{name="BURGER", quantity=1},
		{name="Ornate Hourglass", quantity=5},
		{name="Gilded Gallows", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Amos' Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Busted Scythe", quantity=1},
		{name="Vassal Scythe", quantity=1},
		{name="Loose Hatchet", quantity=1},
		{name="Broken Katana", quantity=1},
		{name="Cleft Spear", quantity=1},
		{name="Worn Kunai", quantity=1},
		{name="Shattered Greatsword", quantity=1},
		{name="Tauret", quantity=1},
		{name="Anointed Mario", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Shield Rod", quantity=1},
		{name="Corps Captain Uniform", quantity=1},
		{name="Corps General Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Crystal Trophy", quantity=1},
		{name="Ivory Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Alacritous Aspis", quantity=1},
		{name="Principia", quantity=1},
		{name="Arvin's Gambit", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=90, [150]=99, [160]=89, [170]=99, [180]=99, [190]=68, [200]=74, [210]=63, [220]=99, [230]=95, [240]=74, [250]=80, [260]=88, [270]=56, [280]=72, [290]=40},
	affinities = {dp=650, ep=49, rp=100, ap=1},
	lifetime_song_gold = 41906,
	lifetime_jp = 959649,
}

ECS.Players["Perusal"] = {
	id=66471,
	division="upper",
	country="Canada",
	level=99,
	exp=4071733,
	relics = {
		{name="Silver Stopwatch", quantity=6},
		{name="BURGER", quantity=1},
		{name="Long Boi", quantity=1},
		{name="Diamond Dagger", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Amos' Bow", quantity=1},
		{name="Yoichi Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Busted Scythe", quantity=1},
		{name="Vassal Scythe", quantity=1},
		{name="Loose Hatchet", quantity=1},
		{name="Kulutues", quantity=1},
		{name="Divine Axe Rhitta", quantity=1},
		{name="Broken Katana", quantity=1},
		{name="Enma", quantity=1},
		{name="Cleft Spear", quantity=1},
		{name="Worn Kunai", quantity=1},
		{name="Juicer Mario", quantity=1},
		{name="Anointed Mario", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Chicken Knife", quantity=1},
		{name="Speed Shoes", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Shield Rod", quantity=1},
		{name="Alucard Shield", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Corps Captain Uniform", quantity=1},
		{name="Corps General Uniform", quantity=1},
		{name="Cultist Robes", quantity=1},
		{name="Claiomh Solais", quantity=1},
		{name="Aegis", quantity=1},
		{name="Throne", quantity=1},
		{name="Perish", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Crystal Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Alacritous Aspis", quantity=1},
		{name="Principia", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Indefatigable Escutcheon", quantity=1},
		{name="Vampiric Longsword", quantity=1},
		{name="Faust's Scalpel", quantity=1},
		{name="Muramasa", quantity=1},
	},
	tier_skill = {[120]=99, [130]=78, [140]=57, [150]=48, [160]=85, [170]=97, [180]=99, [190]=75, [200]=74, [210]=94, [220]=99, [230]=99, [240]=99, [250]=94, [260]=43, [270]=10, [280]=2, [290]=1},
	affinities = {dp=0, ep=600, rp=200, ap=0},
	lifetime_song_gold = 39422,
	lifetime_jp = 706851,
}

ECS.Players["nidyz"] = {
	id=66678,
	division="upper",
	country="Netherlands",
	level=91,
	exp=1574833,
	relics = {
		{name="BURGER", quantity=1},
		{name="Diamond Axe", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Busted Scythe", quantity=1},
		{name="Broken Katana", quantity=1},
		{name="Cleft Spear", quantity=1},
		{name="Juicer Mario", quantity=1},
		{name="Anointed Mario", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Chicken Knife", quantity=1},
		{name="Speed Shoes", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Corps Captain Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Crystal Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
	},
	tier_skill = {[120]=48, [130]=10, [140]=14, [150]=4, [160]=25, [170]=44, [180]=52, [190]=34, [200]=45, [210]=58, [220]=43, [230]=29, [240]=43, [250]=41, [260]=21, [270]=6, [280]=1, [290]=3},
	affinities = {dp=0, ep=300, rp=347, ap=0},
	lifetime_song_gold = 21370,
	lifetime_jp = 149363,
}

ECS.Players["Akou"] = {
	id=73042,
	division="upper",
	country="U.S.A.",
	level=87,
	exp=1134214,
	relics = {
		{name="Silver Stopwatch", quantity=2},
		{name="Ornate Hourglass", quantity=5},
		{name="Crystal Dagger", quantity=1},
		{name="Dragon Arrow", quantity=1},
		{name="Cleft Spear", quantity=1},
		{name="Worn Kunai", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Crystal Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Alacritous Aspis", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Indefatigable Escutcheon", quantity=1},
	},
	tier_skill = {[120]=71, [130]=20, [140]=10, [150]=7, [160]=6, [170]=18, [180]=14, [190]=7, [200]=27, [210]=24, [220]=24, [230]=27, [240]=33, [250]=32, [260]=35, [270]=20, [280]=15, [290]=6},
	affinities = {dp=146, ep=147, rp=146, ap=146},
	lifetime_song_gold = 20633,
	lifetime_jp = 268407,
}

ECS.Players["DownArrowCatastrophe"] = {
	id=66667,
	division="upper",
	country="U.S.A.",
	level=87,
	exp=1119986,
	relics = {
		{name="Stone Arrow", quantity=10},
		{name="Twisted Bow", quantity=1},
		{name="Broken Katana", quantity=1},
		{name="Cleft Spear", quantity=1},
		{name="Worn Kunai", quantity=1},
		{name="Shattered Greatsword", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Crystal Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
	},
	tier_skill = {[120]=1, [130]=6, [140]=3, [150]=6, [160]=4, [170]=15, [180]=15, [190]=10, [200]=28, [210]=22, [220]=24, [230]=21, [240]=34, [250]=57, [260]=31, [270]=26, [280]=20, [290]=10},
	affinities = {dp=225, ep=180, rp=180, ap=0},
	lifetime_song_gold = 2165,
	lifetime_jp = 338194,
}

ECS.Players["Urza89"] = {
	id=66763,
	division="upper",
	country="Sweden",
	level=94,
	exp=2048793,
	relics = {
		{name="Long Bow", quantity=1},
		{name="Mythril Arrow", quantity=1},
		{name="Silver Stopwatch", quantity=2},
		{name="BURGER", quantity=99},
		{name="Diamond Axe", quantity=1},
		{name="Lance of Longinus", quantity=1},
		{name="Dragon Arrow", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Mandau", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Vampire Killer", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Amos' Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Almace", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Dragon Slayer", quantity=1},
		{name="Yoru", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Dainsleif", quantity=1},
		{name="Ridill", quantity=1},
		{name="Busted Scythe", quantity=1},
		{name="Loose Hatchet", quantity=1},
		{name="Broken Katana", quantity=1},
		{name="Juicer Mario", quantity=1},
		{name="Anointed Mario", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Chicken Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Alucard Shield", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Corps Captain Uniform", quantity=1},
		{name="Corps General Uniform", quantity=1},
		{name="Cultist Robes", quantity=1},
		{name="Claiomh Solais", quantity=1},
		{name="Aegis", quantity=1},
		{name="Perish", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Crystal Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Scrupulous Shield", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Alacritous Aspis", quantity=1},
		{name="Principia", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Indefatigable Escutcheon", quantity=1},
		{name="Vampiric Longsword", quantity=1},
		{name="Faust's Scalpel", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=99, [190]=99, [200]=99, [210]=99, [220]=60, [230]=55, [240]=35, [250]=22, [260]=16, [270]=9, [280]=6, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 95083,
	lifetime_jp = 114908,
}

ECS.Players["Dingoshi"] = {
	id=66546,
	division="mid",
	country="Australia",
	level=94,
	exp=2066542,
	relics = {
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=6},
		{name="Silver Stopwatch", quantity=4},
		{name="Baguette", quantity=9},
		{name="Faluche", quantity=3},
		{name="BURGER", quantity=99},
		{name="Lance of Longinus", quantity=1},
		{name="Crystal Dagger", quantity=1},
		{name="Dragon Arrow", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Busted Scythe", quantity=1},
		{name="Loose Hatchet", quantity=1},
		{name="Broken Katana", quantity=1},
		{name="Cleft Spear", quantity=1},
		{name="Worn Kunai", quantity=1},
		{name="Juicer Mario", quantity=1},
		{name="Anointed Mario", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Chicken Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Corps Captain Uniform", quantity=1},
		{name="Corps General Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Crystal Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Alacritous Aspis", quantity=1},
		{name="Principia", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Indefatigable Escutcheon", quantity=1},
		{name="Vampiric Longsword", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=94, [140]=81, [150]=73, [160]=78, [170]=85, [180]=86, [190]=57, [200]=73, [210]=46, [220]=61, [230]=45, [240]=74, [250]=61, [260]=40, [270]=8, [280]=5, [290]=3},
	affinities = {dp=347, ep=348, rp=0, ap=0},
	lifetime_song_gold = 56786,
	lifetime_jp = 273183,
}

ECS.Players["Arvin"] = {
	id=4866,
	division="mid",
	country="Canada",
	level=80,
	exp=656885,
	relics = {
		{name="Shattered Greatsword", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Crystal Trophy", quantity=1},
	},
	tier_skill = {[120]=50, [130]=1, [140]=1, [150]=3, [160]=1, [170]=2, [180]=3, [190]=2, [200]=4, [210]=1, [220]=4, [230]=3, [240]=11, [250]=14, [260]=16, [270]=27, [280]=29, [290]=12},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3120,
	lifetime_jp = 261309,
}

ECS.Players["nico"] = {
	id=35619,
	division="upper",
	country="U.S.A.",
	level=80,
	exp=656377,
	relics = {
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Crystal Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
	},
	tier_skill = {[120]=78, [130]=9, [140]=2, [150]=4, [160]=3, [170]=5, [180]=5, [190]=8, [200]=5, [210]=5, [220]=6, [230]=5, [240]=13, [250]=13, [260]=16, [270]=25, [280]=17, [290]=5},
	affinities = {dp=484, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1799,
	lifetime_jp = 245243,
}

ECS.Players["NBCrescendo"] = {
	id=6069,
	division="mid",
	country="Finland",
	level=90,
	exp=1478648,
	relics = {
		{name="Stone Blade", quantity=1},
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=1},
		{name="Bronze Blade", quantity=1},
		{name="Bronze Knife", quantity=1},
		{name="Bronze Axe", quantity=1},
		{name="Composite Bow", quantity=1},
		{name="Bronze Arrow", quantity=1},
		{name="Long Bow", quantity=1},
		{name="Mythril Arrow", quantity=1},
		{name="Silver Stopwatch", quantity=1},
		{name="Baguette", quantity=1},
		{name="Pain Viennois", quantity=1},
		{name="Pain Brioche", quantity=1},
		{name="Fougasse", quantity=1},
		{name="Faluche", quantity=1},
		{name="BURGER", quantity=1},
		{name="Lance of Longinus", quantity=1},
		{name="Ornate Hourglass", quantity=4},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Dragon Slayer", quantity=1},
		{name="Yoru", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Dainsleif", quantity=1},
		{name="Ridill", quantity=1},
		{name="Busted Scythe", quantity=1},
		{name="Vassal Scythe", quantity=1},
		{name="Loose Hatchet", quantity=1},
		{name="Broken Katana", quantity=1},
		{name="Mario For Pleasure", quantity=1},
		{name="Juicer Mario", quantity=1},
		{name="Anointed Mario", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Chicken Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Alucard Shield", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Corps Captain Uniform", quantity=1},
		{name="Corps General Uniform", quantity=1},
		{name="Cultist Robes", quantity=1},
		{name="Claiomh Solais", quantity=1},
		{name="Aegis", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Crystal Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Scrupulous Shield", quantity=1},
		{name="Virtue Blade", quantity=1},
		{name="Astral Ring", quantity=1},
		{name="Flawless Iluvatar ", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Alacritous Aspis", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Indefatigable Escutcheon", quantity=1},
		{name="Vampiric Longsword", quantity=1},
		{name="Faust's Scalpel", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=83, [170]=71, [180]=60, [190]=26, [200]=99, [210]=99, [220]=99, [230]=30, [240]=34, [250]=4, [260]=4, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=500, rp=131, ap=0},
	lifetime_song_gold = 131073,
	lifetime_jp = 26169,
}

ECS.Players["Krushrpants"] = {
	id=7457,
	division="mid",
	country="U.S.A.",
	level=95,
	exp=2190633,
	relics = {
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Silver Stopwatch", quantity=4},
		{name="Mammon", quantity=1},
		{name="Pain Brioche", quantity=1},
		{name="BURGER", quantity=99},
		{name="Lance of Longinus", quantity=1},
		{name="Crystal Dagger", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Busted Scythe", quantity=1},
		{name="Loose Hatchet", quantity=1},
		{name="Broken Katana", quantity=1},
		{name="Cleft Spear", quantity=1},
		{name="Worn Kunai", quantity=1},
		{name="Mario For Pleasure", quantity=1},
		{name="Juicer Mario", quantity=1},
		{name="Anointed Mario", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Chicken Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Alucard Shield", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Corps Captain Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Crystal Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Scrupulous Shield", quantity=1},
		{name="Virtue Blade", quantity=1},
		{name="Astral Ring", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Alacritous Aspis", quantity=1},
		{name="Principia", quantity=1},
		{name="Slime Badge", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=90, [150]=92, [160]=73, [170]=83, [180]=72, [190]=67, [200]=47, [210]=53, [220]=73, [230]=77, [240]=62, [250]=39, [260]=31, [270]=14, [280]=2, [290]=1},
	affinities = {dp=12, ep=0, rp=125, ap=575},
	lifetime_song_gold = 216987,
	lifetime_jp = 218444,
}

ECS.Players["Murd"] = {
	id=66755,
	division="upper",
	country="Canada",
	level=87,
	exp=1127716,
	relics = {
		{name="Stone Knife", quantity=1},
		{name="Stone Arrow", quantity=23},
		{name="Composite Bow", quantity=1},
		{name="Bronze Arrow", quantity=2},
		{name="Baguette", quantity=5},
		{name="Pain Viennois", quantity=5},
		{name="BURGER", quantity=34},
		{name="Crystal Dagger", quantity=1},
		{name="Dragon Arrow", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Broken Katana", quantity=1},
		{name="Worn Kunai", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Crystal Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Alacritous Aspis", quantity=1},
	},
	tier_skill = {[120]=99, [130]=46, [140]=29, [150]=19, [160]=20, [170]=31, [180]=20, [190]=19, [200]=10, [210]=18, [220]=23, [230]=21, [240]=43, [250]=21, [260]=49, [270]=12, [280]=2, [290]=4},
	affinities = {dp=292, ep=0, rp=292, ap=1},
	lifetime_song_gold = 16760,
	lifetime_jp = 326105,
}

ECS.Players["Sidro"] = {
	id=66613,
	division="mid",
	country="U.S.A.",
	level=88,
	exp=1284946,
	relics = {
		{name="Fougasse", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Busted Scythe", quantity=1},
		{name="Loose Hatchet", quantity=1},
		{name="Broken Katana", quantity=1},
		{name="Anointed Mario", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Alucard Shield", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Crystal Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Alacritous Aspis", quantity=1},
	},
	tier_skill = {[120]=99, [130]=44, [140]=32, [150]=35, [160]=19, [170]=43, [180]=19, [190]=15, [200]=19, [210]=34, [220]=48, [230]=48, [240]=49, [250]=26, [260]=13, [270]=1, [280]=1, [290]=1},
	affinities = {dp=600, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3623,
	lifetime_jp = 85284,
}

ECS.Players["artimst"] = {
	id=78743,
	division="mid",
	country="U.S.A.",
	level=85,
	exp=962442,
	relics = {
		{name="BURGER", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Busted Scythe", quantity=1},
		{name="Broken Katana", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Chicken Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Corps Captain Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Crystal Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Alacritous Aspis", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=19, [140]=18, [150]=13, [160]=5, [170]=42, [180]=37, [190]=36, [200]=43, [210]=18, [220]=32, [230]=29, [240]=34, [250]=21, [260]=11, [270]=4, [280]=5, [290]=6},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 8439,
	lifetime_jp = 98166,
}

ECS.Players["Doughbun"] = {
	id=91630,
	division="mid",
	country="U.S.A.",
	level=79,
	exp=614984,
	relics = {
		{name="Busted Scythe", quantity=1},
		{name="Loose Hatchet", quantity=1},
		{name="Anointed Mario", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Crystal Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Alacritous Aspis", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=48, [130]=6, [140]=1, [150]=4, [160]=5, [170]=7, [180]=2, [190]=6, [200]=4, [210]=21, [220]=28, [230]=33, [240]=17, [250]=12, [260]=14, [270]=7, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 12722,
	lifetime_jp = 79707,
}

ECS.Players["HISA"] = {
	id=66727,
	division="mid",
	country="Japan",
	level=78,
	exp=529312,
	relics = {
		{name="Silver Stopwatch", quantity=1},
		{name="Ornate Hourglass", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Crystal Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
	},
	tier_skill = {[120]=21, [130]=17, [140]=7, [150]=12, [160]=4, [170]=13, [180]=1, [190]=12, [200]=15, [210]=15, [220]=11, [230]=15, [240]=11, [250]=15, [260]=13, [270]=4, [280]=5, [290]=11},
	affinities = {dp=345, ep=100, rp=0, ap=0},
	lifetime_song_gold = 2582,
	lifetime_jp = 115144,
}

ECS.Players["Cyxsound"] = {
	id=129083,
	division="upper",
	country="Canada",
	level=77,
	exp=502141,
	relics = {
		{name="BURGER", quantity=99},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Chicken Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Alacritous Aspis", quantity=1},
	},
	tier_skill = {[120]=99, [130]=50, [140]=15, [150]=33, [160]=24, [170]=18, [180]=18, [190]=22, [200]=14, [210]=20, [220]=15, [230]=15, [240]=9, [250]=14, [260]=4, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 8599,
	lifetime_jp = 24177,
}

ECS.Players["tum"] = {
	id=137326,
	division="mid",
	country="Australia",
	level=89,
	exp=1309793,
	relics = {
		{name="Stone Blade", quantity=1},
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=1},
		{name="Baguette", quantity=1},
		{name="Pain Viennois", quantity=1},
		{name="Faluche", quantity=2},
		{name="BURGER", quantity=10},
		{name="Lance of Longinus", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Mandau", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Vampire Killer", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Amos' Bow", quantity=1},
		{name="Yoichi Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Almace", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Dragon Slayer", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Dainsleif", quantity=1},
		{name="Busted Scythe", quantity=1},
		{name="Anointed Mario", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Chicken Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Alucard Shield", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Corps Captain Uniform", quantity=1},
		{name="Corps General Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Crystal Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Scrupulous Shield", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Alacritous Aspis", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Indefatigable Escutcheon", quantity=1},
		{name="Vampiric Longsword", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=99, [190]=99, [200]=99, [210]=99, [220]=33, [230]=24, [240]=3, [250]=2, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=315, rp=300, ap=0},
	lifetime_song_gold = 26723,
	lifetime_jp = 8290,
}

ECS.Players["airplane"] = {
	id=135061,
	division="mid",
	country="U.S.A.",
	level=77,
	exp=485691,
	relics = {
		{name="BURGER", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Crystal Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
	},
	tier_skill = {[120]=99, [130]=17, [140]=7, [150]=15, [160]=17, [170]=48, [180]=31, [190]=19, [200]=9, [210]=9, [220]=7, [230]=8, [240]=18, [250]=5, [260]=10, [270]=8, [280]=9, [290]=6},
	affinities = {dp=111, ep=111, rp=111, ap=111},
	lifetime_song_gold = 4306,
	lifetime_jp = 92519,
}

ECS.Players["ensypuri"] = {
	id=66782,
	division="mid",
	country="U.S.A.",
	level=88,
	exp=1280222,
	relics = {
		{name="Fougasse", quantity=1},
		{name="Faluche", quantity=2},
		{name="BURGER", quantity=99},
		{name="Lance of Longinus", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Godhands", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Mandau", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Vampire Killer", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Pandemonium", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Amos' Bow", quantity=1},
		{name="Yoichi Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Almace", quantity=1},
		{name="Excalibur", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Dragon Slayer", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Busted Scythe", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Chicken Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Corps Captain Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Indefatigable Escutcheon", quantity=1},
		{name="Vampiric Longsword", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=99, [190]=99, [200]=99, [210]=86, [220]=51, [230]=20, [240]=17, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=600, rp=0, ap=0},
	lifetime_song_gold = 4739,
	lifetime_jp = 2233,
}

ECS.Players["Fugma"] = {
	id=76367,
	division="mid",
	country="U.S.A.",
	level=82,
	exp=772600,
	relics = {
		{name="Silver Stopwatch", quantity=2},
		{name="Baguette", quantity=1},
		{name="BURGER", quantity=25},
		{name="Lance of Longinus", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Dragon Slayer", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Chicken Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Corps Captain Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Alacritous Aspis", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=40, [140]=14, [150]=65, [160]=48, [170]=62, [180]=46, [190]=44, [200]=99, [210]=28, [220]=22, [230]=22, [240]=11, [250]=2, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=512, rp=0, ap=0},
	lifetime_song_gold = 14059,
	lifetime_jp = 4803,
}

ECS.Players["Archi"] = {
	id=6562,
	division="mid",
	country="U.S.A.",
	level=88,
	exp=1232435,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Mandau", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Amos' Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Almace", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Busted Scythe", quantity=1},
		{name="Juicer Mario", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Chicken Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Corps Captain Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Indefatigable Escutcheon", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=99, [190]=99, [200]=68, [210]=57, [220]=68, [230]=20, [240]=2, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 81279,
	lifetime_jp = 925,
}

ECS.Players["SteveReen"] = {
	id=5023,
	division="mid",
	country="U.S.A.",
	level=76,
	exp=478066,
	relics = {
		{name="Mythril Blade", quantity=1},
		{name="Silver Stopwatch", quantity=1},
		{name="BURGER", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Mario For Pleasure", quantity=1},
		{name="Anointed Mario", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Corps Captain Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Scrupulous Shield", quantity=1},
		{name="Virtue Blade", quantity=1},
		{name="Astral Ring", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=56, [140]=21, [150]=15, [160]=7, [170]=58, [180]=36, [190]=30, [200]=23, [210]=19, [220]=12, [230]=24, [240]=5, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=100, rp=0, ap=332},
	lifetime_song_gold = 73644,
	lifetime_jp = 2128,
}

ECS.Players["Tuuc"] = {
	id=7036,
	division="mid",
	country="Finland",
	level=85,
	exp=960486,
	relics = {
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=5},
		{name="Baguette", quantity=3},
		{name="Pain Brioche", quantity=1},
		{name="Faluche", quantity=2},
		{name="Ornate Hourglass", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Anointed Mario", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Chicken Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Corps Captain Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Alacritous Aspis", quantity=1},
	},
	tier_skill = {[120]=99, [130]=94, [140]=65, [150]=81, [160]=44, [170]=64, [180]=24, [190]=29, [200]=27, [210]=31, [220]=21, [230]=21, [240]=10, [250]=2, [260]=2, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=555, ap=0},
	lifetime_song_gold = 1547,
	lifetime_jp = 17100,
}

ECS.Players["JOKR"] = {
	id=1037,
	division="mid",
	country="U.S.A.",
	level=86,
	exp=1050521,
	relics = {
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Mythril Axe", quantity=1},
		{name="Silver Stopwatch", quantity=3},
		{name="Baguette", quantity=1},
		{name="Pain Viennois", quantity=2},
		{name="Fougasse", quantity=1},
		{name="Faluche", quantity=1},
		{name="BURGER", quantity=17},
		{name="Lance of Longinus", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Godhands", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Mandau", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Vampire Killer", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Amos' Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Almace", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Dragon Slayer", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Busted Scythe", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Chicken Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Corps Captain Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Scrupulous Shield", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Indefatigable Escutcheon", quantity=1},
		{name="Vampiric Longsword", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=99, [190]=99, [200]=99, [210]=52, [220]=30, [230]=11, [240]=2, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=100, ep=270, rp=200, ap=0},
	lifetime_song_gold = 83727,
	lifetime_jp = 203,
}

ECS.Players["HANIPAGANDA"] = {
	id=66491,
	division="mid",
	country="Japan",
	level=82,
	exp=782038,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Godhands", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Mandau", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Vampire Killer", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Pandemonium", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Amos' Bow", quantity=1},
		{name="Yoichi Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Almace", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Chicken Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Corps Captain Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Indefatigable Escutcheon", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=99, [190]=99, [200]=41, [210]=26, [220]=14, [230]=12, [240]=2, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 12546,
	lifetime_jp = 1863,
}

ECS.Players["Raijin29a6"] = {
	id=127933,
	division="mid",
	country="U.S.A.",
	level=69,
	exp=259241,
	relics = {
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=2},
		{name="Pain Viennois", quantity=6},
		{name="Fougasse", quantity=1},
		{name="BURGER", quantity=99},
		{name="Faulty Blade", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=21, [130]=1, [140]=1, [150]=6, [160]=12, [170]=21, [180]=22, [190]=44, [200]=27, [210]=18, [220]=10, [230]=4, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 829,
	lifetime_jp = 0,
}

ECS.Players["Akeem"] = {
	id=66309,
	division="mid",
	country="U.S.A.",
	level=69,
	exp=258005,
	relics = {
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
	},
	tier_skill = {[120]=76, [130]=12, [140]=5, [150]=17, [160]=44, [170]=42, [180]=56, [190]=61, [200]=23, [210]=20, [220]=3, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2721,
	lifetime_jp = 0,
}

ECS.Players["4199"] = {
	id=66692,
	division="mid",
	country="Canada",
	level=69,
	exp=250083,
	relics = {
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
	},
	tier_skill = {[120]=21, [130]=6, [140]=1, [150]=3, [160]=9, [170]=14, [180]=13, [190]=18, [200]=9, [210]=20, [220]=12, [230]=10, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 8187,
	lifetime_jp = 154,
}

ECS.Players["TroyNK"] = {
	id=1129,
	division="mid",
	country="U.S.A.",
	level=86,
	exp=1081222,
	relics = {
		{name="Stone Axe", quantity=1},
		{name="Stone Arrow", quantity=3},
		{name="Baguette", quantity=1},
		{name="Faluche", quantity=5},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Godhands", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Mandau", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Vampire Killer", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Amos' Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Chicken Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Corps Captain Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Indefatigable Escutcheon", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=99, [190]=93, [200]=73, [210]=54, [220]=26, [230]=18, [240]=4, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=570, rp=0, ap=0},
	lifetime_song_gold = 32309,
	lifetime_jp = 1558,
}

ECS.Players["kelly_kato"] = {
	id=66413,
	division="mid",
	country="Russian Federation",
	level=80,
	exp=642181,
	relics = {
		{name="Silver Stopwatch", quantity=2},
		{name="Baguette", quantity=8},
		{name="Fougasse", quantity=2},
		{name="Faluche", quantity=1},
		{name="Ornate Hourglass", quantity=2},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Amos' Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Almace", quantity=1},
		{name="Excalibur", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Chicken Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=81, [170]=99, [180]=99, [190]=99, [200]=53, [210]=28, [220]=15, [230]=5, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=484, rp=0, ap=0},
	lifetime_song_gold = 10911,
	lifetime_jp = 0,
}

ECS.Players["Xynn"] = {
	id=7385,
	division="mid",
	country="U.S.A.",
	level=82,
	exp=767373,
	relics = {
		{name="Bronze Knife", quantity=1},
		{name="Mythril Knife", quantity=1},
		{name="Mythril Axe", quantity=1},
		{name="Mythril Arrow", quantity=1},
		{name="Pain Brioche", quantity=2},
		{name="BURGER", quantity=1},
		{name="Lance of Longinus", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Mandau", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Vampire Killer", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Pandemonium", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Amos' Bow", quantity=1},
		{name="Yoichi Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Almace", quantity=1},
		{name="Excalibur", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Mario For Pleasure", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Chicken Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Scrupulous Shield", quantity=1},
		{name="Virtue Blade", quantity=1},
		{name="Astral Ring", quantity=1},
		{name="Flawless Iluvatar ", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Indefatigable Escutcheon", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=99, [190]=99, [200]=47, [210]=28, [220]=11, [230]=2, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=300, rp=0, ap=212},
	lifetime_song_gold = 127265,
	lifetime_jp = 1057,
}

ECS.Players["LOG"] = {
	id=66603,
	division="mid",
	country="Japan",
	level=78,
	exp=566646,
	relics = {
		{name="Stone Arrow", quantity=11},
		{name="Silver Stopwatch", quantity=2},
		{name="Crystal Axe", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Godhands", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Vampire Killer", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Amos' Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Indefatigable Escutcheon", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=99, [190]=91, [200]=27, [210]=11, [220]=3, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=458, rp=0, ap=0},
	lifetime_song_gold = 15324,
	lifetime_jp = 170,
}

ECS.Players["Nandii"] = {
	id=78597,
	division="mid",
	country="Netherlands",
	level=69,
	exp=263095,
	relics = {
		{name="BURGER", quantity=99},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
	},
	tier_skill = {[120]=99, [130]=44, [140]=21, [150]=36, [160]=20, [170]=18, [180]=14, [190]=23, [200]=6, [210]=19, [220]=4, [230]=10, [240]=6, [250]=2, [260]=2, [270]=1, [280]=1, [290]=1},
	affinities = {dp=110, ep=108, rp=76, ap=0},
	lifetime_song_gold = 1249,
	lifetime_jp = 6351,
}

ECS.Players["Dr.0ctgonapus"] = {
	id=66554,
	division="mid",
	country="U.S.A.",
	level=74,
	exp=398974,
	relics = {
		{name="Stone Blade", quantity=1},
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=10},
		{name="Composite Bow", quantity=1},
		{name="Bronze Arrow", quantity=2},
		{name="Baguette", quantity=7},
		{name="Pain Viennois", quantity=1},
		{name="BURGER", quantity=11},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Busted Scythe", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
	},
	tier_skill = {[120]=99, [130]=8, [140]=8, [150]=1, [160]=5, [170]=26, [180]=27, [190]=25, [200]=19, [210]=34, [220]=28, [230]=20, [240]=5, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 12108,
	lifetime_jp = 244,
}

ECS.Players["Fietsemaker"] = {
	id=66575,
	division="mid",
	country="Netherlands",
	level=80,
	exp=644648,
	relics = {
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=1},
		{name="Diamond Sword", quantity=1},
		{name="Baguette", quantity=1},
		{name="Pain Viennois", quantity=1},
		{name="Pain Brioche", quantity=1},
		{name="Fougasse", quantity=1},
		{name="Faluche", quantity=1},
		{name="BURGER", quantity=1},
		{name="Ornate Hourglass", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Mario For Pleasure", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Chicken Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Corps Captain Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Scrupulous Shield", quantity=1},
		{name="Virtue Blade", quantity=1},
		{name="Astral Ring", quantity=1},
		{name="Flawless Iluvatar ", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Indefatigable Escutcheon", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=80, [150]=99, [160]=60, [170]=82, [180]=53, [190]=42, [200]=35, [210]=27, [220]=13, [230]=2, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 104953,
	lifetime_jp = 19,
}

ECS.Players["kitkatA"] = {
	id=133808,
	division="mid",
	country="U.S.A.",
	level=72,
	exp=336711,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
	},
	tier_skill = {[120]=99, [130]=88, [140]=45, [150]=45, [160]=46, [170]=53, [180]=45, [190]=41, [200]=29, [210]=25, [220]=4, [230]=3, [240]=7, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 22806,
	lifetime_jp = 923,
}

ECS.Players["Steve_V"] = {
	id=3631,
	division="mid",
	country="Canada",
	level=82,
	exp=778667,
	relics = {
		{name="Lance of Longinus", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Godhands", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Mandau", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Vampire Killer", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Almace", quantity=1},
		{name="Excalibur", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Chicken Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Scrupulous Shield", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Indefatigable Escutcheon", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=97, [180]=72, [190]=99, [200]=20, [210]=13, [220]=3, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 21695,
	lifetime_jp = 0,
}

ECS.Players["winterfr3sh"] = {
	id=66303,
	division="mid",
	country="U.S.A.",
	level=71,
	exp=306446,
	relics = {
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=71, [130]=2, [140]=1, [150]=10, [160]=31, [170]=29, [180]=29, [190]=36, [200]=19, [210]=29, [220]=18, [230]=6, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 12778,
	lifetime_jp = 46,
}

ECS.Players["IHYD.JJK"] = {
	id=62,
	division="mid",
	country="U.S.A.",
	level=82,
	exp=735034,
	relics = {
		{name="Stone Arrow", quantity=2},
		{name="Bronze Arrow", quantity=3},
		{name="Mythril Arrow", quantity=1},
		{name="Baguette", quantity=4},
		{name="Pain Viennois", quantity=1},
		{name="Fougasse", quantity=1},
		{name="Lance of Longinus", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Godhands", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Mandau", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Vampire Killer", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Pandemonium", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Amos' Bow", quantity=1},
		{name="Yoichi Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Almace", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Mario For Pleasure", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Chicken Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Scrupulous Shield", quantity=1},
		{name="Virtue Blade", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Indefatigable Escutcheon", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=99, [190]=99, [200]=34, [210]=11, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=512, rp=0, ap=0},
	lifetime_song_gold = 51169,
	lifetime_jp = 814,
}

ECS.Players["Jboy.VictoryDance"] = {
	id=633,
	division="mid",
	country="U.S.A.",
	level=79,
	exp=613008,
	relics = {
		{name="BURGER", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Mario For Pleasure", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Corps Captain Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Scrupulous Shield", quantity=1},
		{name="Virtue Blade", quantity=1},
		{name="Astral Ring", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=94, [150]=81, [160]=54, [170]=77, [180]=45, [190]=58, [200]=32, [210]=22, [220]=6, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=383, rp=0, ap=0},
	lifetime_song_gold = 104792,
	lifetime_jp = 1076,
}

ECS.Players["ZoG-"] = {
	id=66664,
	division="mid",
	country="Finland",
	level=76,
	exp=459147,
	relics = {
		{name="Bronze Axe", quantity=1},
		{name="Silver Stopwatch", quantity=2},
		{name="Pain Viennois", quantity=1},
		{name="Fougasse", quantity=1},
		{name="Faluche", quantity=1},
		{name="Ornate Hourglass", quantity=2},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Amos' Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Chicken Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=99, [190]=77, [200]=31, [210]=14, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=432, rp=0, ap=0},
	lifetime_song_gold = 21817,
	lifetime_jp = 47,
}

ECS.Players["poog"] = {
	id=7924,
	division="mid",
	country="U.S.A.",
	level=78,
	exp=531805,
	relics = {
		{name="Stone Knife", quantity=1},
		{name="Baguette", quantity=7},
		{name="BURGER", quantity=1},
		{name="Ornate Hourglass", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Corps Captain Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
	},
	tier_skill = {[120]=99, [130]=78, [140]=77, [150]=56, [160]=48, [170]=46, [180]=49, [190]=70, [200]=38, [210]=28, [220]=14, [230]=6, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 496,
	lifetime_jp = 181,
}

ECS.Players["pie"] = {
	id=66715,
	division="mid",
	country="U.S.A.",
	level=85,
	exp=1002053,
	relics = {
		{name="BURGER", quantity=99},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Godhands", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Mandau", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Vampire Killer", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Amos' Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Chicken Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Corps Captain Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Scrupulous Shield", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Indefatigable Escutcheon", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=99, [190]=80, [200]=52, [210]=34, [220]=13, [230]=4, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 36049,
	lifetime_jp = 1057,
}

ECS.Players["aeubanks"] = {
	id=77372,
	division="mid",
	country="U.S.A.",
	level=76,
	exp=481551,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Memepeace Beret", quantity=1},
	},
	tier_skill = {[120]=99, [130]=66, [140]=40, [150]=66, [160]=48, [170]=78, [180]=66, [190]=66, [200]=41, [210]=35, [220]=11, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 14708,
	lifetime_jp = 430,
}

ECS.Players["copas"] = {
	id=172954,
	division="mid",
	country="Colombia",
	level=62,
	exp=140634,
	relics = {
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Crystal Trophy", quantity=1},
		{name="Ivory Trophy", quantity=1},
	},
	tier_skill = {[120]=71, [130]=11, [140]=4, [150]=4, [160]=7, [170]=3, [180]=8, [190]=4, [200]=3, [210]=3, [220]=2, [230]=3, [240]=1, [250]=1, [260]=1, [270]=7, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 5175,
	lifetime_jp = 20004,
}

ECS.Players["Nebel"] = {
	id=5843,
	division="mid",
	country="U.S.A.",
	level=77,
	exp=520613,
	relics = {
		{name="Stone Arrow", quantity=12},
		{name="Bronze Arrow", quantity=1},
		{name="Long Bow", quantity=1},
		{name="Pain Viennois", quantity=3},
		{name="Faluche", quantity=1},
		{name="BURGER", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Mario For Pleasure", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Scrupulous Shield", quantity=1},
		{name="Virtue Blade", quantity=1},
		{name="Memepeace Beret", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=77, [170]=92, [180]=73, [190]=48, [200]=35, [210]=29, [220]=15, [230]=8, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=150, ep=150, rp=100, ap=45},
	lifetime_song_gold = 19115,
	lifetime_jp = 2239,
}

ECS.Players["Freyja"] = {
	id=49444,
	division="mid",
	country="U.S.A.",
	level=80,
	exp=635225,
	relics = {
		{name="Bronze Arrow", quantity=5},
		{name="Long Bow", quantity=1},
		{name="Silver Stopwatch", quantity=2},
		{name="Fougasse", quantity=2},
		{name="Faluche", quantity=2},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Godhands", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Vampire Killer", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Amos' Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Almace", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Scrupulous Shield", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Indefatigable Escutcheon", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=99, [190]=99, [200]=39, [210]=6, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=484, rp=0, ap=0},
	lifetime_song_gold = 72321,
	lifetime_jp = 0,
}

ECS.Players["UMECCY"] = {
	id=128069,
	division="mid",
	country="Japan",
	level=77,
	exp=484342,
	relics = {
		{name="Baguette", quantity=1},
		{name="Pain Viennois", quantity=1},
		{name="Pain Brioche", quantity=1},
		{name="Fougasse", quantity=1},
		{name="BURGER", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Corps Captain Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=73, [150]=79, [160]=82, [170]=86, [180]=72, [190]=53, [200]=23, [210]=10, [220]=12, [230]=9, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=80, ep=40, rp=30, ap=50},
	lifetime_song_gold = 25134,
	lifetime_jp = 108,
}

ECS.Players["SirDelins"] = {
	id=127205,
	division="mid",
	country="U.S.A.",
	level=77,
	exp=483098,
	relics = {
		{name="Bronze Knife", quantity=1},
		{name="Baguette", quantity=4},
		{name="Pain Viennois", quantity=1},
		{name="BURGER", quantity=4},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Fractured Sword", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
	},
	tier_skill = {[120]=99, [130]=64, [140]=59, [150]=74, [160]=52, [170]=99, [180]=86, [190]=65, [200]=39, [210]=27, [220]=15, [230]=5, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=360, ep=30, rp=55, ap=0},
	lifetime_song_gold = 6862,
	lifetime_jp = 1013,
}

ECS.Players["Maxx-Storm"] = {
	id=935,
	division="mid",
	country="United Kingdom",
	level=67,
	exp=212494,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
	},
	tier_skill = {[120]=99, [130]=29, [140]=14, [150]=4, [160]=7, [170]=13, [180]=12, [190]=8, [200]=12, [210]=13, [220]=18, [230]=8, [240]=5, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 4085,
	lifetime_jp = 284,
}

ECS.Players["MJ12"] = {
	id=161622,
	division="mid",
	country="Unspecified",
	level=61,
	exp=129775,
	relics = {
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
	},
	tier_skill = {[120]=50, [130]=26, [140]=24, [150]=23, [160]=43, [170]=32, [180]=16, [190]=19, [200]=17, [210]=8, [220]=2, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 11649,
	lifetime_jp = 0,
}

ECS.Players[":FNF: dom no bar"] = {
	id=66762,
	division="mid",
	country="U.S.A.",
	level=76,
	exp=467732,
	relics = {
		{name="Bronze Axe", quantity=1},
		{name="Composite Bow", quantity=1},
		{name="Bronze Arrow", quantity=1},
		{name="Pain Brioche", quantity=1},
		{name="Fougasse", quantity=1},
		{name="Faluche", quantity=2},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Indefatigable Escutcheon", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=83, [190]=60, [200]=28, [210]=10, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=332, rp=0, ap=100},
	lifetime_song_gold = 23118,
	lifetime_jp = 0,
}

ECS.Players["diablos"] = {
	id=77740,
	division="mid",
	country="France",
	level=75,
	exp=430148,
	relics = {
		{name="Composite Bow", quantity=1},
		{name="Bronze Arrow", quantity=6},
		{name="Pain Brioche", quantity=1},
		{name="Faluche", quantity=2},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=92, [170]=99, [180]=94, [190]=71, [200]=20, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=199, rp=0, ap=220},
	lifetime_song_gold = 32826,
	lifetime_jp = 0,
}

ECS.Players["garichimist"] = {
	id=77575,
	division="mid",
	country="Chile",
	level=70,
	exp=280863,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=94, [140]=62, [150]=61, [160]=67, [170]=46, [180]=55, [190]=46, [200]=30, [210]=14, [220]=7, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 5482,
	lifetime_jp = 0,
}

ECS.Players["titandude21"] = {
	id=4400,
	division="mid",
	country="U.S.A.",
	level=68,
	exp=238688,
	relics = {
		{name="Stone Arrow", quantity=8},
		{name="Bronze Blade", quantity=1},
		{name="Bronze Knife", quantity=1},
		{name="Composite Bow", quantity=1},
		{name="Bronze Arrow", quantity=1},
		{name="Baguette", quantity=2},
		{name="Faluche", quantity=1},
		{name="Ornate Hourglass", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=88, [140]=59, [150]=58, [160]=51, [170]=48, [180]=73, [190]=31, [200]=18, [210]=6, [220]=3, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=337, ep=0, rp=0, ap=0},
	lifetime_song_gold = 17838,
	lifetime_jp = 0,
}

ECS.Players["ganbatte"] = {
	id=165528,
	division="mid",
	country="France",
	level=74,
	exp=379480,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=77, [160]=68, [170]=60, [180]=69, [190]=46, [200]=23, [210]=9, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 22806,
	lifetime_jp = 0,
}

ECS.Players["Hamaon"] = {
	id=127780,
	division="mid",
	country="U.S.A.",
	level=73,
	exp=346046,
	relics = {
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=6},
		{name="Silver Stopwatch", quantity=1},
		{name="Baguette", quantity=4},
		{name="Pain Viennois", quantity=3},
		{name="Pain Brioche", quantity=1},
		{name="Faluche", quantity=1},
		{name="BURGER", quantity=1},
		{name="Ornate Hourglass", quantity=2},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Godhands", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Mandau", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Vampire Killer", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=77, [190]=50, [200]=15, [210]=3, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=383, rp=0, ap=0},
	lifetime_song_gold = 4908,
	lifetime_jp = 47,
}

ECS.Players["feedbacker"] = {
	id=66677,
	division="lower",
	country="South Korea",
	level=70,
	exp=268019,
	relics = {
		{name="Damaged Zweihander", quantity=1},
		{name="Chicken Knife", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Corps Captain Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=21, [130]=19, [140]=10, [150]=15, [160]=15, [170]=28, [180]=18, [190]=14, [200]=8, [210]=7, [220]=7, [230]=3, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 4522,
	lifetime_jp = 6747,
}

ECS.Players["COLLETnm7"] = {
	id=165524,
	division="lower",
	country="Japan",
	level=77,
	exp=487461,
	relics = {
		{name="Stone Knife", quantity=1},
		{name="Stone Arrow", quantity=1},
		{name="Bronze Knife", quantity=1},
		{name="Composite Bow", quantity=1},
		{name="Mythril Blade", quantity=1},
		{name="Fougasse", quantity=1},
		{name="Ornate Hourglass", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Cracked Zanbato", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=91, [160]=92, [170]=94, [180]=65, [190]=45, [200]=31, [210]=16, [220]=10, [230]=5, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=100, ep=100, rp=100, ap=145},
	lifetime_song_gold = 88580,
	lifetime_jp = 1910,
}

ECS.Players["skateinmars"] = {
	id=66545,
	division="mid",
	country="France",
	level=74,
	exp=382297,
	relics = {
		{name="Bronze Knife", quantity=1},
		{name="Bronze Axe", quantity=1},
		{name="Pain Viennois", quantity=4},
		{name="Fougasse", quantity=1},
		{name="BURGER", quantity=1},
		{name="Ornate Hourglass", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Scrupulous Shield", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
	},
	tier_skill = {[120]=99, [130]=90, [140]=87, [150]=68, [160]=57, [170]=99, [180]=79, [190]=52, [200]=26, [210]=20, [220]=10, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=100, ep=307, rp=0, ap=0},
	lifetime_song_gold = 21873,
	lifetime_jp = 27,
}

ECS.Players["nebbii"] = {
	id=66781,
	division="lower",
	country="Netherlands",
	level=69,
	exp=263084,
	relics = {
		{name="Stone Blade", quantity=1},
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=24, [140]=41, [150]=75, [160]=86, [170]=66, [180]=67, [190]=46, [200]=13, [210]=5, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=85, rp=0, ap=100},
	lifetime_song_gold = 13549,
	lifetime_jp = 0,
}

ECS.Players["Raicarus"] = {
	id=133840,
	division="lower",
	country="Peru",
	level=59,
	exp=108714,
	relics = {
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Mythril Trophy", quantity=1},
	},
	tier_skill = {[120]=50, [130]=24, [140]=12, [150]=23, [160]=10, [170]=22, [180]=13, [190]=3, [200]=8, [210]=1, [220]=6, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 9296,
	lifetime_jp = 633,
}

ECS.Players["FranITG"] = {
	id=31669,
	division="lower",
	country="Chile",
	level=71,
	exp=307677,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Godhands", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Vampire Killer", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=65, [190]=39, [200]=10, [210]=2, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 26330,
	lifetime_jp = 0,
}

ECS.Players["Haedoken"] = {
	id=31046,
	division="lower",
	country="U.S.A.",
	level=62,
	exp=143694,
	relics = {
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=71, [130]=12, [140]=12, [150]=32, [160]=44, [170]=45, [180]=32, [190]=52, [200]=9, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3062,
	lifetime_jp = 0,
}

ECS.Players["Badjas"] = {
	id=66701,
	division="lower",
	country="Netherlands",
	level=72,
	exp=321352,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Godhands", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Mandau", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Vampire Killer", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=68, [190]=41, [200]=14, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 18676,
	lifetime_jp = 0,
}

ECS.Players["PrawnSkunk"] = {
	id=76070,
	division="mid",
	country="Canada",
	level=74,
	exp=386696,
	relics = {
		{name="Bronze Axe", quantity=1},
		{name="Baguette", quantity=1},
		{name="Pain Viennois", quantity=1},
		{name="Fougasse", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=82, [190]=68, [200]=18, [210]=2, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3635,
	lifetime_jp = 0,
}

ECS.Players["Geff"] = {
	id=66672,
	division="lower",
	country="U.S.A.",
	level=70,
	exp=277570,
	relics = {
		{name="Silver Stopwatch", quantity=1},
		{name="Ornate Hourglass", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
	},
	tier_skill = {[120]=99, [130]=78, [140]=61, [150]=35, [160]=63, [170]=72, [180]=65, [190]=54, [200]=16, [210]=8, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 36707,
	lifetime_jp = 0,
}

ECS.Players["RD"] = {
	id=35971,
	division="lower",
	country="U.S.A.",
	level=72,
	exp=343146,
	relics = {
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
	},
	tier_skill = {[120]=76, [130]=79, [140]=63, [150]=60, [160]=52, [170]=88, [180]=75, [190]=52, [200]=26, [210]=12, [220]=6, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 27252,
	lifetime_jp = 0,
}

ECS.Players["teejusb"] = {
	id=50287,
	division="lower",
	country="U.S.A.",
	level=66,
	exp=201157,
	relics = {
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=28},
		{name="Bronze Arrow", quantity=1},
		{name="Mythril Axe", quantity=1},
		{name="Baguette", quantity=6},
		{name="Fougasse", quantity=3},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mario For Pleasure", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Scrupulous Shield", quantity=1},
		{name="Virtue Blade", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=90, [140]=78, [150]=70, [160]=64, [170]=52, [180]=37, [190]=20, [200]=5, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=315, ap=0},
	lifetime_song_gold = 39782,
	lifetime_jp = 430,
}

ECS.Players["lil_beastling"] = {
	id=61211,
	division="lower",
	country="Australia",
	level=65,
	exp=178767,
	relics = {
		{name="BURGER", quantity=99},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Corps Knight Uniform", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=61, [160]=31, [170]=35, [180]=13, [190]=2, [200]=6, [210]=3, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=69, ep=69, rp=69, ap=69},
	lifetime_song_gold = 50322,
	lifetime_jp = 0,
}

ECS.Players["Soppa"] = {
	id=6239,
	division="lower",
	country="Finland",
	level=70,
	exp=284246,
	relics = {
		{name="BURGER", quantity=99},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Vampire Killer", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=83, [180]=57, [190]=41, [200]=14, [210]=3, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 13054,
	lifetime_jp = 0,
}

ECS.Players["PkGam"] = {
	id=66753,
	division="lower",
	country="U.S.A.",
	level=73,
	exp=345908,
	relics = {
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=6},
		{name="Bronze Blade", quantity=1},
		{name="Bronze Knife", quantity=1},
		{name="Bronze Axe", quantity=1},
		{name="Baguette", quantity=5},
		{name="Pain Viennois", quantity=3},
		{name="Pain Brioche", quantity=1},
		{name="BURGER", quantity=6},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=94, [190]=67, [200]=25, [210]=4, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=65, ep=150, rp=100, ap=80},
	lifetime_song_gold = 31282,
	lifetime_jp = 0,
}

ECS.Players["zero169740"] = {
	id=66759,
	division="lower",
	country="U.S.A.",
	level=70,
	exp=275790,
	relics = {
		{name="Baguette", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=59, [150]=47, [160]=50, [170]=71, [180]=72, [190]=35, [200]=17, [210]=4, [220]=3, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 28461,
	lifetime_jp = 0,
}

ECS.Players["gulu"] = {
	id=143647,
	division="lower",
	country="Japan",
	level=70,
	exp=284904,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
	},
	tier_skill = {[120]=99, [130]=77, [140]=25, [150]=59, [160]=38, [170]=71, [180]=48, [190]=34, [200]=28, [210]=18, [220]=10, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 4530,
	lifetime_jp = 27,
}

ECS.Players["DF.CaptainBlack"] = {
	id=7737,
	division="mid",
	country="U.S.A.",
	level=65,
	exp=188304,
	relics = {
		{name="Stone Arrow", quantity=4},
		{name="Bronze Arrow", quantity=1},
		{name="Mythril Axe", quantity=1},
		{name="Baguette", quantity=8},
		{name="Pain Viennois", quantity=2},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Mario For Pleasure", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Champion Belt", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
	},
	tier_skill = {[120]=99, [130]=23, [140]=19, [150]=22, [160]=24, [170]=46, [180]=27, [190]=41, [200]=12, [210]=6, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=204, rp=0, ap=100},
	lifetime_song_gold = 31670,
	lifetime_jp = 534,
}

ECS.Players["tommoda"] = {
	id=132032,
	division="mid",
	country="United Kingdom",
	level=67,
	exp=222164,
	relics = {
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=1},
		{name="Bronze Knife", quantity=1},
		{name="Bronze Arrow", quantity=1},
		{name="Baguette", quantity=2},
		{name="Pain Viennois", quantity=1},
		{name="Pain Brioche", quantity=1},
		{name="BURGER", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=59, [150]=63, [160]=55, [170]=49, [180]=65, [190]=30, [200]=19, [210]=3, [220]=3, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 4300,
	lifetime_jp = 0,
}

ECS.Players["Jerros"] = {
	id=66565,
	division="lower",
	country="Netherlands",
	level=69,
	exp=265504,
	relics = {
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=1},
		{name="Baguette", quantity=1},
		{name="Pain Viennois", quantity=1},
		{name="Pain Brioche", quantity=1},
		{name="BURGER", quantity=1},
		{name="Ornate Hourglass", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Godhands", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Mandau", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Vampire Killer", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Slime Badge", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=33, [190]=5, [200]=3, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=348, rp=0, ap=0},
	lifetime_song_gold = 22486,
	lifetime_jp = 19612,
}

ECS.Players["Fieoner"] = {
	id=66724,
	division="mid",
	country="Spain",
	level=58,
	exp=96304,
	relics = {
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Baguette", quantity=10},
		{name="Frayed Lasso", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=48, [130]=4, [140]=7, [150]=22, [160]=29, [170]=1, [180]=7, [190]=5, [200]=4, [210]=3, [220]=7, [230]=3, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=50, ep=150, rp=35, ap=1},
	lifetime_song_gold = 207,
	lifetime_jp = 0,
}

ECS.Players["hk"] = {
	id=77437,
	division="lower",
	country="Finland",
	level=63,
	exp=156726,
	relics = {
		{name="Faluche", quantity=2},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Vampire Killer", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Slime Badge", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=68, [150]=99, [160]=99, [170]=85, [180]=21, [190]=5, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=284, rp=0, ap=0},
	lifetime_song_gold = 3015,
	lifetime_jp = 0,
}

ECS.Players["aminuteawayx"] = {
	id=66674,
	division="lower",
	country="U.S.A.",
	level=68,
	exp=235583,
	relics = {
		{name="Stone Arrow", quantity=5},
		{name="Pain Viennois", quantity=6},
		{name="BURGER", quantity=99},
		{name="Ornate Hourglass", quantity=2},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Godhands", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Mandau", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=56, [190]=20, [200]=5, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=337, rp=0, ap=0},
	lifetime_song_gold = 7950,
	lifetime_jp = 0,
}

ECS.Players["Sal!"] = {
	id=8459,
	division="lower",
	country="U.S.A.",
	level=70,
	exp=281692,
	relics = {
		{name="Stone Blade", quantity=1},
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=6},
		{name="Bronze Axe", quantity=1},
		{name="Baguette", quantity=6},
		{name="Pain Viennois", quantity=3},
		{name="Faluche", quantity=1},
		{name="BURGER", quantity=12},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Slime Badge", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=72, [190]=20, [200]=5, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 28187,
	lifetime_jp = 0,
}

ECS.Players["QUICKER"] = {
	id=133806,
	division="lower",
	country="Japan",
	level=61,
	exp=123839,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=44, [140]=18, [150]=24, [160]=17, [170]=33, [180]=46, [190]=18, [200]=14, [210]=5, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 13010,
	lifetime_jp = 0,
}

ECS.Players["zarzob"] = {
	id=7886,
	division="lower",
	country="New Zealand",
	level=69,
	exp=246239,
	relics = {
		{name="Bronze Axe", quantity=1},
		{name="Pain Brioche", quantity=1},
		{name="Faluche", quantity=2},
		{name="BURGER", quantity=99},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Godhands", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Mandau", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Vampire Killer", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=83, [180]=37, [190]=8, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=243, rp=53, ap=52},
	lifetime_song_gold = 25962,
	lifetime_jp = 0,
}

ECS.Players["yutsi"] = {
	id=97270,
	division="lower",
	country="U.S.A.",
	level=54,
	exp=70889,
	relics = {
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=21, [130]=1, [140]=6, [150]=4, [160]=8, [170]=20, [180]=18, [190]=10, [200]=6, [210]=2, [220]=3, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=193, rp=0, ap=0},
	lifetime_song_gold = 120,
	lifetime_jp = 0,
}

ECS.Players["Sefirot"] = {
	id=66400,
	division="lower",
	country="Japan",
	level=60,
	exp=122364,
	relics = {
		{name="Frayed Lasso", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=71, [130]=13, [140]=8, [150]=12, [160]=25, [170]=11, [180]=34, [190]=23, [200]=12, [210]=6, [220]=4, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 18013,
	lifetime_jp = 0,
}

ECS.Players["Kev!"] = {
	id=75618,
	division="lower",
	country="U.S.A.",
	level=56,
	exp=84242,
	relics = {
		{name="Bronze Blade", quantity=1},
		{name="Bronze Arrow", quantity=1},
		{name="Pain Viennois", quantity=2},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=29, [140]=16, [150]=24, [160]=21, [170]=11, [180]=10, [190]=23, [200]=6, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 4861,
	lifetime_jp = 0,
}

ECS.Players["fidelitg"] = {
	id=66704,
	division="lower",
	country="Chile",
	level=62,
	exp=138598,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
	},
	tier_skill = {[120]=99, [130]=66, [140]=34, [150]=15, [160]=9, [170]=19, [180]=17, [190]=13, [200]=16, [210]=6, [220]=3, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 12485,
	lifetime_jp = 0,
}

ECS.Players["implode"] = {
	id=66760,
	division="lower",
	country="U.S.A.",
	level=64,
	exp=169835,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Slime Badge", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=73, [150]=66, [160]=81, [170]=72, [180]=38, [190]=15, [200]=3, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 227,
	lifetime_jp = 0,
}

ECS.Players["lolipo"] = {
	id=35701,
	division="lower",
	country="U.S.A.",
	level=62,
	exp=144825,
	relics = {
		{name="BURGER", quantity=11},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mario For Pleasure", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Scrupulous Shield", quantity=1},
		{name="Virtue Blade", quantity=1},
		{name="Memepeace Beret", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=75, [140]=48, [150]=45, [160]=27, [170]=35, [180]=36, [190]=18, [200]=8, [210]=2, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 36670,
	lifetime_jp = 430,
}

ECS.Players["PochoITG"] = {
	id=58407,
	division="lower",
	country="Chile",
	level=64,
	exp=169881,
	relics = {
		{name="BURGER", quantity=2},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=42, [140]=16, [150]=22, [160]=21, [170]=32, [180]=34, [190]=15, [200]=18, [210]=8, [220]=6, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 22162,
	lifetime_jp = 0,
}

ECS.Players["Janus5k"] = {
	id=8349,
	division="lower",
	country="U.S.A.",
	level=69,
	exp=246481,
	relics = {
		{name="Bronze Arrow", quantity=1},
		{name="Mythril Axe", quantity=1},
		{name="Silver Stopwatch", quantity=1},
		{name="Baguette", quantity=1},
		{name="Pain Viennois", quantity=1},
		{name="Pain Brioche", quantity=1},
		{name="Faluche", quantity=1},
		{name="BURGER", quantity=15},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Mario For Pleasure", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Scrupulous Shield", quantity=1},
		{name="Virtue Blade", quantity=1},
		{name="Astral Ring", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=59, [190]=26, [200]=5, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=138, rp=105, ap=105},
	lifetime_song_gold = 56702,
	lifetime_jp = 0,
}

ECS.Players["Kigha"] = {
	id=7843,
	division="lower",
	country="U.S.A.",
	level=55,
	exp=76718,
	relics = {
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=21, [130]=24, [140]=21, [150]=28, [160]=8, [170]=16, [180]=20, [190]=8, [200]=1, [210]=4, [220]=4, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 6001,
	lifetime_jp = 0,
}

ECS.Players["TadofTony"] = {
	id=146716,
	division="lower",
	country="U.S.A.",
	level=66,
	exp=192710,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=87, [140]=59, [150]=71, [160]=61, [170]=55, [180]=42, [190]=14, [200]=8, [210]=4, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 50325,
	lifetime_jp = 0,
}

ECS.Players["stormpegy"] = {
	id=127499,
	division="lower",
	country="Australia",
	level=65,
	exp=177262,
	relics = {
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=5},
		{name="Baguette", quantity=5},
		{name="Pain Brioche", quantity=2},
		{name="BURGER", quantity=99},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Flamberge", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=99, [180]=48, [190]=8, [200]=3, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=69, ep=69, rp=69, ap=69},
	lifetime_song_gold = 1936,
	lifetime_jp = 0,
}

ECS.Players["Sereni"] = {
	id=66364,
	division="lower",
	country="Russian Federation",
	level=65,
	exp=183669,
	relics = {
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=10},
		{name="Pain Viennois", quantity=3},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Faulty Blade", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=81, [150]=77, [160]=69, [170]=94, [180]=55, [190]=30, [200]=5, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=152, rp=152, ap=0},
	lifetime_song_gold = 684,
	lifetime_jp = 0,
}

ECS.Players["B3NS3X"] = {
	id=2593,
	division="lower",
	country="Canada",
	level=57,
	exp=87681,
	relics = {
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=48, [130]=10, [140]=24, [150]=20, [160]=17, [170]=20, [180]=24, [190]=9, [200]=8, [210]=2, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 32307,
	lifetime_jp = 0,
}

ECS.Players["callmisoko"] = {
	id=165835,
	division="lower",
	country="U.S.A.",
	level=65,
	exp=180382,
	relics = {
		{name="BURGER", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pendulum Blade", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=79, [150]=72, [160]=72, [170]=61, [180]=44, [190]=21, [200]=9, [210]=3, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=100, ep=54, rp=100, ap=50},
	lifetime_song_gold = 6108,
	lifetime_jp = 0,
}

ECS.Players["byron"] = {
	id=75645,
	division="lower",
	country="Australia",
	level=58,
	exp=101341,
	relics = {
		{name="Crystal Sword", quantity=1},
		{name="Baguette", quantity=2},
		{name="Pain Viennois", quantity=3},
		{name="BURGER", quantity=17},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mario For Pleasure", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Scrupulous Shield", quantity=1},
		{name="Virtue Blade", quantity=1},
		{name="Memepeace Beret", quantity=1},
	},
	tier_skill = {[120]=49, [130]=39, [140]=11, [150]=10, [160]=10, [170]=9, [180]=12, [190]=2, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=236, ap=0},
	lifetime_song_gold = 93132,
	lifetime_jp = 0,
}

ECS.Players["Zeipher_Hawk"] = {
	id=66726,
	division="lower",
	country="U.S.A.",
	level=60,
	exp=118545,
	relics = {
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=12},
		{name="Bronze Knife", quantity=1},
		{name="Baguette", quantity=9},
		{name="Pain Viennois", quantity=3},
		{name="BURGER", quantity=10},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
	},
	tier_skill = {[120]=99, [130]=50, [140]=40, [150]=35, [160]=38, [170]=13, [180]=22, [190]=5, [200]=7, [210]=3, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=50, ep=68, rp=50, ap=50},
	lifetime_song_gold = 5549,
	lifetime_jp = 97,
}

ECS.Players["Yoney"] = {
	id=6118,
	division="lower",
	country="U.S.A.",
	level=58,
	exp=96977,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=45, [140]=37, [150]=45, [160]=18, [170]=36, [180]=29, [190]=14, [200]=6, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 638,
	lifetime_jp = 0,
}

ECS.Players["nv"] = {
	id=127775,
	division="lower",
	country="Canada",
	level=53,
	exp=64256,
	relics = {
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=4},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=34, [140]=19, [150]=15, [160]=28, [170]=7, [180]=23, [190]=10, [200]=3, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 187,
	lifetime_jp = 0,
}

ECS.Players["Behy"] = {
	id=66693,
	division="lower",
	country="Netherlands",
	level=66,
	exp=193420,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Memepeace Beret", quantity=1},
	},
	tier_skill = {[120]=99, [130]=87, [140]=67, [150]=47, [160]=41, [170]=47, [180]=39, [190]=15, [200]=9, [210]=2, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 36624,
	lifetime_jp = 2374,
}

ECS.Players["mrtong96"] = {
	id=137853,
	division="lower",
	country="U.S.A.",
	level=59,
	exp=108909,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Slime Badge", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=60, [150]=48, [160]=64, [170]=53, [180]=28, [190]=5, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=218, rp=0, ap=0},
	lifetime_song_gold = 4800,
	lifetime_jp = 0,
}

ECS.Players["Paige"] = {
	id=52996,
	division="lower",
	country="U.S.A.",
	level=64,
	exp=163421,
	relics = {
		{name="Stone Arrow", quantity=7},
		{name="Composite Bow", quantity=1},
		{name="Pain Brioche", quantity=1},
		{name="Fougasse", quantity=2},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Godhands", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Mandau", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Slime Badge", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=68, [180]=29, [190]=10, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=294, ap=0},
	lifetime_song_gold = 17048,
	lifetime_jp = 0,
}

ECS.Players["Okami"] = {
	id=66509,
	division="lower",
	country="France",
	level=55,
	exp=77535,
	relics = {
		{name="Stone Arrow", quantity=24},
		{name="Composite Bow", quantity=1},
		{name="Bronze Arrow", quantity=4},
		{name="Baguette", quantity=4},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Scrupulous Shield", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=17, [140]=13, [150]=8, [160]=10, [170]=6, [180]=12, [190]=3, [200]=6, [210]=4, [220]=5, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=209, ep=0, rp=0, ap=0},
	lifetime_song_gold = 27661,
	lifetime_jp = 0,
}

ECS.Players["zQera"] = {
	id=66769,
	division="lower",
	country="Finland",
	level=64,
	exp=173340,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=88, [140]=64, [150]=53, [160]=60, [170]=47, [180]=25, [190]=15, [200]=9, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2300,
	lifetime_jp = 0,
}

ECS.Players["Uiichi"] = {
	id=66653,
	division="lower",
	country="U.S.A.",
	level=48,
	exp=39604,
	relics = {
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=49, [130]=6, [140]=10, [150]=14, [160]=15, [170]=18, [180]=22, [190]=6, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 596,
	lifetime_jp = 0,
}

ECS.Players["phnix"] = {
	id=128039,
	division="lower",
	country="U.S.A.",
	level=58,
	exp=97291,
	relics = {
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=1, [130]=61, [140]=42, [150]=16, [160]=13, [170]=37, [180]=11, [190]=6, [200]=9, [210]=3, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 23224,
	lifetime_jp = 0,
}

ECS.Players["Amoo"] = {
	id=132065,
	division="lower",
	country="U.S.A.",
	level=62,
	exp=137293,
	relics = {
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=13},
		{name="Baguette", quantity=6},
		{name="Pain Viennois", quantity=1},
		{name="Pain Brioche", quantity=3},
		{name="BURGER", quantity=4},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Mandau", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=97, [170]=57, [180]=21, [190]=5, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=274, rp=0, ap=0},
	lifetime_song_gold = 1993,
	lifetime_jp = 0,
}

ECS.Players["Platinum"] = {
	id=66215,
	division="lower",
	country="U.S.A.",
	level=56,
	exp=80430,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=42, [140]=20, [150]=14, [160]=29, [170]=36, [180]=9, [190]=7, [200]=1, [210]=3, [220]=3, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 11239,
	lifetime_jp = 0,
}

ECS.Players["OMGasm"] = {
	id=73550,
	division="lower",
	country="Australia",
	level=59,
	exp=105291,
	relics = {
		{name="BURGER", quantity=99},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=54, [140]=29, [150]=25, [160]=41, [170]=40, [180]=18, [190]=11, [200]=6, [210]=2, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 9810,
	lifetime_jp = 0,
}

ECS.Players["UK.s34n"] = {
	id=483,
	division="lower",
	country="United Kingdom",
	level=55,
	exp=78494,
	relics = {
		{name="Stone Blade", quantity=1},
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=4},
		{name="Composite Bow", quantity=1},
		{name="Bronze Arrow", quantity=3},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=27, [140]=2, [150]=11, [160]=24, [170]=20, [180]=19, [190]=12, [200]=10, [210]=2, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=177},
	lifetime_song_gold = 19075,
	lifetime_jp = 0,
}

ECS.Players["eltigrechino"] = {
	id=127794,
	division="lower",
	country="U.S.A.",
	level=56,
	exp=83101,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=44, [150]=38, [160]=50, [170]=33, [180]=19, [190]=7, [200]=3, [210]=2, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 7564,
	lifetime_jp = 0,
}

ECS.Players["mirin"] = {
	id=127939,
	division="lower",
	country="U.S.A.",
	level=50,
	exp=50039,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=26, [140]=20, [150]=18, [160]=32, [170]=16, [180]=12, [190]=4, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=20, ep=60, rp=69, ap=20},
	lifetime_song_gold = 16603,
	lifetime_jp = 0,
}

ECS.Players["Staphf"] = {
	id=66670,
	division="lower",
	country="U.S.A.",
	level=68,
	exp=234257,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
	},
	tier_skill = {[120]=99, [130]=88, [140]=54, [150]=47, [160]=21, [170]=31, [180]=21, [190]=8, [200]=4, [210]=3, [220]=4, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 8720,
	lifetime_jp = 8918,
}

ECS.Players["DRON"] = {
	id=2600,
	division="lower",
	country="U.S.A.",
	level=58,
	exp=95982,
	relics = {
		{name="BURGER", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Mario For Pleasure", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Scrupulous Shield", quantity=1},
		{name="Virtue Blade", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=49, [150]=40, [160]=42, [170]=19, [180]=12, [190]=3, [200]=6, [210]=3, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 44355,
	lifetime_jp = 0,
}

ECS.Players["Gumbygum"] = {
	id=135314,
	division="lower",
	country="U.S.A.",
	level=63,
	exp=158628,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=60, [180]=42, [190]=15, [200]=4, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 6050,
	lifetime_jp = 0,
}

ECS.Players["hollow"] = {
	id=80140,
	division="lower",
	country="U.S.A.",
	level=65,
	exp=176680,
	relics = {
		{name="Pain Viennois", quantity=2},
		{name="Pain Brioche", quantity=2},
		{name="BURGER", quantity=99},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=60, [180]=47, [190]=12, [200]=4, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=125, ep=125, rp=54, ap=0},
	lifetime_song_gold = 1240,
	lifetime_jp = 0,
}

ECS.Players["TOHNIQ"] = {
	id=170035,
	division="lower",
	country="Unspecified",
	level=63,
	exp=153866,
	relics = {
		{name="Stone Blade", quantity=1},
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=60, [180]=56, [190]=16, [200]=3, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=95, ep=94, rp=95, ap=0},
	lifetime_song_gold = 340,
	lifetime_jp = 0,
}

ECS.Players["Electromuis"] = {
	id=77168,
	division="lower",
	country="Netherlands",
	level=56,
	exp=82594,
	relics = {
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=21, [130]=29, [140]=14, [150]=21, [160]=20, [170]=21, [180]=22, [190]=11, [200]=13, [210]=4, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 252,
	lifetime_jp = 0,
}

ECS.Players["L3andr0ITG"] = {
	id=78966,
	division="lower",
	country="Chile",
	level=62,
	exp=138424,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=90, [140]=81, [150]=84, [160]=52, [170]=62, [180]=47, [190]=14, [200]=7, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 18446,
	lifetime_jp = 0,
}

ECS.Players["C-lynn"] = {
	id=66226,
	division="lower",
	country="France",
	level=66,
	exp=196061,
	relics = {
		{name="Stone Arrow", quantity=4},
		{name="Bronze Knife", quantity=1},
		{name="Bronze Axe", quantity=1},
		{name="Composite Bow", quantity=1},
		{name="Bronze Arrow", quantity=3},
		{name="Silver Stopwatch", quantity=1},
		{name="Baguette", quantity=2},
		{name="Pain Viennois", quantity=4},
		{name="Pain Brioche", quantity=2},
		{name="BURGER", quantity=16},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Mandau", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Scrupulous Shield", quantity=1},
		{name="Slime Badge", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=57, [180]=39, [190]=13, [200]=4, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 57553,
	lifetime_jp = 0,
}

ECS.Players["Fierra"] = {
	id=165792,
	division="lower",
	country="United Kingdom",
	level=54,
	exp=70432,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=14, [140]=4, [150]=11, [160]=23, [170]=25, [180]=9, [190]=7, [200]=8, [210]=2, [220]=1, [230]=2, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 6935,
	lifetime_jp = 0,
}

ECS.Players["Squeens"] = {
	id=165733,
	division="lower",
	country="U.S.A.",
	level=61,
	exp=132964,
	relics = {
		{name="Stone Blade", quantity=1},
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Bronze Blade", quantity=1},
		{name="Pain Viennois", quantity=6},
		{name="BURGER", quantity=11},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Dragon Whip", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=99, [170]=54, [180]=31, [190]=5, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 5072,
	lifetime_jp = 0,
}

ECS.Players["Exsight"] = {
	id=66729,
	division="lower",
	country="France",
	level=64,
	exp=163961,
	relics = {
		{name="Stone Arrow", quantity=1},
		{name="Bronze Blade", quantity=1},
		{name="Bronze Knife", quantity=1},
		{name="Bronze Axe", quantity=1},
		{name="Composite Bow", quantity=1},
		{name="Bronze Arrow", quantity=2},
		{name="Baguette", quantity=5},
		{name="Pain Viennois", quantity=2},
		{name="Pain Brioche", quantity=1},
		{name="BURGER", quantity=15},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=78, [150]=86, [160]=52, [170]=59, [180]=37, [190]=16, [200]=7, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=54, ep=120, rp=0, ap=120},
	lifetime_song_gold = 53670,
	lifetime_jp = 0,
}

ECS.Players["DanPeriod"] = {
	id=256,
	division="lower",
	country="U.S.A.",
	level=63,
	exp=155632,
	relics = {
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=10},
		{name="Bronze Blade", quantity=1},
		{name="Silver Stopwatch", quantity=1},
		{name="Pain Viennois", quantity=9},
		{name="Pain Brioche", quantity=1},
		{name="BURGER", quantity=4},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Slime Badge", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=92, [170]=49, [180]=32, [190]=10, [200]=3, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=64, rp=200, ap=20},
	lifetime_song_gold = 21694,
	lifetime_jp = 0,
}

ECS.Players["Cozy"] = {
	id=73458,
	division="lower",
	country="U.S.A.",
	level=57,
	exp=87705,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=66, [140]=52, [150]=34, [160]=26, [170]=32, [180]=23, [190]=2, [200]=8, [210]=2, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 6724,
	lifetime_jp = 0,
}

ECS.Players["BenouKat"] = {
	id=66710,
	division="lower",
	country="France",
	level=63,
	exp=160128,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=83, [160]=56, [170]=63, [180]=36, [190]=14, [200]=5, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 11857,
	lifetime_jp = 0,
}

ECS.Players["LOLWUT"] = {
	id=145083,
	division="lower",
	country="U.S.A.",
	level=47,
	exp=37849,
	relics = {
		{name="Mom's Knife", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=50, [130]=2, [140]=1, [150]=1, [160]=4, [170]=19, [180]=11, [190]=6, [200]=6, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 621,
	lifetime_jp = 0,
}

ECS.Players["FabSab44"] = {
	id=66610,
	division="lower",
	country="Canada",
	level=61,
	exp=123848,
	relics = {
		{name="Stone Arrow", quantity=1},
		{name="Baguette", quantity=1},
		{name="Pain Viennois", quantity=2},
		{name="BURGER", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Splintered Bow", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
	},
	tier_skill = {[120]=99, [130]=71, [140]=61, [150]=86, [160]=86, [170]=54, [180]=33, [190]=9, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1606,
	lifetime_jp = 0,
}

ECS.Players["nabulator"] = {
	id=103169,
	division="lower",
	country="U.S.A.",
	level=57,
	exp=92874,
	relics = {
		{name="Short Bow", quantity=1},
		{name="BURGER", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=73, [150]=63, [160]=42, [170]=42, [180]=14, [190]=3, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=227, ap=0},
	lifetime_song_gold = 8371,
	lifetime_jp = 0,
}

ECS.Players["RAN.S"] = {
	id=113250,
	division="lower",
	country="Japan",
	level=57,
	exp=92538,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=61, [140]=44, [150]=48, [160]=37, [170]=35, [180]=25, [190]=10, [200]=6, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 11076,
	lifetime_jp = 0,
}

ECS.Players["gomana2"] = {
	id=128620,
	division="lower",
	country="Japan",
	level=49,
	exp=44104,
	relics = {
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Baguette", quantity=1},
		{name="BURGER", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=78, [130]=5, [140]=4, [150]=21, [160]=22, [170]=20, [180]=17, [190]=7, [200]=4, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 749,
	lifetime_jp = 0,
}

ECS.Players["dj Maki"] = {
	id=66793,
	division="lower",
	country="U.S.A.",
	level=53,
	exp=64272,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="Memepeace Beret", quantity=1},
	},
	tier_skill = {[120]=99, [130]=34, [140]=13, [150]=8, [160]=7, [170]=25, [180]=11, [190]=8, [200]=4, [210]=3, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=7, ep=7, rp=7, ap=7},
	lifetime_song_gold = 450,
	lifetime_jp = 0,
}

ECS.Players["Valex"] = {
	id=37977,
	division="lower",
	country="U.S.A.",
	level=57,
	exp=87634,
	relics = {
		{name="Stone Arrow", quantity=7},
		{name="Composite Bow", quantity=1},
		{name="Silver Stopwatch", quantity=1},
		{name="Baguette", quantity=7},
		{name="Pain Viennois", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=49, [140]=43, [150]=39, [160]=33, [170]=44, [180]=25, [190]=6, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=77, ep=75, rp=75, ap=0},
	lifetime_song_gold = 7902,
	lifetime_jp = 47,
}

ECS.Players["Zankoku"] = {
	id=66246,
	division="lower",
	country="U.S.A.",
	level=54,
	exp=67891,
	relics = {
		{name="Bronze Axe", quantity=1},
		{name="Pain Viennois", quantity=1},
		{name="Pain Brioche", quantity=1},
		{name="Faluche", quantity=1},
		{name="BURGER", quantity=59},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Godhands", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Slime Badge", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=91, [160]=33, [170]=12, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=134, rp=44, ap=23},
	lifetime_song_gold = 11201,
	lifetime_jp = 0,
}

ECS.Players["BLSTOISE"] = {
	id=7695,
	division="lower",
	country="Australia",
	level=56,
	exp=82835,
	relics = {
		{name="Stone Blade", quantity=1},
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=6},
		{name="Baguette", quantity=1},
		{name="Pain Viennois", quantity=1},
		{name="Ornate Hourglass", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
	},
	tier_skill = {[120]=99, [130]=90, [140]=75, [150]=62, [160]=62, [170]=20, [180]=6, [190]=4, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=201, rp=0, ap=17},
	lifetime_song_gold = 19928,
	lifetime_jp = 0,
}

ECS.Players["Stamina Warrior"] = {
	id=75801,
	division="lower",
	country="Finland",
	level=48,
	exp=40114,
	relics = {
		{name="Crappy Gloves", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
	},
	tier_skill = {[120]=72, [130]=22, [140]=31, [150]=30, [160]=34, [170]=34, [180]=7, [190]=2, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 901,
	lifetime_jp = 0,
}

ECS.Players["t3a"] = {
	id=163400,
	division="lower",
	country="U.S.A.",
	level=50,
	exp=47304,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=24, [140]=30, [150]=21, [160]=25, [170]=5, [180]=10, [190]=6, [200]=5, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 9336,
	lifetime_jp = 0,
}

ECS.Players["arol"] = {
	id=66427,
	division="lower",
	country="Canada",
	level=52,
	exp=57827,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=31, [140]=16, [150]=13, [160]=17, [170]=31, [180]=17, [190]=7, [200]=4, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1062,
	lifetime_jp = 0,
}

ECS.Players["Based Honk"] = {
	id=66283,
	division="lower",
	country="Canada",
	level=49,
	exp=45501,
	relics = {
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=29, [130]=11, [140]=5, [150]=1, [160]=1, [170]=22, [180]=6, [190]=2, [200]=3, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3322,
	lifetime_jp = 0,
}

ECS.Players["ddrneel"] = {
	id=129254,
	division="lower",
	country="U.S.A.",
	level=56,
	exp=79921,
	relics = {
		{name="Stone Blade", quantity=1},
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=5},
		{name="Bronze Arrow", quantity=4},
		{name="Baguette", quantity=7},
		{name="Pain Viennois", quantity=5},
		{name="BURGER", quantity=10},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
	},
	tier_skill = {[120]=99, [130]=53, [140]=36, [150]=49, [160]=21, [170]=21, [180]=14, [190]=4, [200]=3, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 9604,
	lifetime_jp = 0,
}

ECS.Players["MCXR1987"] = {
	id=66621,
	division="lower",
	country="Colombia",
	level=59,
	exp=107728,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=96, [150]=97, [160]=67, [170]=52, [180]=16, [190]=2, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 14510,
	lifetime_jp = 0,
}

ECS.Players["dimo"] = {
	id=87476,
	division="lower",
	country="U.S.A.",
	level=59,
	exp=106328,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mario For Pleasure", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Scrupulous Shield", quantity=1},
		{name="Virtue Blade", quantity=1},
		{name="Astral Ring", quantity=1},
	},
	tier_skill = {[120]=99, [130]=77, [140]=59, [150]=34, [160]=15, [170]=23, [180]=10, [190]=8, [200]=4, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 80566,
	lifetime_jp = 0,
}

ECS.Players["Rems"] = {
	id=66383,
	division="lower",
	country="France",
	level=52,
	exp=59901,
	relics = {
		{name="Bronze Blade", quantity=1},
		{name="Silver Stopwatch", quantity=1},
		{name="Baguette", quantity=3},
		{name="Pain Viennois", quantity=1},
		{name="BURGER", quantity=99},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
	},
	tier_skill = {[120]=99, [130]=58, [140]=29, [150]=40, [160]=41, [170]=20, [180]=9, [190]=3, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=185},
	lifetime_song_gold = 8511,
	lifetime_jp = 0,
}

ECS.Players["itgaz"] = {
	id=66662,
	division="lower",
	country="United Kingdom",
	level=44,
	exp=28298,
	relics = {
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=1, [130]=4, [140]=4, [150]=10, [160]=2, [170]=9, [180]=12, [190]=5, [200]=5, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1012,
	lifetime_jp = 0,
}

ECS.Players["Roujo"] = {
	id=91184,
	division="lower",
	country="Canada",
	level=55,
	exp=75523,
	relics = {
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=2},
		{name="Bronze Arrow", quantity=1},
		{name="Baguette", quantity=1},
		{name="Pain Viennois", quantity=6},
		{name="BURGER", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=66, [140]=49, [150]=41, [160]=31, [170]=32, [180]=10, [190]=4, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=209, rp=0, ap=0},
	lifetime_song_gold = 5190,
	lifetime_jp = 0,
}

ECS.Players["ITGRyan"] = {
	id=77581,
	division="lower",
	country="U.S.A.",
	level=56,
	exp=83975,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=91, [150]=58, [160]=55, [170]=22, [180]=14, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 19637,
	lifetime_jp = 0,
}

ECS.Players["jeshusha1"] = {
	id=66661,
	division="lower",
	country="Chile",
	level=53,
	exp=63453,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=80, [140]=11, [150]=36, [160]=34, [170]=24, [180]=15, [190]=3, [200]=4, [210]=2, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3407,
	lifetime_jp = 0,
}

ECS.Players["Slowest"] = {
	id=147886,
	division="lower",
	country="New Zealand",
	level=46,
	exp=34846,
	relics = {
	},
	tier_skill = {[120]=21, [130]=1, [140]=1, [150]=3, [160]=16, [170]=12, [180]=10, [190]=4, [200]=3, [210]=3, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2274,
	lifetime_jp = 0,
}

ECS.Players["Trev"] = {
	id=47060,
	division="lower",
	country="Australia",
	level=47,
	exp=38699,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=56, [140]=26, [150]=21, [160]=30, [170]=27, [180]=7, [190]=5, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3564,
	lifetime_jp = 0,
}

ECS.Players["Nato"] = {
	id=66765,
	division="lower",
	country="U.S.A.",
	level=55,
	exp=79536,
	relics = {
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Pandemonium Zero", quantity=1},
	},
	tier_skill = {[120]=72, [130]=76, [140]=81, [150]=79, [160]=43, [170]=35, [180]=13, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1605,
	lifetime_jp = 0,
}

ECS.Players["DdRDan"] = {
	id=165532,
	division="lower",
	country="U.S.A.",
	level=58,
	exp=101433,
	relics = {
		{name="Stone Blade", quantity=1},
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=1},
		{name="Baguette", quantity=1},
		{name="Pain Viennois", quantity=1},
		{name="BURGER", quantity=2},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mage Masher", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=99, [160]=61, [170]=29, [180]=15, [190]=4, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 28505,
	lifetime_jp = 0,
}

ECS.Players["_CONTROL"] = {
	id=75667,
	division="lower",
	country="Canada",
	level=53,
	exp=62290,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
	},
	tier_skill = {[120]=99, [130]=80, [140]=46, [150]=30, [160]=24, [170]=36, [180]=15, [190]=4, [200]=4, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 177,
	lifetime_jp = 0,
}

ECS.Players["Fanion"] = {
	id=66385,
	division="lower",
	country="France",
	level=51,
	exp=54274,
	relics = {
		{name="Dry-rotted Staff", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Pandemonium Zero", quantity=1},
	},
	tier_skill = {[120]=44, [130]=61, [140]=17, [150]=44, [160]=45, [170]=27, [180]=12, [190]=3, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 5589,
	lifetime_jp = 0,
}

ECS.Players["natano"] = {
	id=82526,
	division="lower",
	country="Austria",
	level=57,
	exp=92940,
	relics = {
		{name="Stone Arrow", quantity=1},
		{name="Composite Bow", quantity=1},
		{name="Bronze Arrow", quantity=1},
		{name="Baguette", quantity=1},
		{name="Pain Viennois", quantity=5},
		{name="BURGER", quantity=4},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=92, [160]=68, [170]=43, [180]=14, [190]=4, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=114, rp=0, ap=113},
	lifetime_song_gold = 6957,
	lifetime_jp = 0,
}

ECS.Players["help"] = {
	id=75729,
	division="lower",
	country="U.S.A.",
	level=56,
	exp=86846,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=91, [160]=80, [170]=39, [180]=15, [190]=4, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 571,
	lifetime_jp = 0,
}

ECS.Players["pingsn"] = {
	id=132456,
	division="lower",
	country="U.S.A.",
	level=51,
	exp=54772,
	relics = {
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
	},
	tier_skill = {[120]=55, [130]=26, [140]=15, [150]=33, [160]=39, [170]=23, [180]=18, [190]=7, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3900,
	lifetime_jp = 0,
}

ECS.Players["Franksoua"] = {
	id=6314,
	division="lower",
	country="Canada",
	level=57,
	exp=89819,
	relics = {
		{name="BURGER", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Mario For Pleasure", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="TPA Standard", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=54, [150]=42, [160]=33, [170]=28, [180]=18, [190]=6, [200]=5, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 45692,
	lifetime_jp = 430,
}

ECS.Players["flip"] = {
	id=1932,
	division="lower",
	country="U.S.A.",
	level=52,
	exp=59734,
	relics = {
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=10},
		{name="Bronze Blade", quantity=1},
		{name="Bronze Axe", quantity=1},
		{name="Pain Viennois", quantity=2},
		{name="Fougasse", quantity=1},
		{name="BURGER", quantity=99},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=62, [160]=31, [170]=13, [180]=5, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=100, rp=0, ap=85},
	lifetime_song_gold = 14528,
	lifetime_jp = 0,
}

ECS.Players["RiOdO"] = {
	id=1964,
	division="lower",
	country="U.S.A.",
	level=51,
	exp=55329,
	relics = {
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
	},
	tier_skill = {[120]=48, [130]=70, [140]=42, [150]=25, [160]=19, [170]=26, [180]=4, [190]=4, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 21038,
	lifetime_jp = 0,
}

ECS.Players["Chocol@inMatt"] = {
	id=66691,
	division="lower",
	country="France",
	level=54,
	exp=72268,
	relics = {
		{name="Stone Axe", quantity=1},
		{name="Bronze Axe", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
	},
	tier_skill = {[120]=99, [130]=94, [140]=61, [150]=62, [160]=46, [170]=33, [180]=22, [190]=5, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=50, ep=50, rp=50, ap=50},
	lifetime_song_gold = 6413,
	lifetime_jp = 0,
}

ECS.Players["XFN"] = {
	id=162522,
	division="lower",
	country="U.S.A.",
	level=57,
	exp=91001,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=92, [160]=55, [170]=37, [180]=21, [190]=8, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=51, ep=51, rp=52, ap=55},
	lifetime_song_gold = 751,
	lifetime_jp = 0,
}

ECS.Players["Senture"] = {
	id=38711,
	division="lower",
	country="United Kingdom",
	level=44,
	exp=29290,
	relics = {
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=71, [130]=33, [140]=20, [150]=22, [160]=12, [170]=4, [180]=5, [190]=1, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 10886,
	lifetime_jp = 0,
}

ECS.Players["eiboog"] = {
	id=168149,
	division="lower",
	country="U.S.A.",
	level=42,
	exp=23797,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=40, [140]=16, [150]=16, [160]=19, [170]=12, [180]=6, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2890,
	lifetime_jp = 0,
}

ECS.Players["freis16"] = {
	id=165605,
	division="lower",
	country="Unspecified",
	level=49,
	exp=43425,
	relics = {
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=76, [130]=41, [140]=20, [150]=18, [160]=18, [170]=10, [180]=7, [190]=6, [200]=3, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 7224,
	lifetime_jp = 0,
}

ECS.Players["Yam"] = {
	id=71805,
	division="lower",
	country="Australia",
	level=44,
	exp=27959,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=38, [140]=5, [150]=21, [160]=12, [170]=11, [180]=9, [190]=3, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 127,
	lifetime_jp = 0,
}

ECS.Players["VivaLaMoo"] = {
	id=4362,
	division="lower",
	country="U.S.A.",
	level=46,
	exp=34977,
	relics = {
	},
	tier_skill = {[120]=52, [130]=28, [140]=10, [150]=3, [160]=2, [170]=12, [180]=10, [190]=4, [200]=5, [210]=2, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 14552,
	lifetime_jp = 0,
}

ECS.Players[":FNF: InterstellarCirno"] = {
	id=134651,
	division="lower",
	country="U.S.A.",
	level=43,
	exp=24930,
	relics = {
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Baguette", quantity=2},
		{name="BURGER", quantity=9},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=10, [150]=28, [160]=37, [170]=7, [180]=6, [190]=3, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=50, ep=62, rp=3, ap=0},
	lifetime_song_gold = 599,
	lifetime_jp = 0,
}

ECS.Players["Made"] = {
	id=66675,
	division="lower",
	country="Chile",
	level=38,
	exp=15515,
	relics = {
		{name="Dry-rotted Staff", quantity=1},
	},
	tier_skill = {[120]=49, [130]=36, [140]=20, [150]=27, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 241,
	lifetime_jp = 0,
}

ECS.Players["Cxxxx"] = {
	id=66732,
	division="lower",
	country="U.S.A.",
	level=47,
	exp=35657,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=50, [150]=50, [160]=26, [170]=12, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3672,
	lifetime_jp = 0,
}

ECS.Players["GOK"] = {
	id=66799,
	division="lower",
	country="U.S.A.",
	level=51,
	exp=54138,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
	},
	tier_skill = {[120]=99, [130]=68, [140]=70, [150]=43, [160]=34, [170]=19, [180]=8, [190]=2, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=10, ep=10, rp=10, ap=10},
	lifetime_song_gold = 7350,
	lifetime_jp = 0,
}

ECS.Players["TommyDoesntMiss"] = {
	id=66784,
	division="lower",
	country="U.S.A.",
	level=45,
	exp=31482,
	relics = {
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
	},
	tier_skill = {[120]=49, [130]=65, [140]=44, [150]=25, [160]=21, [170]=10, [180]=3, [190]=3, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3047,
	lifetime_jp = 0,
}

ECS.Players["zxevik"] = {
	id=12,
	division="lower",
	country="U.S.A.",
	level=52,
	exp=57207,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
	},
	tier_skill = {[120]=99, [130]=37, [140]=27, [150]=9, [160]=12, [170]=20, [180]=9, [190]=5, [200]=3, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 6538,
	lifetime_jp = 0,
}

ECS.Players["McJeebie"] = {
	id=44806,
	division="lower",
	country="U.S.A.",
	level=45,
	exp=29864,
	relics = {
		{name="Mom's Knife", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=48, [130]=15, [140]=11, [150]=12, [160]=12, [170]=12, [180]=8, [190]=3, [200]=3, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 5895,
	lifetime_jp = 0,
}

ECS.Players["Robbumon"] = {
	id=73473,
	division="lower",
	country="U.S.A.",
	level=53,
	exp=63288,
	relics = {
		{name="Stone Blade", quantity=1},
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=5},
		{name="Baguette", quantity=6},
		{name="Pain Viennois", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=69, [150]=66, [160]=34, [170]=36, [180]=15, [190]=2, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=40, ep=73, rp=40, ap=40},
	lifetime_song_gold = 2564,
	lifetime_jp = 0,
}

ECS.Players["Yakid20"] = {
	id=136924,
	division="lower",
	country="U.S.A.",
	level=49,
	exp=43189,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=90, [140]=50, [150]=23, [160]=16, [170]=19, [180]=10, [190]=3, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 8804,
	lifetime_jp = 0,
}

ECS.Players["LEISHEN."] = {
	id=3610,
	division="lower",
	country="Unspecified",
	level=47,
	exp=37157,
	relics = {
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=49, [130]=17, [140]=2, [150]=13, [160]=6, [170]=8, [180]=4, [190]=1, [200]=1, [210]=2, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 18670,
	lifetime_jp = 0,
}

ECS.Players["Lugea"] = {
	id=84583,
	division="lower",
	country="Uruguay",
	level=43,
	exp=25981,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=99, [130]=37, [140]=19, [150]=15, [160]=14, [170]=15, [180]=5, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3261,
	lifetime_jp = 0,
}

ECS.Players["Staminable"] = {
	id=147926,
	division="lower",
	country="France",
	level=47,
	exp=38916,
	relics = {
		{name="Stone Blade", quantity=1},
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=15},
		{name="Pain Viennois", quantity=3},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Ehrgeiz", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=99, [150]=59, [160]=30, [170]=5, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=148, rp=0, ap=0},
	lifetime_song_gold = 844,
	lifetime_jp = 0,
}

ECS.Players["Wrenneckingball"] = {
	id=4819,
	division="lower",
	country="Finland",
	level=35,
	exp=12452,
	relics = {
	},
	tier_skill = {[120]=1, [130]=26, [140]=13, [150]=14, [160]=19, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 683,
	lifetime_jp = 0,
}

ECS.Players["Vilepickle"] = {
	id=66308,
	division="lower",
	country="U.S.A.",
	level=53,
	exp=63043,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Mario For Pleasure", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
		{name="TPA Standard", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=53, [150]=60, [160]=29, [170]=23, [180]=4, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=5, ep=22, rp=50, ap=100},
	lifetime_song_gold = 60500,
	lifetime_jp = 0,
}

ECS.Players["lfkingdom"] = {
	id=128724,
	division="lower",
	country="Unspecified",
	level=48,
	exp=41337,
	relics = {
		{name="Silver Stopwatch", quantity=1},
		{name="Pain Viennois", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=69, [140]=68, [150]=41, [160]=32, [170]=10, [180]=5, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=55, rp=0, ap=100},
	lifetime_song_gold = 9734,
	lifetime_jp = 0,
}

ECS.Players["dancingmaractus"] = {
	id=127797,
	division="lower",
	country="U.S.A.",
	level=39,
	exp=17507,
	relics = {
		{name="Stone Blade", quantity=1},
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
	},
	tier_skill = {[120]=24, [130]=11, [140]=2, [150]=3, [160]=13, [170]=10, [180]=5, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 6470,
	lifetime_jp = 0,
}

ECS.Players["Kyy"] = {
	id=66690,
	division="lower",
	country="Finland",
	level=49,
	exp=45569,
	relics = {
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=5},
		{name="Baguette", quantity=5},
		{name="Pain Viennois", quantity=1},
		{name="BURGER", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=66, [140]=52, [150]=44, [160]=22, [170]=26, [180]=11, [190]=2, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=110, ep=52, rp=0, ap=0},
	lifetime_song_gold = 7340,
	lifetime_jp = 0,
}

ECS.Players["Mango"] = {
	id=108801,
	division="lower",
	country="Canada",
	level=46,
	exp=33035,
	relics = {
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=4},
		{name="Baguette", quantity=5},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=87, [140]=50, [150]=36, [160]=35, [170]=17, [180]=1, [190]=2, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=100, rp=41, ap=0},
	lifetime_song_gold = 607,
	lifetime_jp = 0,
}

ECS.Players["ChubbyThePhat"] = {
	id=6170,
	division="lower",
	country="Canada",
	level=42,
	exp=22516,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=36, [140]=6, [150]=11, [160]=11, [170]=15, [180]=9, [190]=3, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1129,
	lifetime_jp = 0,
}

ECS.Players["chungus"] = {
	id=7688,
	division="lower",
	country="Netherlands",
	level=47,
	exp=37883,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=94, [140]=55, [150]=49, [160]=28, [170]=13, [180]=10, [190]=2, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 172,
	lifetime_jp = 0,
}

ECS.Players["hotcouch"] = {
	id=143630,
	division="lower",
	country="U.S.A.",
	level=48,
	exp=41022,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=77, [140]=41, [150]=45, [160]=27, [170]=22, [180]=6, [190]=2, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 76,
	lifetime_jp = 0,
}

ECS.Players["tororo_kelp"] = {
	id=75784,
	division="lower",
	country="Unspecified",
	level=48,
	exp=41693,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Damaged Zweihander", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=28, [140]=8, [150]=18, [160]=18, [170]=30, [180]=14, [190]=4, [200]=3, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 8474,
	lifetime_jp = 0,
}

ECS.Players["CirnoTV"] = {
	id=66557,
	division="lower",
	country="Canada",
	level=41,
	exp=21028,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=16, [140]=12, [150]=2, [160]=12, [170]=10, [180]=12, [190]=5, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 659,
	lifetime_jp = 0,
}

ECS.Players["andkaseywaslike"] = {
	id=75738,
	division="lower",
	country="U.S.A.",
	level=42,
	exp=24271,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=32, [140]=8, [150]=11, [160]=8, [170]=9, [180]=3, [190]=1, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 6894,
	lifetime_jp = 430,
}

ECS.Players["ZarinahBBM"] = {
	id=134219,
	division="lower",
	country="U.S.A.",
	level=48,
	exp=40818,
	relics = {
		{name="Stone Knife", quantity=1},
		{name="Stone Arrow", quantity=5},
		{name="Composite Bow", quantity=1},
		{name="Baguette", quantity=3},
		{name="Pain Viennois", quantity=1},
		{name="BURGER", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=91, [150]=53, [160]=34, [170]=13, [180]=5, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=75, ep=40, rp=0, ap=40},
	lifetime_song_gold = 4543,
	lifetime_jp = 0,
}

ECS.Players["taeman"] = {
	id=172969,
	division="lower",
	country="U.S.A.",
	level=39,
	exp=18388,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=79, [150]=16, [160]=6, [170]=4, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 56,
	lifetime_jp = 0,
}

ECS.Players["Gloves"] = {
	id=135481,
	division="lower",
	country="U.S.A.",
	level=45,
	exp=29580,
	relics = {
	},
	tier_skill = {[120]=29, [130]=16, [140]=13, [150]=29, [160]=2, [170]=14, [180]=6, [190]=2, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 5514,
	lifetime_jp = 0,
}

ECS.Players["JeffreyATW"] = {
	id=77862,
	division="lower",
	country="U.S.A.",
	level=43,
	exp=26095,
	relics = {
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=71, [130]=99, [140]=54, [150]=30, [160]=11, [170]=5, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 9716,
	lifetime_jp = 0,
}

ECS.Players["MoistBruh"] = {
	id=128002,
	division="lower",
	country="U.S.A.",
	level=41,
	exp=20554,
	relics = {
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=78, [130]=67, [140]=38, [150]=36, [160]=5, [170]=5, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3292,
	lifetime_jp = 0,
}

ECS.Players["gatodeplastico"] = {
	id=66666,
	division="lower",
	country="Chile",
	level=40,
	exp=19255,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=48, [130]=10, [140]=19, [150]=31, [160]=17, [170]=8, [180]=4, [190]=2, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 221,
	lifetime_jp = 0,
}

ECS.Players["EmanSaur"] = {
	id=77599,
	division="lower",
	country="Australia",
	level=39,
	exp=17559,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=59, [140]=15, [150]=11, [160]=17, [170]=7, [180]=4, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3074,
	lifetime_jp = 0,
}

ECS.Players["ChiefSkittles"] = {
	id=66673,
	division="lower",
	country="U.S.A.",
	level=34,
	exp=10329,
	relics = {
		{name="BURGER", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
	},
	tier_skill = {[120]=1, [130]=30, [140]=1, [150]=9, [160]=1, [170]=6, [180]=3, [190]=1, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2660,
	lifetime_jp = 0,
}

ECS.Players["lucdar"] = {
	id=75542,
	division="lower",
	country="U.S.A.",
	level=45,
	exp=30045,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=66, [140]=21, [150]=21, [160]=20, [170]=16, [180]=9, [190]=3, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 180,
	lifetime_jp = 0,
}

ECS.Players["Mau"] = {
	id=354,
	division="lower",
	country="U.S.A.",
	level=53,
	exp=62637,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Frayed Lasso", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
	},
	tier_skill = {[120]=99, [130]=87, [140]=74, [150]=58, [160]=29, [170]=25, [180]=10, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 15875,
	lifetime_jp = 0,
}

ECS.Players["sangyule"] = {
	id=77631,
	division="lower",
	country="U.S.A.",
	level=39,
	exp=18325,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=36, [140]=24, [150]=30, [160]=18, [170]=8, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2624,
	lifetime_jp = 0,
}

ECS.Players["GIEZ"] = {
	id=66410,
	division="lower",
	country="Japan",
	level=42,
	exp=22692,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=59, [140]=27, [150]=37, [160]=23, [170]=6, [180]=6, [190]=2, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 286,
	lifetime_jp = 0,
}

ECS.Players["TheTruck"] = {
	id=4793,
	division="lower",
	country="U.S.A.",
	level=36,
	exp=13143,
	relics = {
	},
	tier_skill = {[120]=1, [130]=6, [140]=4, [150]=1, [160]=6, [170]=15, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1479,
	lifetime_jp = 0,
}

ECS.Players["PkRynker"] = {
	id=4062,
	division="lower",
	country="U.S.A.",
	level=43,
	exp=24521,
	relics = {
	},
	tier_skill = {[120]=1, [130]=16, [140]=6, [150]=6, [160]=5, [170]=11, [180]=5, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 11405,
	lifetime_jp = 0,
}

ECS.Players["Stern"] = {
	id=66768,
	division="lower",
	country="U.S.A.",
	level=41,
	exp=21834,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=27, [130]=21, [140]=14, [150]=15, [160]=10, [170]=14, [180]=7, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 7278,
	lifetime_jp = 0,
}

ECS.Players["scientificRex"] = {
	id=127796,
	division="lower",
	country="U.S.A.",
	level=45,
	exp=30093,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=88, [150]=45, [160]=17, [170]=6, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1429,
	lifetime_jp = 0,
}

ECS.Players["Hiiro"] = {
	id=127596,
	division="lower",
	country="France",
	level=37,
	exp=15137,
	relics = {
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=6},
		{name="Baguette", quantity=8},
		{name="BURGER", quantity=8},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=48, [130]=37, [140]=19, [150]=16, [160]=10, [170]=12, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=87, rp=0, ap=0},
	lifetime_song_gold = 939,
	lifetime_jp = 0,
}

ECS.Players["ITGAlex"] = {
	id=46152,
	division="lower",
	country="U.S.A.",
	level=40,
	exp=19635,
	relics = {
		{name="Mario For Pleasure", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="TPA Standard", quantity=1},
	},
	tier_skill = {[120]=27, [130]=13, [140]=9, [150]=1, [160]=5, [170]=4, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 8737,
	lifetime_jp = 0,
}

ECS.Players["GWen"] = {
	id=163426,
	division="lower",
	country="U.S.A.",
	level=46,
	exp=34882,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=93, [140]=34, [150]=30, [160]=24, [170]=13, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2524,
	lifetime_jp = 0,
}

ECS.Players["KevinDGAF"] = {
	id=66748,
	division="lower",
	country="U.S.A.",
	level=52,
	exp=56671,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Pandemonium Zero", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=57, [150]=36, [160]=24, [170]=24, [180]=15, [190]=3, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 13542,
	lifetime_jp = 0,
}

ECS.Players["FrisoCloud"] = {
	id=66547,
	division="lower",
	country="Australia",
	level=28,
	exp=5798,
	relics = {
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=1, [130]=4, [140]=1, [150]=1, [160]=4, [170]=1, [180]=6, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 174,
	lifetime_jp = 0,
}

ECS.Players["VincentITG"] = {
	id=65671,
	division="lower",
	country="U.S.A.",
	level=39,
	exp=17479,
	relics = {
	},
	tier_skill = {[120]=29, [130]=4, [140]=2, [150]=5, [160]=3, [170]=7, [180]=5, [190]=3, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2614,
	lifetime_jp = 0,
}

ECS.Players["sumikk0"] = {
	id=139333,
	division="lower",
	country="U.S.A.",
	level=41,
	exp=20397,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=62, [140]=47, [150]=27, [160]=15, [170]=6, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3112,
	lifetime_jp = 0,
}

ECS.Players["JJJJJ"] = {
	id=75640,
	division="lower",
	country="Australia",
	level=37,
	exp=14320,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=78, [130]=23, [140]=22, [150]=28, [160]=16, [170]=5, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2712,
	lifetime_jp = 0,
}

ECS.Players["Aoba"] = {
	id=142358,
	division="lower",
	country="U.S.A.",
	level=40,
	exp=19909,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=28, [140]=33, [150]=42, [160]=20, [170]=6, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 419,
	lifetime_jp = 0,
}

ECS.Players["iGoCollege"] = {
	id=66352,
	division="lower",
	country="U.S.A.",
	level=39,
	exp=16848,
	relics = {
	},
	tier_skill = {[120]=1, [130]=6, [140]=2, [150]=5, [160]=9, [170]=11, [180]=1, [190]=2, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2480,
	lifetime_jp = 0,
}

ECS.Players["NaoHikari"] = {
	id=134767,
	division="lower",
	country="U.S.A.",
	level=44,
	exp=27869,
	relics = {
		{name="Stone Blade", quantity=1},
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Baguette", quantity=25},
		{name="BURGER", quantity=99},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=63, [150]=36, [160]=15, [170]=7, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=20, ep=35, rp=35, ap=37},
	lifetime_song_gold = 3557,
	lifetime_jp = 0,
}

ECS.Players["Navi02U"] = {
	id=129553,
	division="lower",
	country="Unspecified",
	level=42,
	exp=22300,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=10, [150]=15, [160]=20, [170]=13, [180]=5, [190]=2, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3874,
	lifetime_jp = 0,
}

ECS.Players["Powdaboi"] = {
	id=165801,
	division="lower",
	country="U.S.A.",
	level=38,
	exp=16271,
	relics = {
		{name="Baguette", quantity=1},
		{name="BURGER", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=33, [140]=23, [150]=21, [160]=11, [170]=13, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1664,
	lifetime_jp = 0,
}

ECS.Players["Lotarr"] = {
	id=66587,
	division="lower",
	country="U.S.A.",
	level=36,
	exp=12832,
	relics = {
		{name="Stone Axe", quantity=1},
		{name="BURGER", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=22, [140]=17, [150]=19, [160]=14, [170]=5, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=10, ep=42, rp=30, ap=0},
	lifetime_song_gold = 12,
	lifetime_jp = 0,
}

ECS.Players["Telperion"] = {
	id=34196,
	division="lower",
	country="U.S.A.",
	level=42,
	exp=22826,
	relics = {
		{name="BURGER", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mario For Pleasure", quantity=1},
		{name="Bronze Trophy", quantity=1},
	},
	tier_skill = {[120]=21, [130]=36, [140]=24, [150]=6, [160]=3, [170]=1, [180]=4, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=69},
	lifetime_song_gold = 10156,
	lifetime_jp = 0,
}

ECS.Players["Vagabond"] = {
	id=2910,
	division="lower",
	country="U.S.A.",
	level=43,
	exp=26009,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=48, [150]=17, [160]=11, [170]=6, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 10439,
	lifetime_jp = 0,
}

ECS.Players["SPVLABS"] = {
	id=127827,
	division="lower",
	country="Unspecified",
	level=45,
	exp=31834,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=56, [140]=53, [150]=23, [160]=18, [170]=13, [180]=5, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=7, ep=40, rp=0, ap=50},
	lifetime_song_gold = 13528,
	lifetime_jp = 0,
}

ECS.Players["Catz"] = {
	id=6791,
	division="lower",
	country="France",
	level=43,
	exp=24694,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=42, [140]=37, [150]=22, [160]=6, [170]=9, [180]=5, [190]=2, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 12357,
	lifetime_jp = 0,
}

ECS.Players["NDimensional"] = {
	id=170488,
	division="lower",
	country="U.S.A.",
	level=30,
	exp=7398,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=50, [130]=20, [140]=7, [150]=16, [160]=9, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 456,
	lifetime_jp = 0,
}

ECS.Players["dashark"] = {
	id=124751,
	division="lower",
	country="U.S.A.",
	level=42,
	exp=22842,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=82, [140]=33, [150]=38, [160]=15, [170]=7, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 537,
	lifetime_jp = 0,
}

ECS.Players["Over_Blaze"] = {
	id=172947,
	division="lower",
	country="Australia",
	level=30,
	exp=6862,
	relics = {
	},
	tier_skill = {[120]=1, [130]=1, [140]=1, [150]=1, [160]=1, [170]=3, [180]=3, [190]=1, [200]=2, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 238,
	lifetime_jp = 0,
}

ECS.Players["Drazor"] = {
	id=66775,
	division="lower",
	country="Australia",
	level=35,
	exp=11348,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=32, [140]=10, [150]=1, [160]=4, [170]=10, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1574,
	lifetime_jp = 0,
}

ECS.Players["plasmaaa"] = {
	id=78677,
	division="lower",
	country="U.S.A.",
	level=41,
	exp=20914,
	relics = {
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Baguette", quantity=9},
		{name="Pain Viennois", quantity=2},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Claustrum", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=33, [150]=36, [160]=18, [170]=6, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=103, rp=0, ap=0},
	lifetime_song_gold = 1439,
	lifetime_jp = 0,
}

ECS.Players["Razpberrie"] = {
	id=81298,
	division="lower",
	country="Netherlands",
	level=33,
	exp=9397,
	relics = {
		{name="Dry-rotted Staff", quantity=1},
	},
	tier_skill = {[120]=72, [130]=33, [140]=16, [150]=8, [160]=8, [170]=4, [180]=4, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1024,
	lifetime_jp = 0,
}

ECS.Players["ouran"] = {
	id=66757,
	division="lower",
	country="U.S.A.",
	level=37,
	exp=14134,
	relics = {
		{name="Fragile Knife", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=76, [130]=24, [140]=22, [150]=32, [160]=6, [170]=6, [180]=2, [190]=2, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1903,
	lifetime_jp = 0,
}

ECS.Players["Solus"] = {
	id=165850,
	division="lower",
	country="Unspecified",
	level=31,
	exp=7893,
	relics = {
	},
	tier_skill = {[120]=21, [130]=4, [140]=8, [150]=10, [160]=1, [170]=5, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 433,
	lifetime_jp = 0,
}

ECS.Players["Delirium89"] = {
	id=165805,
	division="lower",
	country="U.S.A.",
	level=34,
	exp=10267,
	relics = {
	},
	tier_skill = {[120]=1, [130]=12, [140]=8, [150]=4, [160]=3, [170]=12, [180]=5, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1222,
	lifetime_jp = 0,
}

ECS.Players["Lumi"] = {
	id=128187,
	division="lower",
	country="U.S.A.",
	level=44,
	exp=28592,
	relics = {
		{name="Stone Blade", quantity=1},
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Bronze Knife", quantity=1},
		{name="Baguette", quantity=1},
		{name="Pain Viennois", quantity=1},
		{name="BURGER", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=79, [150]=29, [160]=19, [170]=11, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=40, ep=40, rp=0, ap=47},
	lifetime_song_gold = 5757,
	lifetime_jp = 0,
}

ECS.Players["freyja no bar"] = {
	id=66201,
	division="lower",
	country="U.S.A.",
	level=31,
	exp=7929,
	relics = {
		{name="Stone Axe", quantity=1},
		{name="Baguette", quantity=2},
		{name="BURGER", quantity=13},
	},
	tier_skill = {[120]=1, [130]=10, [140]=5, [150]=10, [160]=7, [170]=10, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=59, rp=0, ap=0},
	lifetime_song_gold = 178,
	lifetime_jp = 0,
}

ECS.Players["5739SO-!"] = {
	id=132115,
	division="lower",
	country="Japan",
	level=32,
	exp=8660,
	relics = {
	},
	tier_skill = {[120]=72, [130]=23, [140]=12, [150]=16, [160]=2, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1083,
	lifetime_jp = 0,
}

ECS.Players["cmmf"] = {
	id=147890,
	division="lower",
	country="U.S.A.",
	level=42,
	exp=23643,
	relics = {
		{name="Stone Blade", quantity=1},
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=66, [140]=24, [150]=18, [160]=10, [170]=6, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=7, ep=8, rp=7, ap=60},
	lifetime_song_gold = 13846,
	lifetime_jp = 0,
}

ECS.Players["Jiyu"] = {
	id=66805,
	division="lower",
	country="Australia",
	level=31,
	exp=8339,
	relics = {
		{name="Dry-rotted Staff", quantity=1},
	},
	tier_skill = {[120]=44, [130]=32, [140]=8, [150]=14, [160]=5, [170]=4, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 503,
	lifetime_jp = 0,
}

ECS.Players["squatz.zexyu"] = {
	id=4681,
	division="lower",
	country="U.S.A.",
	level=43,
	exp=26595,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=90, [140]=41, [150]=29, [160]=19, [170]=11, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 6863,
	lifetime_jp = 0,
}

ECS.Players["inerzha"] = {
	id=66714,
	division="lower",
	country="U.S.A.",
	level=35,
	exp=11655,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=72, [140]=28, [150]=6, [160]=6, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2001,
	lifetime_jp = 0,
}

ECS.Players["AMBONES"] = {
	id=77316,
	division="lower",
	country="U.S.A.",
	level=38,
	exp=15815,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=50, [130]=12, [140]=12, [150]=11, [160]=13, [170]=12, [180]=4, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3645,
	lifetime_jp = 0,
}

ECS.Players["Higgy"] = {
	id=171721,
	division="lower",
	country="U.S.A.",
	level=43,
	exp=26158,
	relics = {
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=78, [130]=45, [140]=25, [150]=23, [160]=14, [170]=8, [180]=4, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 7036,
	lifetime_jp = 0,
}

ECS.Players["takumiAE86"] = {
	id=40013,
	division="lower",
	country="Colombia",
	level=29,
	exp=6145,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=27, [130]=8, [140]=3, [150]=2, [160]=3, [170]=4, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 879,
	lifetime_jp = 0,
}

ECS.Players["Rabar0209"] = {
	id=93327,
	division="lower",
	country="Japan",
	level=33,
	exp=9522,
	relics = {
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=76, [130]=54, [140]=27, [150]=10, [160]=6, [170]=3, [180]=5, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 33,
	lifetime_jp = 0,
}

ECS.Players["C-Drek"] = {
	id=165902,
	division="lower",
	country="Colombia",
	level=38,
	exp=16262,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=43, [140]=13, [150]=15, [160]=10, [170]=6, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2890,
	lifetime_jp = 0,
}

ECS.Players["ITGASS"] = {
	id=75693,
	division="lower",
	country="Netherlands",
	level=25,
	exp=3983,
	relics = {
	},
	tier_skill = {[120]=1, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=5, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["mute"] = {
	id=1232,
	division="lower",
	country="U.S.A.",
	level=38,
	exp=16564,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=61, [140]=23, [150]=10, [160]=4, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=23, ep=23, rp=23, ap=23},
	lifetime_song_gold = 13855,
	lifetime_jp = 0,
}

ECS.Players["Myleszey"] = {
	id=128502,
	division="lower",
	country="U.S.A.",
	level=39,
	exp=17762,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=77, [140]=48, [150]=25, [160]=17, [170]=8, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 911,
	lifetime_jp = 0,
}

ECS.Players["HannahPadd"] = {
	id=128390,
	division="lower",
	country="Netherlands",
	level=34,
	exp=10966,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=71, [140]=37, [150]=21, [160]=10, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 16,
	lifetime_jp = 0,
}

ECS.Players["DC"] = {
	id=75620,
	division="lower",
	country="Australia",
	level=30,
	exp=7215,
	relics = {
	},
	tier_skill = {[120]=49, [130]=16, [140]=2, [150]=12, [160]=6, [170]=6, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=20, ep=0, rp=0, ap=0},
	lifetime_song_gold = 134,
	lifetime_jp = 0,
}

ECS.Players["Unspecified "] = {
	id=66665,
	division="lower",
	country="Spain",
	level=25,
	exp=3978,
	relics = {
	},
	tier_skill = {[120]=49, [130]=10, [140]=2, [150]=3, [160]=5, [170]=1, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2,
	lifetime_jp = 0,
}

ECS.Players["BHappy"] = {
	id=76885,
	division="lower",
	country="U.S.A.",
	level=43,
	exp=25162,
	relics = {
		{name="BURGER", quantity=3},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=52, [150]=30, [160]=18, [170]=13, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3592,
	lifetime_jp = 0,
}

ECS.Players["MY BRAND"] = {
	id=129649,
	division="lower",
	country="U.S.A.",
	level=41,
	exp=20760,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Fragile Knife", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=90, [140]=48, [150]=34, [160]=18, [170]=6, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 5506,
	lifetime_jp = 0,
}

ECS.Players["REDOILY"] = {
	id=133575,
	division="lower",
	country="Japan",
	level=33,
	exp=10068,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=68, [140]=24, [150]=22, [160]=7, [170]=3, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 141,
	lifetime_jp = 0,
}

ECS.Players["San19"] = {
	id=155530,
	division="lower",
	country="Colombia",
	level=30,
	exp=7054,
	relics = {
	},
	tier_skill = {[120]=1, [130]=14, [140]=4, [150]=10, [160]=6, [170]=4, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1104,
	lifetime_jp = 0,
}

ECS.Players["barrysir"] = {
	id=66783,
	division="lower",
	country="Canada",
	level=34,
	exp=10714,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=71, [130]=23, [140]=10, [150]=6, [160]=12, [170]=7, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1623,
	lifetime_jp = 0,
}

ECS.Players["Level9Chao"] = {
	id=76182,
	division="lower",
	country="U.S.A.",
	level=32,
	exp=9011,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=47, [140]=9, [150]=2, [160]=6, [170]=3, [180]=4, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 136,
	lifetime_jp = 0,
}

ECS.Players["KAGUYA"] = {
	id=165816,
	division="lower",
	country="Japan",
	level=38,
	exp=16266,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=61, [140]=32, [150]=25, [160]=12, [170]=10, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 977,
	lifetime_jp = 0,
}

ECS.Players["Meatyguy"] = {
	id=165777,
	division="lower",
	country="U.S.A.",
	level=38,
	exp=15280,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=39, [150]=16, [160]=8, [170]=4, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 6856,
	lifetime_jp = 0,
}

ECS.Players["NinjaNabi"] = {
	id=130553,
	division="lower",
	country="U.S.A.",
	level=37,
	exp=15060,
	relics = {
		{name="Stone Blade", quantity=1},
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=1},
		{name="Baguette", quantity=3},
		{name="BURGER", quantity=7},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=29, [150]=23, [160]=4, [170]=4, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=37, rp=0, ap=50},
	lifetime_song_gold = 1421,
	lifetime_jp = 0,
}

ECS.Players["dgraham"] = {
	id=98817,
	division="lower",
	country="U.S.A.",
	level=43,
	exp=26134,
	relics = {
		{name="Bronze Blade", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=71, [130]=40, [140]=27, [150]=26, [160]=16, [170]=8, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 8735,
	lifetime_jp = 0,
}

ECS.Players["Lyricalnyu"] = {
	id=135703,
	division="lower",
	country="U.S.A.",
	level=31,
	exp=7987,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=21, [140]=10, [150]=6, [160]=6, [170]=1, [180]=5, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 574,
	lifetime_jp = 0,
}

ECS.Players["Johahn"] = {
	id=78193,
	division="lower",
	country="U.S.A.",
	level=32,
	exp=8387,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=11, [140]=8, [150]=7, [160]=3, [170]=6, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 44,
	lifetime_jp = 0,
}

ECS.Players["SleepBAAA"] = {
	id=75724,
	division="lower",
	country="Spain",
	level=35,
	exp=11628,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=71, [140]=35, [150]=16, [160]=9, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1586,
	lifetime_jp = 0,
}

ECS.Players["OverKlockD"] = {
	id=66737,
	division="lower",
	country="Australia",
	level=29,
	exp=6301,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=46, [140]=3, [150]=6, [160]=1, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 563,
	lifetime_jp = 0,
}

ECS.Players["lizzzzzy"] = {
	id=168699,
	division="lower",
	country="Peru",
	level=28,
	exp=5773,
	relics = {
	},
	tier_skill = {[120]=49, [130]=25, [140]=3, [150]=9, [160]=2, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 979,
	lifetime_jp = 0,
}

ECS.Players["FURYU"] = {
	id=75689,
	division="lower",
	country="Japan",
	level=38,
	exp=16612,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=49, [140]=24, [150]=19, [160]=10, [170]=4, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2992,
	lifetime_jp = 0,
}

ECS.Players["Dean"] = {
	id=76441,
	division="lower",
	country="Australia",
	level=37,
	exp=14061,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=75, [140]=25, [150]=19, [160]=11, [170]=7, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2811,
	lifetime_jp = 0,
}

ECS.Players["ygndiver"] = {
	id=166362,
	division="lower",
	country="Japan",
	level=29,
	exp=6737,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=27, [140]=7, [150]=13, [160]=5, [170]=3, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 617,
	lifetime_jp = 0,
}

ECS.Players["Neojock"] = {
	id=40984,
	division="lower",
	country="Canada",
	level=34,
	exp=10332,
	relics = {
	},
	tier_skill = {[120]=1, [130]=28, [140]=10, [150]=7, [160]=2, [170]=7, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2871,
	lifetime_jp = 0,
}

ECS.Players["drc84"] = {
	id=66785,
	division="lower",
	country="U.S.A.",
	level=35,
	exp=11542,
	relics = {
		{name="Dry-rotted Staff", quantity=1},
	},
	tier_skill = {[120]=49, [130]=38, [140]=25, [150]=18, [160]=6, [170]=6, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2224,
	lifetime_jp = 0,
}

ECS.Players["Rarily"] = {
	id=75846,
	division="lower",
	country="U.S.A.",
	level=32,
	exp=8953,
	relics = {
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=6},
		{name="Baguette", quantity=3},
		{name="BURGER", quantity=4},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Princess Guard", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=99, [140]=30, [150]=9, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 498,
	lifetime_jp = 0,
}

ECS.Players["MaxPainNL"] = {
	id=78598,
	division="lower",
	country="Netherlands",
	level=30,
	exp=6898,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=49, [140]=30, [150]=9, [160]=3, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 32,
	lifetime_jp = 0,
}

ECS.Players["AV6"] = {
	id=66387,
	division="lower",
	country="France",
	level=26,
	exp=4562,
	relics = {
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=50, [130]=42, [140]=7, [150]=4, [160]=3, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 451,
	lifetime_jp = 0,
}

ECS.Players["midge"] = {
	id=127783,
	division="lower",
	country="U.S.A.",
	level=24,
	exp=3665,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=27, [130]=1, [140]=1, [150]=7, [160]=6, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 52,
	lifetime_jp = 0,
}

ECS.Players["LAPIS"] = {
	id=151497,
	division="lower",
	country="Japan",
	level=39,
	exp=16826,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=38, [140]=23, [150]=13, [160]=10, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 7412,
	lifetime_jp = 0,
}

ECS.Players["Faker13"] = {
	id=280,
	division="lower",
	country="U.S.A.",
	level=42,
	exp=23578,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=59, [140]=24, [150]=18, [160]=10, [170]=7, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 16960,
	lifetime_jp = 0,
}

ECS.Players["Namidael"] = {
	id=8107,
	division="lower",
	country="France",
	level=37,
	exp=13968,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=78, [140]=39, [150]=13, [160]=3, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2441,
	lifetime_jp = 0,
}

ECS.Players["Alhe"] = {
	id=66703,
	division="lower",
	country="Finland",
	level=26,
	exp=4790,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=36, [140]=4, [150]=4, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 444,
	lifetime_jp = 0,
}

ECS.Players["ItsBrittney"] = {
	id=66749,
	division="lower",
	country="U.S.A.",
	level=28,
	exp=5616,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=36, [140]=22, [150]=9, [160]=1, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 583,
	lifetime_jp = 0,
}

ECS.Players["neyoru"] = {
	id=132471,
	division="lower",
	country="Poland",
	level=31,
	exp=8090,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=71, [130]=11, [140]=4, [150]=3, [160]=6, [170]=4, [180]=3, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=4, ep=25, rp=4, ap=25},
	lifetime_song_gold = 1326,
	lifetime_jp = 0,
}

ECS.Players["housesan"] = {
	id=165856,
	division="lower",
	country="U.S.A.",
	level=28,
	exp=5867,
	relics = {
	},
	tier_skill = {[120]=24, [130]=4, [140]=4, [150]=8, [160]=6, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 797,
	lifetime_jp = 0,
}

ECS.Players["test_account"] = {
	id=66588,
	division="lower",
	country="U.S.A.",
	level=22,
	exp=3051,
	relics = {
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=1, [130]=13, [140]=5, [150]=3, [160]=1, [170]=4, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["Quesadilla"] = {
	id=128893,
	division="lower",
	country="U.S.A.",
	level=31,
	exp=7627,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=19, [140]=5, [150]=8, [160]=7, [170]=8, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 613,
	lifetime_jp = 0,
}

ECS.Players["Four"] = {
	id=165802,
	division="lower",
	country="Canada",
	level=30,
	exp=7264,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=44, [140]=23, [150]=20, [160]=8, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 30,
	lifetime_jp = 0,
}

ECS.Players["TopherK"] = {
	id=66551,
	division="lower",
	country="U.S.A.",
	level=34,
	exp=10642,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=88, [140]=26, [150]=13, [160]=3, [170]=4, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=17, rp=0, ap=30},
	lifetime_song_gold = 5435,
	lifetime_jp = 0,
}

ECS.Players["samross"] = {
	id=78188,
	division="lower",
	country="U.S.A.",
	level=38,
	exp=15785,
	relics = {
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=10},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=56, [140]=31, [150]=12, [160]=7, [170]=4, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=10, ep=10, rp=10, ap=25},
	lifetime_song_gold = 2926,
	lifetime_jp = 0,
}

ECS.Players["Shpadoinkle"] = {
	id=66778,
	division="lower",
	country="Sweden",
	level=40,
	exp=20230,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=63, [140]=21, [150]=6, [160]=3, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 6265,
	lifetime_jp = 0,
}

ECS.Players["SoupP"] = {
	id=6713,
	division="lower",
	country="U.S.A.",
	level=28,
	exp=5923,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=33, [140]=17, [150]=9, [160]=4, [170]=5, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1268,
	lifetime_jp = 0,
}

ECS.Players["Lokovodo"] = {
	id=76621,
	division="lower",
	country="U.S.A.",
	level=30,
	exp=6889,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=61, [140]=12, [150]=12, [160]=2, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 174,
	lifetime_jp = 0,
}

ECS.Players["_Temeraire"] = {
	id=165504,
	division="lower",
	country="U.S.A.",
	level=21,
	exp=2753,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=27, [130]=7, [140]=9, [150]=10, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 119,
	lifetime_jp = 0,
}

ECS.Players["ufotekkie"] = {
	id=133801,
	division="lower",
	country="U.S.A.",
	level=34,
	exp=10495,
	relics = {
		{name="Stone Blade", quantity=1},
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=1},
		{name="BURGER", quantity=8},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=66, [140]=29, [150]=13, [160]=8, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=31},
	lifetime_song_gold = 2824,
	lifetime_jp = 0,
}

ECS.Players["alecksaur"] = {
	id=66794,
	division="lower",
	country="U.S.A.",
	level=31,
	exp=7827,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=35, [140]=4, [150]=15, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 824,
	lifetime_jp = 0,
}

ECS.Players["Illuminoir"] = {
	id=163913,
	division="lower",
	country="France",
	level=27,
	exp=5173,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=87, [140]=10, [150]=6, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 209,
	lifetime_jp = 0,
}

ECS.Players["keatsta itg"] = {
	id=166769,
	division="lower",
	country="Canada",
	level=27,
	exp=5043,
	relics = {
	},
	tier_skill = {[120]=49, [130]=19, [140]=3, [150]=11, [160]=5, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 481,
	lifetime_jp = 0,
}

ECS.Players["Aldarole"] = {
	id=165884,
	division="lower",
	country="U.S.A.",
	level=30,
	exp=7473,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=66, [140]=29, [150]=11, [160]=3, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1074,
	lifetime_jp = 0,
}

ECS.Players["NUWGET"] = {
	id=66517,
	division="lower",
	country="U.S.A.",
	level=25,
	exp=4242,
	relics = {
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=2},
		{name="BURGER", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=99, [130]=48, [140]=10, [150]=6, [160]=2, [170]=1, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 135,
	lifetime_jp = 0,
}

ECS.Players["wrsw"] = {
	id=128704,
	division="lower",
	country="Canada",
	level=25,
	exp=4393,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=18, [140]=5, [150]=1, [160]=3, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2559,
	lifetime_jp = 0,
}

ECS.Players["iBBlon"] = {
	id=3761,
	division="lower",
	country="U.S.A.",
	level=41,
	exp=22048,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mario For Pleasure", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=29, [140]=16, [150]=12, [160]=4, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 6044,
	lifetime_jp = 0,
}

ECS.Players["BarX"] = {
	id=2026,
	division="lower",
	country="Australia",
	level=39,
	exp=17158,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=33, [140]=19, [150]=8, [160]=3, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1739,
	lifetime_jp = 0,
}

ECS.Players["Tingcos"] = {
	id=170780,
	division="lower",
	country="New Zealand",
	level=26,
	exp=4597,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=38, [140]=18, [150]=3, [160]=6, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 106,
	lifetime_jp = 0,
}

ECS.Players["Smalls"] = {
	id=172893,
	division="lower",
	country="U.S.A.",
	level=31,
	exp=8161,
	relics = {
		{name="Stone Blade", quantity=1},
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Crappy Gloves", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=56, [140]=29, [150]=11, [160]=7, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2658,
	lifetime_jp = 0,
}

ECS.Players["dnac10"] = {
	id=3755,
	division="lower",
	country="Unspecified",
	level=24,
	exp=3634,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=69, [140]=13, [150]=3, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 29,
	lifetime_jp = 0,
}

ECS.Players["atomcat"] = {
	id=77065,
	division="lower",
	country="Russian Federation",
	level=25,
	exp=3990,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=66, [140]=8, [150]=9, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 98,
	lifetime_jp = 0,
}

ECS.Players["AzleKayn"] = {
	id=7721,
	division="lower",
	country="U.S.A.",
	level=28,
	exp=5736,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=48, [130]=8, [140]=12, [150]=8, [160]=3, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 962,
	lifetime_jp = 0,
}

ECS.Players["Highflyer"] = {
	id=4021,
	division="lower",
	country="United Kingdom",
	level=36,
	exp=12594,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=44, [140]=9, [150]=9, [160]=4, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=18},
	lifetime_song_gold = 14326,
	lifetime_jp = 0,
}

ECS.Players["AdmiraL_ITG"] = {
	id=66682,
	division="lower",
	country="Canada",
	level=22,
	exp=3007,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=27, [130]=13, [140]=4, [150]=1, [160]=1, [170]=2, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 23,
	lifetime_jp = 0,
}

ECS.Players["Shmeagle"] = {
	id=165783,
	division="lower",
	country="U.S.A.",
	level=20,
	exp=2226,
	relics = {
	},
	tier_skill = {[120]=1, [130]=1, [140]=1, [150]=1, [160]=1, [170]=2, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 424,
	lifetime_jp = 0,
}

ECS.Players["Eesa"] = {
	id=147676,
	division="lower",
	country="U.S.A.",
	level=34,
	exp=10631,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=49, [140]=18, [150]=15, [160]=3, [170]=4, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 7736,
	lifetime_jp = 0,
}

ECS.Players["Halogen-"] = {
	id=5362,
	division="lower",
	country="U.S.A.",
	level=26,
	exp=4892,
	relics = {
	},
	tier_skill = {[120]=21, [130]=22, [140]=11, [150]=2, [160]=4, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 313,
	lifetime_jp = 0,
}

ECS.Players["Furystomper"] = {
	id=165795,
	division="lower",
	country="Italy",
	level=25,
	exp=4188,
	relics = {
		{name="Dry-rotted Staff", quantity=1},
	},
	tier_skill = {[120]=72, [130]=39, [140]=17, [150]=10, [160]=3, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 35,
	lifetime_jp = 0,
}

ECS.Players["ICTtoken"] = {
	id=6502,
	division="lower",
	country="U.S.A.",
	level=21,
	exp=2605,
	relics = {
	},
	tier_skill = {[120]=1, [130]=7, [140]=1, [150]=1, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1,
	lifetime_jp = 0,
}

ECS.Players["Megamansito"] = {
	id=167704,
	division="lower",
	country="U.S.A.",
	level=38,
	exp=15550,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=48, [140]=15, [150]=10, [160]=5, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2242,
	lifetime_jp = 0,
}

ECS.Players["NAT8"] = {
	id=163902,
	division="lower",
	country="Canada",
	level=33,
	exp=9857,
	relics = {
	},
	tier_skill = {[120]=21, [130]=11, [140]=2, [150]=1, [160]=4, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1862,
	lifetime_jp = 0,
}

ECS.Players["CLINTBEASTWOOD"] = {
	id=1087,
	division="lower",
	country="U.S.A.",
	level=34,
	exp=10881,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=27, [130]=15, [140]=4, [150]=2, [160]=1, [170]=2, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2631,
	lifetime_jp = 0,
}

ECS.Players["LaplaceFox"] = {
	id=128847,
	division="lower",
	country="U.S.A.",
	level=29,
	exp=6503,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=23, [140]=12, [150]=2, [160]=3, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=10},
	lifetime_song_gold = 7960,
	lifetime_jp = 0,
}

ECS.Players["Maniacal"] = {
	id=1432,
	division="lower",
	country="U.S.A.",
	level=30,
	exp=6951,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=36, [140]=12, [150]=4, [160]=1, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1006,
	lifetime_jp = 0,
}

ECS.Players["kai_yuki"] = {
	id=165758,
	division="lower",
	country="Japan",
	level=22,
	exp=2893,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=71, [130]=4, [140]=2, [150]=1, [160]=1, [170]=1, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 371,
	lifetime_jp = 0,
}

ECS.Players["Freddyade1986"] = {
	id=165878,
	division="lower",
	country="U.S.A.",
	level=32,
	exp=8585,
	relics = {
	},
	tier_skill = {[120]=1, [130]=25, [140]=7, [150]=5, [160]=4, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1226,
	lifetime_jp = 0,
}

ECS.Players["dj505"] = {
	id=165523,
	division="lower",
	country="Canada",
	level=30,
	exp=7505,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=40, [140]=15, [150]=8, [160]=5, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1542,
	lifetime_jp = 0,
}

ECS.Players["Widget"] = {
	id=163912,
	division="lower",
	country="U.S.A.",
	level=21,
	exp=2625,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=42, [140]=13, [150]=3, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=8, rp=0, ap=0},
	lifetime_song_gold = 11,
	lifetime_jp = 0,
}

ECS.Players["mxl100"] = {
	id=136487,
	division="lower",
	country="U.S.A.",
	level=27,
	exp=5134,
	relics = {
		{name="Stone Blade", quantity=1},
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=9},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=42, [140]=11, [150]=4, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 943,
	lifetime_jp = 0,
}

ECS.Players["SpaghettiSnail"] = {
	id=129633,
	division="lower",
	country="U.S.A.",
	level=23,
	exp=3457,
	relics = {
		{name="Dry-rotted Staff", quantity=1},
	},
	tier_skill = {[120]=72, [130]=39, [140]=10, [150]=2, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 592,
	lifetime_jp = 0,
}

ECS.Players["Viper"] = {
	id=133783,
	division="lower",
	country="Italy",
	level=33,
	exp=9301,
	relics = {
		{name="Stone Blade", quantity=1},
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=59, [140]=5, [150]=2, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2126,
	lifetime_jp = 0,
}

ECS.Players["DaKree"] = {
	id=165844,
	division="lower",
	country="U.S.A.",
	level=32,
	exp=8986,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=49, [140]=18, [150]=6, [160]=4, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2793,
	lifetime_jp = 0,
}

ECS.Players["Arkitev"] = {
	id=132162,
	division="lower",
	country="Poland",
	level=23,
	exp=3427,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=35, [140]=10, [150]=6, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=10, ep=15, rp=0, ap=0},
	lifetime_song_gold = 220,
	lifetime_jp = 0,
}

ECS.Players["RazonITG"] = {
	id=128809,
	division="lower",
	country="Chile",
	level=19,
	exp=2214,
	relics = {
	},
	tier_skill = {[120]=21, [130]=3, [140]=2, [150]=1, [160]=1, [170]=3, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 246,
	lifetime_jp = 0,
}

ECS.Players["kiko"] = {
	id=2722,
	division="lower",
	country="Canada",
	level=27,
	exp=5042,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=25, [140]=7, [150]=4, [160]=1, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 557,
	lifetime_jp = 0,
}

ECS.Players["Kaede"] = {
	id=111763,
	division="lower",
	country="France",
	level=11,
	exp=667,
	relics = {
	},
	tier_skill = {[120]=1, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 56,
	lifetime_jp = 0,
}

ECS.Players["koppepan"] = {
	id=133800,
	division="lower",
	country="Japan",
	level=27,
	exp=5124,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=33, [140]=15, [150]=8, [160]=5, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1280,
	lifetime_jp = 0,
}

ECS.Players["NDGO"] = {
	id=134656,
	division="lower",
	country="U.S.A.",
	level=34,
	exp=10723,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=42, [140]=15, [150]=10, [160]=3, [170]=4, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2047,
	lifetime_jp = 0,
}

ECS.Players["WinDEU"] = {
	id=241,
	division="lower",
	country="U.S.A.",
	level=19,
	exp=2041,
	relics = {
	},
	tier_skill = {[120]=24, [130]=11, [140]=2, [150]=1, [160]=3, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1,
	lifetime_jp = 0,
}

ECS.Players["Hunter"] = {
	id=129655,
	division="lower",
	country="Canada",
	level=28,
	exp=5718,
	relics = {
		{name="BURGER", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=34, [140]=5, [150]=5, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3101,
	lifetime_jp = 0,
}

ECS.Players["Zaelyx"] = {
	id=80039,
	division="lower",
	country="U.S.A.",
	level=33,
	exp=10142,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=42, [140]=15, [150]=6, [160]=2, [170]=3, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1710,
	lifetime_jp = 0,
}

ECS.Players["JAEke"] = {
	id=128528,
	division="lower",
	country="U.S.A.",
	level=22,
	exp=2949,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=33, [140]=15, [150]=8, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 212,
	lifetime_jp = 0,
}

ECS.Players["wermi"] = {
	id=134276,
	division="lower",
	country="Poland",
	level=19,
	exp=2045,
	relics = {
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=71, [130]=30, [140]=7, [150]=6, [160]=1, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 109,
	lifetime_jp = 0,
}

ECS.Players["bibbzzu"] = {
	id=165640,
	division="lower",
	country="U.S.A.",
	level=23,
	exp=3354,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=8, [150]=8, [160]=2, [170]=4, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 718,
	lifetime_jp = 0,
}

ECS.Players["Darkstar"] = {
	id=4730,
	division="lower",
	country="U.S.A.",
	level=33,
	exp=9613,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=50, [130]=19, [140]=7, [150]=1, [160]=1, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 658,
	lifetime_jp = 0,
}

ECS.Players["migz"] = {
	id=132144,
	division="lower",
	country="Canada",
	level=16,
	exp=1481,
	relics = {
	},
	tier_skill = {[120]=1, [130]=14, [140]=6, [150]=6, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 4,
	lifetime_jp = 0,
}

ECS.Players["trescal"] = {
	id=165743,
	division="lower",
	country="U.S.A.",
	level=27,
	exp=5032,
	relics = {
		{name="Stone Blade", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=45, [140]=8, [150]=2, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 4585,
	lifetime_jp = 0,
}

ECS.Players["CAMIX"] = {
	id=169031,
	division="lower",
	country="Colombia",
	level=20,
	exp=2490,
	relics = {
	},
	tier_skill = {[120]=1, [130]=1, [140]=7, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 183,
	lifetime_jp = 0,
}

ECS.Players["Zui87"] = {
	id=165752,
	division="lower",
	country="Italy",
	level=12,
	exp=844,
	relics = {
	},
	tier_skill = {[120]=1, [130]=1, [140]=1, [150]=1, [160]=4, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 129,
	lifetime_jp = 0,
}

ECS.Players["asfod"] = {
	id=115565,
	division="lower",
	country="Italy",
	level=25,
	exp=4357,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=34, [140]=11, [150]=2, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=4, ep=8, rp=3, ap=10},
	lifetime_song_gold = 773,
	lifetime_jp = 0,
}

ECS.Players["Silver Fox"] = {
	id=124527,
	division="lower",
	country="Italy",
	level=34,
	exp=10339,
	relics = {
		{name="Stone Blade", quantity=1},
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=3},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=37, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1689,
	lifetime_jp = 0,
}

ECS.Players["hegza"] = {
	id=75719,
	division="lower",
	country="Finland",
	level=17,
	exp=1665,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=23, [140]=9, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 71,
	lifetime_jp = 0,
}

ECS.Players["trueblue410"] = {
	id=145105,
	division="lower",
	country="U.S.A.",
	level=22,
	exp=3059,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=37, [140]=8, [150]=6, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 631,
	lifetime_jp = 0,
}

ECS.Players["rootkitty"] = {
	id=77424,
	division="lower",
	country="Australia",
	level=16,
	exp=1503,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=71, [130]=6, [140]=7, [150]=1, [160]=2, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 64,
	lifetime_jp = 0,
}

ECS.Players["Hiloshi"] = {
	id=129604,
	division="lower",
	country="Japan",
	level=18,
	exp=1942,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=71, [130]=2, [140]=7, [150]=4, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 208,
	lifetime_jp = 0,
}

ECS.Players["hemaglox"] = {
	id=66386,
	division="lower",
	country="U.S.A.",
	level=17,
	exp=1730,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=28, [140]=8, [150]=4, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["lafv54"] = {
	id=155296,
	division="lower",
	country="Colombia",
	level=24,
	exp=3855,
	relics = {
		{name="Stone Blade", quantity=1},
		{name="Stone Knife", quantity=1},
		{name="Stone Axe", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Stone Arrow", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=29, [140]=5, [150]=4, [160]=3, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 768,
	lifetime_jp = 0,
}

ECS.Players["JONBUDDY"] = {
	id=127823,
	division="lower",
	country="U.S.A.",
	level=21,
	exp=2631,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=19, [140]=6, [150]=3, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 478,
	lifetime_jp = 0,
}

ECS.Players["AlMgB"] = {
	id=168219,
	division="lower",
	country="U.S.A.",
	level=18,
	exp=1781,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=33, [140]=10, [150]=2, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 10,
	lifetime_jp = 0,
}

ECS.Players["tsuccho"] = {
	id=30799,
	division="lower",
	country="Japan",
	level=27,
	exp=5102,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=71, [130]=10, [140]=3, [150]=8, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 480,
	lifetime_jp = 0,
}

ECS.Players["Mecklios"] = {
	id=169398,
	division="lower",
	country="U.S.A.",
	level=18,
	exp=1881,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=38, [140]=7, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 130,
	lifetime_jp = 0,
}

ECS.Players["DoomLord76 "] = {
	id=72331,
	division="lower",
	country="Unspecified",
	level=22,
	exp=2951,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=19, [140]=1, [150]=3, [160]=1, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 21,
	lifetime_jp = 0,
}

ECS.Players["nerdnim"] = {
	id=76196,
	division="lower",
	country="U.S.A.",
	level=15,
	exp=1228,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=76, [130]=6, [140]=2, [150]=6, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 5,
	lifetime_jp = 0,
}

ECS.Players["diamondjealousy"] = {
	id=172915,
	division="lower",
	country="U.S.A.",
	level=26,
	exp=4950,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=78, [130]=26, [140]=3, [150]=4, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 568,
	lifetime_jp = 0,
}

ECS.Players["Liam"] = {
	id=66295,
	division="lower",
	country="U.S.A.",
	level=15,
	exp=1248,
	relics = {
	},
	tier_skill = {[120]=1, [130]=1, [140]=2, [150]=1, [160]=1, [170]=1, [180]=2, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 36,
	lifetime_jp = 0,
}

ECS.Players["datsmylolipop"] = {
	id=165879,
	division="lower",
	country="U.S.A.",
	level=22,
	exp=3069,
	relics = {
		{name="Stone Blade", quantity=1},
		{name="Stone Knife", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=71, [130]=9, [140]=2, [150]=3, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 286,
	lifetime_jp = 0,
}

ECS.Players["NekoMithos"] = {
	id=55445,
	division="lower",
	country="Netherlands",
	level=17,
	exp=1703,
	relics = {
		{name="Mom's Knife", quantity=1},
		{name="Godfather's Token", quantity=1},
	},
	tier_skill = {[120]=50, [130]=13, [140]=8, [150]=5, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 145,
	lifetime_jp = 0,
}

ECS.Players["BELIAL"] = {
	id=165544,
	division="lower",
	country="Japan",
	level=21,
	exp=2752,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=17, [140]=9, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 891,
	lifetime_jp = 0,
}

ECS.Players["wrathblox"] = {
	id=165924,
	division="lower",
	country="United Kingdom",
	level=15,
	exp=1263,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=28, [140]=4, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 32,
	lifetime_jp = 0,
}

ECS.Players["inbredbearz"] = {
	id=127957,
	division="lower",
	country="U.S.A.",
	level=18,
	exp=1831,
	relics = {
	},
	tier_skill = {[120]=44, [130]=22, [140]=2, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 178,
	lifetime_jp = 0,
}

ECS.Players["Wormi"] = {
	id=76821,
	division="lower",
	country="France",
	level=11,
	exp=735,
	relics = {
	},
	tier_skill = {[120]=1, [130]=1, [140]=7, [150]=1, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 83,
	lifetime_jp = 0,
}

ECS.Players["Tybol"] = {
	id=66658,
	division="lower",
	country="U.S.A.",
	level=14,
	exp=1024,
	relics = {
	},
	tier_skill = {[120]=1, [130]=5, [140]=8, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 122,
	lifetime_jp = 0,
}

ECS.Players["TheMusserO"] = {
	id=151195,
	division="lower",
	country="Finland",
	level=15,
	exp=1309,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=37, [140]=4, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["boundaryfuss"] = {
	id=163474,
	division="lower",
	country="New Zealand",
	level=20,
	exp=2430,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=32, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 403,
	lifetime_jp = 0,
}

ECS.Players["Mason H"] = {
	id=165904,
	division="lower",
	country="U.S.A.",
	level=31,
	exp=7782,
	relics = {
	},
	tier_skill = {[120]=21, [130]=9, [140]=3, [150]=2, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 504,
	lifetime_jp = 0,
}

ECS.Players["SIM0"] = {
	id=62987,
	division="lower",
	country="U.S.A.",
	level=22,
	exp=3166,
	relics = {
	},
	tier_skill = {[120]=29, [130]=10, [140]=4, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 321,
	lifetime_jp = 0,
}

ECS.Players["Kitaru"] = {
	id=172980,
	division="lower",
	country="U.S.A.",
	level=17,
	exp=1667,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=18, [140]=8, [150]=4, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 290,
	lifetime_jp = 0,
}

ECS.Players["Lambard"] = {
	id=170725,
	division="lower",
	country="Poland",
	level=16,
	exp=1445,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=33, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 72,
	lifetime_jp = 0,
}

ECS.Players["tomnobar"] = {
	id=2517,
	division="lower",
	country="U.S.A.",
	level=14,
	exp=1147,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Dry-rotted Staff", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=33, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 84,
	lifetime_jp = 0,
}

ECS.Players["ipie4fun"] = {
	id=172888,
	division="lower",
	country="U.S.A.",
	level=15,
	exp=1314,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=29, [140]=2, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 137,
	lifetime_jp = 0,
}

ECS.Players["JEN86"] = {
	id=172953,
	division="lower",
	country="U.S.A.",
	level=26,
	exp=4879,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=17, [140]=3, [150]=5, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 510,
	lifetime_jp = 0,
}

ECS.Players["Snooze"] = {
	id=75988,
	division="lower",
	country="U.S.A.",
	level=16,
	exp=1482,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=27, [130]=5, [140]=3, [150]=1, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 109,
	lifetime_jp = 0,
}

ECS.Players["Scanline"] = {
	id=111503,
	division="lower",
	country="Canada",
	level=11,
	exp=700,
	relics = {
	},
	tier_skill = {[120]=1, [130]=1, [140]=1, [150]=4, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["TheLaxOne"] = {
	id=165804,
	division="lower",
	country="U.S.A.",
	level=21,
	exp=2545,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=17, [140]=2, [150]=1, [160]=2, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=2, ep=2, rp=2, ap=6},
	lifetime_song_gold = 4012,
	lifetime_jp = 0,
}

ECS.Players["Jai Pie"] = {
	id=165950,
	division="lower",
	country="U.S.A.",
	level=16,
	exp=1393,
	relics = {
	},
	tier_skill = {[120]=1, [130]=6, [140]=3, [150]=3, [160]=1, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 381,
	lifetime_jp = 0,
}

ECS.Players["npinsker"] = {
	id=147646,
	division="lower",
	country="U.S.A.",
	level=19,
	exp=1996,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=17, [140]=5, [150]=3, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=8, rp=0, ap=0},
	lifetime_song_gold = 476,
	lifetime_jp = 0,
}

ECS.Players["Dsongi"] = {
	id=146707,
	division="lower",
	country="Chile",
	level=21,
	exp=2533,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=23, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 456,
	lifetime_jp = 0,
}

ECS.Players["itg_Kage"] = {
	id=144942,
	division="lower",
	country="United Kingdom",
	level=25,
	exp=4286,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=27, [130]=15, [140]=3, [150]=1, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 401,
	lifetime_jp = 0,
}

ECS.Players["Kerpa"] = {
	id=128363,
	division="lower",
	country="U.S.A.",
	level=20,
	exp=2354,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=76, [130]=18, [140]=4, [150]=1, [160]=3, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2524,
	lifetime_jp = 0,
}

ECS.Players["Stefe"] = {
	id=80607,
	division="lower",
	country="Poland",
	level=12,
	exp=748,
	relics = {
	},
	tier_skill = {[120]=1, [130]=1, [140]=1, [150]=1, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["DJPandaga"] = {
	id=134541,
	division="lower",
	country="U.S.A.",
	level=13,
	exp=954,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=23, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=2, ep=2, rp=1, ap=1},
	lifetime_song_gold = 63,
	lifetime_jp = 0,
}

ECS.Players["asellus"] = {
	id=127865,
	division="lower",
	country="South Korea",
	level=27,
	exp=5100,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=13, [140]=4, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 397,
	lifetime_jp = 0,
}

ECS.Players["Dr.T"] = {
	id=165766,
	division="lower",
	country="Australia",
	level=13,
	exp=879,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=18, [140]=4, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 13,
	lifetime_jp = 0,
}

ECS.Players["1ug1a"] = {
	id=76988,
	division="lower",
	country="U.S.A.",
	level=20,
	exp=2504,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=23, [140]=4, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 572,
	lifetime_jp = 0,
}

ECS.Players["GreatDameCygnus"] = {
	id=128280,
	division="lower",
	country="U.S.A.",
	level=27,
	exp=4965,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=13, [140]=8, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 510,
	lifetime_jp = 0,
}

ECS.Players["C4L3BT"] = {
	id=166814,
	division="lower",
	country="New Zealand",
	level=18,
	exp=1770,
	relics = {
		{name="Stone Blade", quantity=1},
		{name="Short Bow", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=76, [130]=15, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=2, ep=2, rp=2, ap=4},
	lifetime_song_gold = 1179,
	lifetime_jp = 0,
}

ECS.Players["dekw"] = {
	id=165653,
	division="lower",
	country="Canada",
	level=17,
	exp=1659,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=10, [140]=2, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3143,
	lifetime_jp = 0,
}

ECS.Players["Tiny"] = {
	id=165787,
	division="lower",
	country="Australia",
	level=11,
	exp=639,
	relics = {
	},
	tier_skill = {[120]=72, [130]=15, [140]=4, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1,
	lifetime_jp = 0,
}

ECS.Players["Loak"] = {
	id=44927,
	division="lower",
	country="U.S.A.",
	level=11,
	exp=733,
	relics = {
	},
	tier_skill = {[120]=24, [130]=6, [140]=2, [150]=1, [160]=3, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 103,
	lifetime_jp = 0,
}

ECS.Players["beeabay"] = {
	id=66777,
	division="lower",
	country="Finland",
	level=13,
	exp=933,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=21, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 86,
	lifetime_jp = 0,
}

ECS.Players["SETX J$Richie"] = {
	id=165852,
	division="lower",
	country="U.S.A.",
	level=17,
	exp=1691,
	relics = {
		{name="Stone Axe", quantity=1},
	},
	tier_skill = {[120]=72, [130]=14, [140]=1, [150]=2, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 116,
	lifetime_jp = 0,
}

ECS.Players["senstin1"] = {
	id=135450,
	division="lower",
	country="U.S.A.",
	level=9,
	exp=522,
	relics = {
	},
	tier_skill = {[120]=21, [130]=10, [140]=4, [150]=1, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["McYTG"] = {
	id=165897,
	division="lower",
	country="Unspecified",
	level=16,
	exp=1403,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=71, [130]=7, [140]=4, [150]=1, [160]=2, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 285,
	lifetime_jp = 0,
}

ECS.Players["kaosddr"] = {
	id=134350,
	division="lower",
	country="U.S.A.",
	level=20,
	exp=2299,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=18, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 280,
	lifetime_jp = 0,
}

ECS.Players["cloverwolf"] = {
	id=165784,
	division="lower",
	country="U.S.A.",
	level=12,
	exp=741,
	relics = {
	},
	tier_skill = {[120]=72, [130]=15, [140]=4, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 46,
	lifetime_jp = 0,
}

ECS.Players["Kitsou"] = {
	id=66719,
	division="lower",
	country="France",
	level=16,
	exp=1486,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=8, [140]=2, [150]=4, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 131,
	lifetime_jp = 0,
}

ECS.Players["acriter"] = {
	id=7609,
	division="lower",
	country="U.S.A.",
	level=8,
	exp=417,
	relics = {
	},
	tier_skill = {[120]=21, [130]=6, [140]=1, [150]=2, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1,
	lifetime_jp = 0,
}

ECS.Players["Snil4"] = {
	id=94283,
	division="lower",
	country="Unspecified",
	level=11,
	exp=674,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=7, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=1, ep=2, rp=2, ap=1},
	lifetime_song_gold = 93,
	lifetime_jp = 0,
}

ECS.Players["Trie"] = {
	id=165541,
	division="lower",
	country="U.S.A.",
	level=16,
	exp=1351,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=71, [130]=12, [140]=2, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 188,
	lifetime_jp = 0,
}

ECS.Players["ArsNova"] = {
	id=165529,
	division="lower",
	country="U.S.A.",
	level=12,
	exp=854,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=13, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 238,
	lifetime_jp = 0,
}

ECS.Players["SLiguykyle"] = {
	id=168795,
	division="lower",
	country="U.S.A.",
	level=10,
	exp=562,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=13, [140]=4, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 28,
	lifetime_jp = 0,
}

ECS.Players["MrMeatloaf"] = {
	id=5314,
	division="lower",
	country="U.S.A.",
	level=25,
	exp=4283,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=55, [130]=5, [140]=4, [150]=3, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 352,
	lifetime_jp = 0,
}

ECS.Players["ImAManOfMy"] = {
	id=166489,
	division="lower",
	country="U.S.A.",
	level=9,
	exp=523,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=13, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 21,
	lifetime_jp = 0,
}

ECS.Players["azirixx"] = {
	id=163331,
	division="lower",
	country="U.S.A.",
	level=17,
	exp=1638,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=5, [150]=2, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 229,
	lifetime_jp = 0,
}

ECS.Players["PinkDad"] = {
	id=2380,
	division="lower",
	country="U.S.A.",
	level=25,
	exp=4252,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=4, [140]=4, [150]=1, [160]=1, [170]=2, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=37},
	lifetime_song_gold = 1135,
	lifetime_jp = 0,
}

ECS.Players["ruunix2"] = {
	id=170859,
	division="lower",
	country="U.S.A.",
	level=19,
	exp=2107,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=4, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2922,
	lifetime_jp = 0,
}

ECS.Players["catcraze777"] = {
	id=170934,
	division="lower",
	country="U.S.A.",
	level=9,
	exp=482,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=13, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 10,
	lifetime_jp = 0,
}

ECS.Players["defekTiVE"] = {
	id=94191,
	division="lower",
	country="U.S.A.",
	level=10,
	exp=582,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=71, [130]=6, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 37,
	lifetime_jp = 0,
}

ECS.Players["Cecilia"] = {
	id=78050,
	division="lower",
	country="Japan",
	level=16,
	exp=1330,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=11, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 166,
	lifetime_jp = 0,
}

ECS.Players["Shane_ITG"] = {
	id=165514,
	division="lower",
	country="United Kingdom",
	level=25,
	exp=4002,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=27, [130]=9, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 211,
	lifetime_jp = 0,
}

ECS.Players["Horsey"] = {
	id=66508,
	division="lower",
	country="U.S.A.",
	level=24,
	exp=3918,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=7, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 185,
	lifetime_jp = 0,
}

ECS.Players["Friday4Robbie"] = {
	id=132794,
	division="lower",
	country="Mexico",
	level=19,
	exp=2061,
	relics = {
	},
	tier_skill = {[120]=1, [130]=10, [140]=2, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 134,
	lifetime_jp = 0,
}

ECS.Players["Faythae"] = {
	id=165756,
	division="lower",
	country="Canada",
	level=8,
	exp=405,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=7, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3,
	lifetime_jp = 0,
}

ECS.Players["Gerbil"] = {
	id=168972,
	division="lower",
	country="U.S.A.",
	level=6,
	exp=252,
	relics = {
	},
	tier_skill = {[120]=24, [130]=6, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["RAKKII-san"] = {
	id=127813,
	division="lower",
	country="U.S.A.",
	level=13,
	exp=925,
	relics = {
	},
	tier_skill = {[120]=1, [130]=10, [140]=2, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 178,
	lifetime_jp = 0,
}

ECS.Players["babyalan"] = {
	id=128004,
	division="lower",
	country="U.S.A.",
	level=25,
	exp=4039,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 213,
	lifetime_jp = 0,
}

ECS.Players["Thumbsy"] = {
	id=131549,
	division="lower",
	country="Netherlands",
	level=12,
	exp=809,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=4, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 145,
	lifetime_jp = 0,
}

ECS.Players["bicycle_man"] = {
	id=166848,
	division="lower",
	country="Japan",
	level=17,
	exp=1710,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=8, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 227,
	lifetime_jp = 0,
}

ECS.Players["PARTY MAN X"] = {
	id=168599,
	division="lower",
	country="U.S.A.",
	level=19,
	exp=2021,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 261,
	lifetime_jp = 0,
}

ECS.Players["bluechows"] = {
	id=79,
	division="lower",
	country="U.S.A.",
	level=28,
	exp=6039,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 306,
	lifetime_jp = 0,
}

ECS.Players["Sbuxsurg"] = {
	id=135709,
	division="lower",
	country="U.S.A.",
	level=15,
	exp=1281,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=12, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 153,
	lifetime_jp = 0,
}

ECS.Players["antec"] = {
	id=75621,
	division="lower",
	country="Australia",
	level=7,
	exp=321,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=2, [140]=4, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3,
	lifetime_jp = 0,
}

ECS.Players["MissFitITG"] = {
	id=148301,
	division="lower",
	country="U.S.A.",
	level=7,
	exp=328,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=8, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 24,
	lifetime_jp = 0,
}

ECS.Players["Corrie Divitt"] = {
	id=2651,
	division="lower",
	country="Canada",
	level=10,
	exp=551,
	relics = {
		{name="Stone Axe", quantity=1},
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=8, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=1, rp=0, ap=2},
	lifetime_song_gold = 254,
	lifetime_jp = 0,
}

ECS.Players["CpawsMusic"] = {
	id=172889,
	division="lower",
	country="U.S.A.",
	level=7,
	exp=328,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=8, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["Luna9729"] = {
	id=165778,
	division="lower",
	country="Unspecified",
	level=18,
	exp=1917,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=71, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 146,
	lifetime_jp = 0,
}

ECS.Players["Boingloing"] = {
	id=66376,
	division="lower",
	country="U.S.A.",
	level=11,
	exp=659,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=2, [140]=5, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 102,
	lifetime_jp = 0,
}

ECS.Players["BreakfastPM"] = {
	id=168067,
	division="lower",
	country="U.S.A.",
	level=8,
	exp=426,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=71, [130]=8, [140]=2, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 57,
	lifetime_jp = 0,
}

ECS.Players["Calwyn"] = {
	id=172918,
	division="lower",
	country="United Kingdom",
	level=10,
	exp=626,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=4, [140]=2, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 94,
	lifetime_jp = 0,
}

ECS.Players["ClenonWolf"] = {
	id=133033,
	division="lower",
	country="Germany",
	level=6,
	exp=225,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=48, [130]=4, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 5,
	lifetime_jp = 0,
}

ECS.Players["Samuelio"] = {
	id=132030,
	division="lower",
	country="U.S.A.",
	level=8,
	exp=388,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=71, [130]=8, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 42,
	lifetime_jp = 0,
}

ECS.Players["Fake Flake"] = {
	id=172970,
	division="lower",
	country="U.S.A.",
	level=5,
	exp=221,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=4, [140]=2, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["kapu"] = {
	id=165522,
	division="lower",
	country="Finland",
	level=5,
	exp=199,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=4, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["bandit"] = {
	id=163403,
	division="lower",
	country="U.S.A.",
	level=5,
	exp=199,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=4, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["NekoSteps"] = {
	id=165928,
	division="lower",
	country="Australia",
	level=8,
	exp=374,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=4, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 62,
	lifetime_jp = 0,
}

ECS.Players["meowtastic"] = {
	id=66641,
	division="lower",
	country="U.S.A.",
	level=5,
	exp=198,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=71, [130]=5, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3,
	lifetime_jp = 0,
}

ECS.Players["INEJ"] = {
	id=169152,
	division="lower",
	country="U.S.A.",
	level=5,
	exp=199,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=4, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 21,
	lifetime_jp = 0,
}

ECS.Players["asterism0"] = {
	id=171459,
	division="lower",
	country="U.S.A.",
	level=5,
	exp=199,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=4, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["Keaize"] = {
	id=66660,
	division="lower",
	country="U.S.A.",
	level=14,
	exp=1046,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=71, [130]=4, [140]=2, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 149,
	lifetime_jp = 0,
}

ECS.Players["Pluto-chan"] = {
	id=66394,
	division="lower",
	country="Russian Federation",
	level=4,
	exp=164,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=50, [130]=4, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 19,
	lifetime_jp = 0,
}

ECS.Players["vht"] = {
	id=76891,
	division="lower",
	country="U.S.A.",
	level=4,
	exp=136,
	relics = {
	},
	tier_skill = {[120]=72, [130]=4, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["Coneja"] = {
	id=128890,
	division="lower",
	country="Chile",
	level=13,
	exp=870,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=2, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 79,
	lifetime_jp = 0,
}

ECS.Players["WAY2021"] = {
	id=150658,
	division="lower",
	country="Canada",
	level=27,
	exp=5325,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=55, [130]=1, [140]=2, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 72,
	lifetime_jp = 0,
}

ECS.Players["Neifion"] = {
	id=161585,
	division="lower",
	country="U.S.A.",
	level=7,
	exp=338,
	relics = {
	},
	tier_skill = {[120]=44, [130]=4, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 32,
	lifetime_jp = 0,
}

ECS.Players["Yokamaa"] = {
	id=170806,
	division="lower",
	country="U.S.A.",
	level=5,
	exp=184,
	relics = {
		{name="Spiral Heart Moon Rod", quantity=1},
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=99, [130]=2, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1,
	lifetime_jp = 0,
}

ECS.Players["kinshippjamm"] = {
	id=165723,
	division="lower",
	country="U.S.A.",
	level=12,
	exp=831,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=78, [130]=2, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 91,
	lifetime_jp = 0,
}

ECS.Players["PaddyCo"] = {
	id=145064,
	division="lower",
	country="Sweden",
	level=4,
	exp=121,
	relics = {
	},
	tier_skill = {[120]=72, [130]=2, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["Accioskullar"] = {
	id=75805,
	division="lower",
	country="U.S.A.",
	level=12,
	exp=830,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=78, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 50,
	lifetime_jp = 0,
}

ECS.Players["Tidek"] = {
	id=163899,
	division="lower",
	country="Poland",
	level=12,
	exp=828,
	relics = {
	},
	tier_skill = {[120]=44, [130]=1, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 66,
	lifetime_jp = 0,
}

ECS.Players["typobox"] = {
	id=3203,
	division="lower",
	country="U.S.A.",
	level=12,
	exp=802,
	relics = {
	},
	tier_skill = {[120]=24, [130]=2, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 107,
	lifetime_jp = 0,
}

ECS.Players["jenx"] = {
	id=127887,
	division="lower",
	country="Austria",
	level=4,
	exp=128,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=71, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["MRAID402"] = {
	id=75659,
	division="lower",
	country="U.S.A.",
	level=7,
	exp=293,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=48, [130]=1, [140]=2, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 41,
	lifetime_jp = 0,
}

ECS.Players["GenesisRapshodos"] = {
	id=66380,
	division="lower",
	country="Colombia",
	level=12,
	exp=761,
	relics = {
	},
	tier_skill = {[120]=1, [130]=4, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 20,
	lifetime_jp = 0,
}

ECS.Players["AMintyDragon"] = {
	id=165916,
	division="lower",
	country="Unspecified",
	level=12,
	exp=815,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=71, [130]=2, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 96,
	lifetime_jp = 0,
}

ECS.Players["laoloser"] = {
	id=76012,
	division="lower",
	country="U.S.A.",
	level=4,
	exp=128,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=71, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["Palitroque"] = {
	id=131754,
	division="lower",
	country="Chile",
	level=6,
	exp=246,
	relics = {
	},
	tier_skill = {[120]=29, [130]=4, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 54,
	lifetime_jp = 0,
}

ECS.Players["soler98012"] = {
	id=109985,
	division="lower",
	country="Spain",
	level=2,
	exp=67,
	relics = {
	},
	tier_skill = {[120]=1, [130]=2, [140]=3, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["Tailsray"] = {
	id=76112,
	division="lower",
	country="Russian Federation",
	level=3,
	exp=96,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=48, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 7,
	lifetime_jp = 0,
}

ECS.Players["Sphinctus"] = {
	id=45878,
	division="lower",
	country="U.S.A.",
	level=3,
	exp=95,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=50, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 3,
	lifetime_jp = 0,
}

ECS.Players["Woodygirthry "] = {
	id=170603,
	division="lower",
	country="U.S.A.",
	level=2,
	exp=55,
	relics = {
	},
	tier_skill = {[120]=29, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["caliber1015"] = {
	id=35860,
	division="lower",
	country="U.S.A.",
	level=3,
	exp=95,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=50, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 2,
	lifetime_jp = 0,
}

ECS.Players["NW360"] = {
	id=172941,
	division="lower",
	country="U.S.A.",
	level=3,
	exp=78,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=27, [130]=3, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["Smanki"] = {
	id=75763,
	division="lower",
	country="Russian Federation",
	level=5,
	exp=213,
	relics = {
	},
	tier_skill = {[120]=24, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 19,
	lifetime_jp = 0,
}

ECS.Players["@@"] = {
	id=53075,
	division="lower",
	country="U.S.A.",
	level=1,
	exp=22,
	relics = {
	},
	tier_skill = {[120]=1, [130]=1, [140]=2, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 1,
	lifetime_jp = 0,
}

ECS.Players["jimmydeanhimself"] = {
	id=127858,
	division="lower",
	country="U.S.A.",
	level=1,
	exp=15,
	relics = {
	},
	tier_skill = {[120]=1, [130]=3, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["Kirituin"] = {
	id=66694,
	division="lower",
	country="Netherlands",
	level=5,
	exp=214,
	relics = {
	},
	tier_skill = {[120]=24, [130]=2, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 33,
	lifetime_jp = 0,
}

ECS.Players["Lequack"] = {
	id=165877,
	division="lower",
	country="Spain",
	level=2,
	exp=63,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=27, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["ZOM"] = {
	id=128892,
	division="lower",
	country="U.S.A.",
	level=6,
	exp=238,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=27, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 29,
	lifetime_jp = 0,
}

ECS.Players["iamralph"] = {
	id=66349,
	division="lower",
	country="U.S.A.",
	level=2,
	exp=63,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=27, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 13,
	lifetime_jp = 0,
}

ECS.Players["Ayaka"] = {
	id=167276,
	division="lower",
	country="United Kingdom",
	level=2,
	exp=63,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=27, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

ECS.Players["Rius"] = {
	id=172516,
	division="lower",
	country="Japan",
	level=2,
	exp=63,
	relics = {
		{name="Mom's Knife", quantity=1},
	},
	tier_skill = {[120]=27, [130]=1, [140]=1, [150]=1, [160]=1, [170]=1, [180]=1, [190]=1, [200]=1, [210]=1, [220]=1, [230]=1, [240]=1, [250]=1, [260]=1, [270]=1, [280]=1, [290]=1},
	affinities = {dp=0, ep=0, rp=0, ap=0},
	lifetime_song_gold = 0,
	lifetime_jp = 0,
}

InitializeDefaultRelics = function()
	-- Keep a copy of the relics under its own field.
	-- We'll need this to periodically reset relics.
	for _, data in pairs(ECS.Players) do
		data.default_relics = DeepCopy(data.relics)
	end
end

InitializeDefaultRelics()
InitializeECS()

local VerifyRelics = function()
	local size = #ECS.Relics

	for i=1, size do
		for j=i+1, size do
			local relic1 = ECS.Relics[i]
			local relic2 = ECS.Relics[j]
			local did_error = false

			-- Can these relics actually be used together?
			if relic1.is_marathon == relic2.is_marathon then
				-- Iterate through the divisions.
				for division, song_info in pairs(ECS.SongInfo) do
					-- Iterater through every song in each division.
					for song_data in ivalues(song_info.Songs) do
						-- Iterate through all players (except we break early below).
						for name, ecs_player in pairs(ECS.Players) do
							local result1 = relic1.score(ecs_player, song_info, song_data, {relic1, relic2}, 1000, 1.0)
							local result2 = relic2.score(ecs_player, song_info, song_data, {relic1, relic2}, 1000, 1.0)

							local error = ""
							if type(result1) ~= "number" then
								error = error .. "Relic1 failed "
							end
							if type(result2) ~= "number" then
								error = error .. "Relic2 failed "
							end

							if #error > 0 then
								did_error = true
								Trace(("*********************************************************************\n"..
										"\tRelic1: " .. relic1.name .. ", Relic2: " .. relic2.name .. "\n" ..
										"\tSong: " .. song_data.name .. "\n" ..
										"\tPlayer: " .. name .. "\n\t") .. error .. "\n" ..
										"********************************************************************"
									)
							end
							-- Break early because it will take very long to iterate through 500+ players for every
							-- relic pairing. Technically this affects the relics that scale based off of
							-- lifetime gold/lifetime jp but I think it's sufficient enough for now.
							break
						end
						if did_error then
							break
						end
					end
					if did_error then
						break
					end
				end
			end
			if did_error then
				break
			end
		end
	end
end

-- Uncomment if to verify that all the score functions of the relics return valid numbers.
-- VerifyRelics()

-- -----------------------------------------------------------------------
-- Helper Functions

-- Returns the division for the player (with error checking).
GetDivision = function()
	local mpn = GAMESTATE:GetMasterPlayerNumber()
	local profile_name = PROFILEMAN:GetPlayerName(mpn)
	if profile_name and ECS.Players[profile_name] and ECS.Players[profile_name].division ~= nil then
		return ECS.Players[profile_name].division
	end
	return nil
end

-- ------------------------------------------------------
-- Score Calculations

FindEcsSong = function(song_name, SongInfo)
	for data in ivalues(SongInfo.Songs) do
		if data.name == song_name then
			return data
		end
	end
	return nil
end

CalculateScoreForSong = function(ecs_player, song_name, score, relics_used, failed)
	if ecs_player == nil then SM("NO ECS PLAYER") return 0,nil end
	if song_name == nil then SM("NO SONG NAME") return 0,nil end
	if score == nil then SM("NO SCORE") return 0,nil end
	if relics_used == nil then SM("NO RELICS USED") return 0,nil end
	if failed == nil then SM("NO FAILED") return 0,nil end

	local AP = function(score)
		return math.ceil((score^4) * 1000)
	end

	local BP = function(ecs_player, song_info, song_data, relics_used, ap, score)
		local bp = 0
		-- Handle relics first
		for relic in ivalues(relics_used) do
			if relic.name ~= "(nothing)" then
				bp = bp + relic.score(ecs_player, song_info, song_data, relics_used, ap, score)
			end
		end

		-- Then affinities
		local dp = song_data.dp
		local ep = song_data.ep
		local rp = song_data.rp
		local max_division_rp = 1000 * (1 + (song_info.MaxBlockLevel-song_info.MinBlockLevel))
		bp = bp + math.floor((ecs_player.affinities.dp/2000)*dp +
						 (ecs_player.affinities.ep/2000)*ep +
						 (ecs_player.affinities.ap/2000)*ap +
						 (rp/(max_division_rp/1000)*(ecs_player.affinities.rp/2000)))
		return bp
	end

	local FailedScore = function(ecs_player, song_data, song_info, score)
		local tier_skill = ecs_player.tier_skill[song_data.bpm_tier]
		if not tier_skill then tier_skill = 1 end

		local dp = song_data.dp
		local ep = song_data.ep
		local rp = song_data.rp
		local ap = AP(score)

		if song_data.length < 8 then
			return math.floor(((dp + ep + rp + ap) * (tier_skill / 99) * score) * ((song_data.length - song_info.MinLength + 0.1) / ( 8 - (song_info.MinLength))))
		else
			return math.floor((dp + ep + rp + ap) * (tier_skill / 99) * score)
		end
	end

	local song_info = nil

	if GetDivision() == "upper" then
		song_info = ECS.SongInfo.Upper
	elseif GetDivision() == "mid" then
		song_info = ECS.SongInfo.Mid
	else
		song_info = ECS.SongInfo.Lower
	end

	local song_data = FindEcsSong(song_name, song_info)
	if song_data == nil then return 0, nil end

	if failed then
		return FailedScore(ecs_player, song_data, song_info, score), song_data
	else
		local dp = song_data.dp
		local ep = song_data.ep
		local rp = song_data.rp
		local ap = AP(score)
		local bp = BP(ecs_player, song_info, song_data, relics_used, ap, score)
		return (dp + ep + rp + ap + bp), song_data
	end

	return 0, song_data
end

AddPlayedSong = function(ecs_player, song_name, score, relics_used, failed)
	local points, song_data = CalculateScoreForSong(ecs_player, song_name, score, relics_used, failed)
	if song_data == nil then return end

	local index = #ECS.Player.SongsPlayed + 1
	for i=1,#ECS.Player.SongsPlayed do
		if ECS.Player.SongsPlayed[i].name == song_name then
			if points > ECS.Player.SongsPlayed[i].points then
				index = i
			end
		end
	end

	ECS.Player.SongsPlayed[index] = {
		name=song_data.name,
		stepartist=song_data.stepartist,
		points=points,
		steps=song_data.steps,
		bpm=song_data.bpm,
		bpm_tier=song_data.bpm_tier,
		failed=failed,
		relics_used=DeepCopy(relics_used),
		score=score,
	}

	local SortByPointsDesc = function(a, b)
		return a.points > b.points
	end

	table.sort(ECS.Player.SongsPlayed, SortByPointsDesc)
end