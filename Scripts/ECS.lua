ECS = {}

-- call this to (re)initialize per-player settings
InitializeECS = function()
	ECS.Mode = "Warmup"
	ECS.BreakTimer=(13 * 60)

	ECS.Player = {
		Profile=nil,
		Relics={},
	}
end

-- the master list
ECS.Relics = {
	{
		name="Slime Badge",
		desc="It's a cheap hunk of metal, but it proves you've got the basics down.",
		effect="100 BP for each song in set with a different speed tier",
		charges=1,
		rank=2,
		img="slimebadgeicon.png",
		action=function() end
	},
	{
		name="ECS Hat",
		desc="Official stamina merch.",
		effect="60 BP for each song in set with the same speed tier as selected song",
		charges=1,
		rank=2,
		img="ecshaticon.png",
		action=function() end
	},
	{
		name="Champion Belt",
		desc="Held by the greatest champions of the Stamina Nation from years past.",
		effect="100 BP, allows you to equip one additional relic",
		charges=1,
		rank=2,
		img="championbelticon.png",
		action=function() end
	},
	{
		name="Vampire Killer",
		desc="What even is the law, man?",
		effect="50 BP, Lv. 1 RP bonus after 5 PM",
		rank=2,
		img="vampirekillericon.png",
		action=function() end
	},
	{
		name="Sphere Soleil",
		desc="\"I'LL REMIND YOU THAT I HAVE A VERY LARGE STICK.\" –Estelle Bright",
		effect="100 BP on 180-tier songs, Lv. 1 AP bonus",
		rank=2,
		img="spheresoleilicon.png",
		action=function() end
	},
	{
		name="Mythril Trophy",
		desc="A trophy of the rare metal Mythril.",
		effect="60 seconds added to break timer",
		charges=3,
		rank=2,
		img="mythriltrophyicon.png",
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEvaluationStage" then
				local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber())
				local failed = pss:GetFailed()
				if not failed then
					ECS.BreakTimer = ECS.BreakTimer + 60
				end
			end
		end
	},
	{
		name="Sword, Made of Steel",
		desc="Standard issue in the Stamina Nation. It's not actually blazing with power. Sorry.",
		effect="100 BP",
		rank=2,
		img="swordmadeofsteelicon.png",
		action=function() end
	},
	{
		name="Astral Ring",
		desc="Would you rather it converted your HP to MP?",
		effect="Decents/WayOffs Off",
		charges=1,
		rank=2,
		img="astralringicon.png",
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				SL.Global.ActiveModifiers.WorstTimingWindow = 3
				PREFSMAN:SetPreference("TimingWindowSecondsW4", SL.Preferences.ITG.TimingWindowSecondsW3)
				PREFSMAN:SetPreference("TimingWindowSecondsW5", SL.Preferences.ITG.TimingWindowSecondsW3)
			end
		end
	},
	{
		name="Pendulum Blade",
		desc="It's like one of those swinging blade things you see in dungeons. Good luck figuring out how to use it without hurting yourself.",
		effect="Lv. 5 RP bonus, forces Life 5",
		rank=3,
		img="pendulumbladeicon.png",
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				PREFSMAN:SetPreference("LifeDifficultyScale", 0.8)
			end
		end
	},
	{
		name="Pandemonium",
		desc="\"Archi Aulis Veflax\" is inscribed on the hilt. Weird.",
		effect="100 BP on 170-tier songs, Lv. 2 EP bonus",
		rank=3,
		img="pandemoniumicon.png",
		action=function() end
	},
	{
		name="Mandau",
		desc="hey man (dau)",
		effect="100 BP on 190-tier songs, Lv. 2 DP bonus",
		rank=3,
		img="mandauicon.png",
		action=function() end
	},
	{
		name="Excalibur",
		desc="I bet you didn't know that King Arthur, Adelbert Steiner, Thunder God Cid, and the Warriors of Light were all pretty sick at 200 BPM too.",
		effect="100 BP on 200-tier songs, Lv. 3 AP bonus",
		rank=3,
		img="excaliburicon.png",
		action=function() end
	},
	{
		name="Rainbow",
		desc="Previously owned by a spikey haired mute. Expect to look fabulous as you strike down your hapless foes.",
		effect="100 BP on 220-tier songs, Lv. 3 DP/EP/AP/RP bonus",
		rank=4,
		img="rainbowicon.png",
		action=function() end
	},
	{
		name="Muramasa",
		desc="I had to spend hours farming dark octopi to get it this good, man.",
		effect="100 BP on 230-tier songs, 18% of song length added to break timer",
		rank=4,
		img="muramasaicon.png",
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEvaluationStage" then
				local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber())
				local failed = pss:GetFailed()
				if not failed then
					local length = GAMESTATE:GetCurrentSong():MusicLengthSeconds()
					if length then
						ECS.BreakTimer = ECS.BreakTimer + (length * 0.18)
					end
				end
			end
		end
	},
	{
		name="Protect Ring",
		desc="This powerful relic will protect your life in any circumstance.",
		effect="Fail Off",
		charges=1,
		rank=4,
		img="protectringicon.png",
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				local player_state = GAMESTATE:GetPlayerState(GAMESTATE:GetMasterPlayerNumber())
				if player_state then
					local po = player_state:GetPlayerOptions("ModsLevel_Preferred")
					if po then
						po:FailSetting('FailType_Off')
					end
				end
			end
		end
	},
	{
		name="Baguette",
		desc="I bet you've never worked this hard for a piece of french bread before.",
		effect="Lv. 5 RP bonus on any French Coast Stamina 2 or 3 songs",
		rank=4,
		img="baguetteicon.png",
		action=function() end
	},
	{
		name="Ultima Weapon",
		desc="A peerless blade to match your peerless will.",
		effect="100 BP on 210-tier songs, Lv. 4 EP bonus",
		rank=4,
		img="ultimaweaponicon.png",
		action=function() end
	},
	{
		name="Masamune",
		desc="Forged by a legendary swordsmith. Like Excalibur, this weapon has been swung by a lot of different folks, but this one is cooler. And more Japanese.",
		effect="100 BP on 240-tier songs, Lv. 4 DP/EP bonus",
		rank=4,
		img="masamuneicon.png",
		action=function() end
	},
	{
		name="Crissaegrim",
		desc="Who was Schmoo supposed to be, anyway?",
		effect="100 BP on 260-tier songs, Lv. 4 DP bonus",
		rank=5,
		img="crissaegrimicon.png",
		action=function() end
	},
	{
		name="Mace of Zeus",
		desc="\"How do you prove you exist? Maybe we don't exist...\" –Vivi Ornitier",
		effect="100 BP on 250-tier songs, Lv. 4 AdjStream bonus",
		rank=5,
		img="maceofzeusicon.png",
		action=function() end
	},
	{
		name="Order of Ambrosia",
		desc="A token of the Godfather's favor will be granted to those who clear all rank 4 quests and vanquish the greatest enemies of the Stamina Nation.",
		effect="Allows you to equip an additional two relics",
		charges=1,
		rank=5,
		img="orderofambrosiaicon.png",
		action=function() end
	},
	{
		name="Armajejjon",
		desc="The ultimate weapon of Stamina Nation, only conferred by the Godfather himself.",
		effect="600 BP, subtracts 30 seconds from break timer",
		rank=5,
		img="armajejjonicon.png",
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEvaluationStage" then
				ECS.BreakTimer = ECS.BreakTimer - 30
			end
		end
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
-- Player Data

-- initial player relic data
ECS.Players = {}

ECS.Players["CardboardBox"] = {
	relics = {
		{name="Slime Badge",			chg=  1},
		{name="ECS Hat",				chg=  0},
		{name="Champion Belt",			chg=  1},
		{name="Vampire Killer",			chg= 99},
		{name="Sphere Soleil",			chg= 99},
		{name="Mythril Trophy",			chg=  3},
		{name="Sword, Made of Steel",	chg= 99},
		{name="Astral Ring",			chg=  1},
		{name="Pendulum Blade",			chg= 99},
		{name="Pandemonium",			chg= 99},
		{name="Mandau",					chg= 99},
		{name="Excalibur",				chg= 99},
		{name="Rainbow",				chg= 99},
		{name="Muramasa",				chg= 99},
		{name="Ultima Weapon",			chg= 99},
		{name="Protect Ring",			chg=  1},
		{name="Baguette",				chg= 99},
		{name="Masamune",				chg= 99},
		{name="Mace of Zeus",			chg= 99},
		{name="Crissaegrim",			chg= 99},
		{name="Order of Ambrosia",		chg=  1},
		{name="Armajejjon",				chg= 99},
	}
}

ECS.Players["Aoreo"] = {
	relics = {
		{name="Slime Badge",		 	chg=  1},
		{name="ECS Hat",			 	chg=  1},
		{name="Champion Belt",		 	chg=  0},
		{name="Vampire Killer",		 	chg= 99},
		{name="Sphere Soleil",		 	chg= 99},
		{name="Mythril Trophy",		 	chg=  3},
		{name="Sword, Made of Steel", 	chg= 99},
		{name="Astral Ring",			chg=  1},
		{name="Pendulum Blade",		 	chg= 99},
		{name="Pandemonium",			chg= 99},
		{name="Mandau",				 	chg= 99},
		{name="Excalibur",			 	chg= 99},
		{name="Rainbow",				chg= 99},
		{name="Muramasa",			 	chg= 99},
		{name="Ultima Weapon",		 	chg=  0},
		{name="Protect Ring",		 	chg=  1},
		{name="Baguette",		 		chg=  0},
		{name="Masamune",			 	chg=  0},
		{name="Mace of Zeus",		 	chg=  0},
		{name="Crissaegrim",		 	chg=  0},
		{name="Order of Ambrosia",	 	chg=  0},
		{name="Armajejjon",		 		chg=  0},
	}
}

ECS.Players["nico"] = {
	relics = {
		{name="Slime Badge",			chg=  1},
		{name="ECS Hat",				chg=  0},
		{name="Champion Belt",			chg=  0},
		{name="Vampire Killer",			chg= 99},
		{name="Sphere Soleil",			chg= 99},
		{name="Mythril Trophy",			chg=  3},
		{name="Sword, Made of Steel",	chg= 99},
		{name="Astral Ring",			chg=  1},
		{name="Pendulum Blade",			chg= 99},
		{name="Pandemonium",			chg= 99},
		{name="Mandau",					chg= 99},
		{name="Excalibur",				chg= 99},
		{name="Rainbow",				chg=  0},
		{name="Muramasa",				chg=  0},
		{name="Ultima Weapon",			chg=  0},
		{name="Protect Ring",			chg=  0},
		{name="Baguette",				chg=  0},
		{name="Masamune",				chg=  0},
		{name="Mace of Zeus",			chg=  0},
		{name="Crissaegrim",			chg=  0},
		{name="Order of Ambrosia",		chg=  0},
		{name="Armajejjon",				chg=  0},
	}
}

ECS.Players["JDongs"] = {
	relics = {
		{name="Slime Badge",			chg=  0},
		{name="ECS Hat",				chg=  0},
		{name="Champion Belt",			chg=  1},
		{name="Vampire Killer",			chg=  0},
		{name="Sphere Soleil",			chg=  0},
		{name="Mythril Trophy",			chg=  0},
		{name="Sword, Made of Steel",	chg=  0},
		{name="Astral Ring",			chg=  1},
		{name="Pendulum Blade",			chg=  0},
		{name="Pandemonium",			chg=  0},
		{name="Mandau",					chg=  0},
		{name="Excalibur",				chg=  0},
		{name="Rainbow",				chg= 99},
		{name="Muramasa",				chg= 99},
		{name="Ultima Weapon",			chg=  0},
		{name="Protect Ring",			chg=  0},
		{name="Baguette",				chg=  0},
		{name="Masamune",				chg= 99},
		{name="Mace of Zeus",			chg=  0},
		{name="Crissaegrim",			chg=  0},
		{name="Order of Ambrosia",		chg=  0},
		{name="Armajejjon",				chg=  0},
	}
}

ECS.Players["Levitass"] = {
	relics = {
		{name="Slime Badge",			chg=  1},
		{name="ECS Hat",				chg=  0},
		{name="Champion Belt",			chg=  0},
		{name="Vampire Killer",			chg=  0},
		{name="Sphere Soleil",			chg= 99},
		{name="Mythril Trophy",			chg=  3},
		{name="Sword, Made of Steel",	chg= 99},
		{name="Astral Ring",			chg=  1},
		{name="Pendulum Blade",			chg=  0},
		{name="Pandemonium",			chg=  0},
		{name="Mandau",					chg= 99},
		{name="Excalibur",				chg= 99},
		{name="Rainbow",				chg=  0},
		{name="Muramasa",				chg=  0},
		{name="Ultima Weapon",			chg=  0},
		{name="Protect Ring",			chg=  0},
		{name="Baguette",				chg=  0},
		{name="Masamune",				chg=  0},
		{name="Mace of Zeus",			chg=  0},
		{name="Crissaegrim",			chg=  0},
		{name="Order of Ambrosia",		chg=  0},
		{name="Armajejjon",				chg=  0},
	}
}

ECS.Players["ITGAlex"] = {
	relics = {
		{name="Slime Badge",			chg=  1},
		{name="ECS Hat",				chg=  1},
		{name="Champion Belt",			chg=  0},
		{name="Vampire Killer",			chg=  0},
		{name="Sphere Soleil",			chg= 99},
		{name="Mythril Trophy",			chg=  0},
		{name="Sword, Made of Steel",	chg= 99},
		{name="Astral Ring",			chg=  1},
		{name="Pendulum Blade",			chg=  0},
		{name="Pandemonium",			chg=  0},
		{name="Mandau",					chg=  0},
		{name="Excalibur",				chg=  0},
		{name="Rainbow",				chg=  0},
		{name="Muramasa",				chg=  0},
		{name="Ultima Weapon",			chg=  0},
		{name="Protect Ring",			chg=  0},
		{name="Baguette",				chg=  0},
		{name="Masamune",				chg=  0},
		{name="Mace of Zeus",			chg=  0},
		{name="Crissaegrim",			chg=  0},
		{name="Order of Ambrosia",		chg=  0},
		{name="Armajejjon",				chg=  0},
	}
}

ECS.Players["Rawinput"] = {
	relics = {
		{name="Slime Badge",			chg=  1},
		{name="ECS Hat",				chg=  1},
		{name="Champion Belt",			chg=  0},
		{name="Vampire Killer",			chg=  0},
		{name="Sphere Soleil",			chg= 99},
		{name="Mythril Trophy",			chg=  3},
		{name="Sword, Made of Steel",	chg= 99},
		{name="Astral Ring",			chg=  1},
		{name="Pendulum Blade",			chg= 99},
		{name="Pandemonium",			chg= 99},
		{name="Mandau",					chg= 99},
		{name="Excalibur",				chg=  0},
		{name="Rainbow",				chg=  0},
		{name="Muramasa",				chg=  0},
		{name="Ultima Weapon",			chg=  0},
		{name="Protect Ring",			chg=  0},
		{name="Baguette",				chg=  0},
		{name="Masamune",				chg=  0},
		{name="Mace of Zeus",			chg=  0},
		{name="Crissaegrim",			chg=  0},
		{name="Order of Ambrosia",		chg=  0},
		{name="Armajejjon",				chg=  0},
	}
}

ECS.Players["Bran"] = {
	relics = {
		{name="Slime Badge",			chg=  1},
		{name="ECS Hat",				chg=  0},
		{name="Champion Belt",			chg=  0},
		{name="Vampire Killer",			chg=  0},
		{name="Sphere Soleil",			chg= 99},
		{name="Mythril Trophy",			chg=  3},
		{name="Sword, Made of Steel",	chg= 99},
		{name="Astral Ring",			chg=  1},
		{name="Pendulum Blade",			chg=  0},
		{name="Pandemonium",			chg=  0},
		{name="Mandau",					chg= 99},
		{name="Excalibur",				chg= 99},
		{name="Rainbow",				chg=  0},
		{name="Muramasa",				chg=  0},
		{name="Ultima Weapon",			chg=  0},
		{name="Protect Ring",			chg=  0},
		{name="Baguette",				chg=  0},
		{name="Masamune",				chg=  0},
		{name="Mace of Zeus",			chg=  0},
		{name="Crissaegrim",			chg=  0},
		{name="Order of Ambrosia",		chg=  0},
		{name="Armajejjon",				chg=  0},
	}
}

ECS.Players["2PercentMilk"] = {
	relics = {
		{name="Slime Badge", 			chg= 0},
		{name="ECS Hat", 				chg= 1},
		{name="Champion Belt", 			chg= 0},
		{name="Vampire Killer", 		chg= 0},
		{name="Sphere Soleil", 			chg= 0},
		{name="Mythril Trophy", 		chg= 0},
		{name="Sword, Made of Steel",	chg=99},
		{name="Astral Ring", 			chg= 0},
		{name="Pendulum Blade", 		chg= 0},
		{name="Pandemonium", 			chg= 0},
		{name="Mandau", 				chg= 0},
		{name="Excalibur", 				chg= 0},
		{name="Rainbow", 				chg= 0},
		{name="Muramasa", 				chg= 0},
		{name="Ultima Weapon", 			chg= 0},
		{name="Protect Ring", 			chg= 0},
		{name="Baguette", 				chg= 0},
		{name="Masamune", 				chg= 0},
		{name="Mace of Zeus", 			chg= 0},
		{name="Crissaegrim", 			chg= 0},
		{name="Order of Ambrosia", 		chg= 0},
		{name="Armajejjon", 			chg= 0},
	}
}

ECS.Players["Arvin"] = {
	relics = {
		{name="Slime Badge",			chg=  1},
		{name="ECS Hat",				chg=  0},
		{name="Champion Belt",			chg=  0},
		{name="Vampire Killer",			chg=  0},
		{name="Sphere Soleil",			chg= 99},
		{name="Mythril Trophy",			chg=  3},
		{name="Sword, Made of Steel",	chg= 99},
		{name="Astral Ring",			chg=  1},
		{name="Pendulum Blade",			chg= 99},
		{name="Pandemonium",			chg= 99},
		{name="Mandau",					chg= 99},
		{name="Excalibur",				chg=  0},
		{name="Rainbow",				chg=  0},
		{name="Muramasa",				chg=  0},
		{name="Ultima Weapon",			chg=  0},
		{name="Protect Ring",			chg=  0},
		{name="Baguette",				chg=  0},
		{name="Masamune",				chg=  0},
		{name="Mace of Zeus",			chg=  0},
		{name="Crissaegrim",			chg=  0},
		{name="Order of Ambrosia",		chg=  0},
		{name="Armajejjon",				chg=  0},
	}
}

ECS.Players["Dingoshi"] = {
	relics = {
		{name="Slime Badge",			chg=  1},
		{name="ECS Hat",				chg=  1},
		{name="Champion Belt",			chg=  0},
		{name="Vampire Killer",			chg= 99},
		{name="Sphere Soleil",			chg= 99},
		{name="Mythril Trophy",			chg=  3},
		{name="Sword, Made of Steel",	chg= 99},
		{name="Astral Ring",			chg=  1},
		{name="Pendulum Blade",			chg=  0},
		{name="Pandemonium",			chg=  0},
		{name="Mandau",					chg=  0},
		{name="Excalibur",				chg=  0},
		{name="Rainbow",				chg=  0},
		{name="Muramasa",				chg=  0},
		{name="Ultima Weapon",			chg=  0},
		{name="Protect Ring",			chg=  0},
		{name="Baguette",				chg=  0},
		{name="Masamune",				chg=  0},
		{name="Mace of Zeus",			chg=  0},
		{name="Crissaegrim",			chg=  0},
		{name="Order of Ambrosia",		chg=  0},
		{name="Armajejjon",				chg=  0},
	}
}

ECS.Players["SteveReen"] = {
	relics = {
		{name="Slime Badge",			chg=  1},
		{name="ECS Hat",				chg=  1},
		{name="Champion Belt",			chg=  0},
		{name="Vampire Killer",			chg=  0},
		{name="Sphere Soleil",			chg= 99},
		{name="Mythril Trophy",			chg=  3},
		{name="Sword, Made of Steel",	chg= 99},
		{name="Astral Ring",			chg=  1},
		{name="Pendulum Blade",			chg=  0},
		{name="Pandemonium",			chg=  0},
		{name="Mandau",					chg= 99},
		{name="Excalibur",				chg=  0},
		{name="Rainbow",				chg=  0},
		{name="Muramasa",				chg=  0},
		{name="Ultima Weapon",			chg=  0},
		{name="Protect Ring",			chg=  0},
		{name="Baguette",				chg=  0},
		{name="Masamune",				chg=  0},
		{name="Mace of Zeus",			chg=  0},
		{name="Crissaegrim",			chg=  0},
		{name="Order of Ambrosia",		chg=  0},
		{name="Armajejjon",				chg=  0},
	}
}

ECS.Players["lil_beastling"] = {
	relics = {
		{name="Slime Badge",			chg= 1},
		{name="ECS Hat",				chg= 1},
		{name="Champion Belt",			chg= 0},
		{name="Vampire Killer",			chg= 0},
		{name="Sphere Soleil",			chg= 0},
		{name="Mythril Trophy",			chg= 3},
		{name="Sword, Made of Steel",	chg= 0},
		{name="Astral Ring",			chg= 1},
		{name="Pendulum Blade",			chg= 0},
		{name="Pandemonium",			chg= 0},
		{name="Mandau",					chg= 0},
		{name="Excalibur",				chg= 0},
		{name="Rainbow",				chg= 0},
		{name="Muramasa",				chg= 0},
		{name="Ultima Weapon",			chg= 0},
		{name="Protect Ring",			chg= 0},
		{name="Baguette",				chg= 0},
		{name="Masamune",				chg= 0},
		{name="Mace of Zeus",			chg= 0},
		{name="Crissaegrim",			chg= 0},
		{name="Order of Ambrosia",		chg= 0},
		{name="Armajejjon",				chg= 0},
	}
}

ECS.Players["Archi"] = {
	relics = {
		{name="Slime Badge",			chg=  1},
		{name="ECS Hat",				chg=  1},
		{name="Champion Belt",			chg=  0},
		{name="Vampire Killer",			chg= 99},
		{name="Sphere Soleil",			chg= 99},
		{name="Mythril Trophy",			chg=  3},
		{name="Sword, Made of Steel",	chg= 99},
		{name="Astral Ring",			chg=  1},
		{name="Pendulum Blade",			chg= 99},
		{name="Pandemonium",			chg= 99},
		{name="Mandau",					chg= 99},
		{name="Excalibur",				chg=  0},
		{name="Rainbow",				chg=  0},
		{name="Muramasa",				chg=  0},
		{name="Ultima Weapon",			chg=  0},
		{name="Protect Ring",			chg=  0},
		{name="Baguette",				chg=  0},
		{name="Masamune",				chg=  0},
		{name="Mace of Zeus",			chg=  0},
		{name="Crissaegrim",			chg=  0},
		{name="Order of Ambrosia",		chg=  0},
		{name="Armajejjon",				chg=  0},
	}
}

ECS.Players["Okami"] = {
	relics = {
		{name="Slime Badge",			chg=  1},
		{name="ECS Hat",				chg=  0},
		{name="Champion Belt",			chg=  0},
		{name="Vampire Killer",			chg= 99},
		{name="Sphere Soleil",			chg= 99},
		{name="Mythril Trophy",			chg=  3},
		{name="Sword, Made of Steel",	chg= 99},
		{name="Astral Ring",			chg=  1},
		{name="Pendulum Blade",			chg=  0},
		{name="Pandemonium",			chg=  0},
		{name="Mandau",					chg= 99},
		{name="Excalibur",				chg=  0},
		{name="Rainbow",				chg=  0},
		{name="Muramasa",				chg=  0},
		{name="Ultima Weapon",			chg=  0},
		{name="Protect Ring",			chg=  0},
		{name="Baguette",				chg=  0},
		{name="Masamune",				chg=  0},
		{name="Mace of Zeus",			chg=  0},
		{name="Crissaegrim",			chg=  0},
		{name="Order of Ambrosia",		chg=  0},
		{name="Armajejjon",				chg=  0},
	}
}

ECS.Players["hippaheikki"] = {
	relics = {
		{name="Slime Badge",			chg=  1},
		{name="ECS Hat",				chg=  0},
		{name="Champion Belt",			chg=  0},
		{name="Vampire Killer",			chg=  0},
		{name="Sphere Soleil",			chg= 99},
		{name="Mythril Trophy",			chg=  3},
		{name="Sword, Made of Steel",	chg=  0},
		{name="Astral Ring",			chg=  0},
		{name="Pendulum Blade",			chg=  0},
		{name="Pandemonium",			chg=  0},
		{name="Mandau",					chg=  0},
		{name="Excalibur",				chg=  0},
		{name="Rainbow",				chg=  0},
		{name="Muramasa",				chg=  0},
		{name="Ultima Weapon",			chg=  0},
		{name="Protect Ring",			chg=  0},
		{name="Baguette",				chg=  0},
		{name="Masamune",				chg=  0},
		{name="Mace of Zeus",			chg=  0},
		{name="Crissaegrim",			chg=  0},
		{name="Order of Ambrosia",		chg=  0},
		{name="Armajejjon",				chg=  0},
	}
}


-- ------------------------------------------------------
-- Song Data
-- This isn't usable, because these aren't the titles of the Songs :(

ECS.Songs = {
	["Life is a Beach"] = {id=1},
	["Perfect Happiness"] = {id=2},
	["Anhedonia"] = {id=3},
	["Quantum Trip"] = {id=4},
	["The Galaxy Being VIP"] = {id=5},
	["Isolation"] = {id=6},
	["Cyber Spell"] = {id=7},
	["Cold Breath"] = {id=8},
	["Hesperides"] = {id=9},
	["Little Lies"] = {id=10},
	["Crossing Rage!"] = {id=11},
	["woooah?"] = {id=12},
	["Zap Your Channel"] = {id=13},
	["White Laguna"] = {id=14},
	["Radiation 238"] = {id=15},
	["Accidentally Tripping"] = {id=16},
	["Sincuvate Mix"] = {id=17},
	["Screw My Brain"] = {id=18},
	["Dino 2.0"] = {id=19},
	["Hello Dangdut (Kubus Hardfunk Remix)"] = {id=20},
	["Not The Fastest Shit I Made"] = {id=21},
	["VIRGIN CODE"] = {id=22},
	["Longinus"] = {id=23},
	["Be Careful"] = {id=24},
	["The Lightning Sword"] = {id=25},
	["Ra'am"] = {id=26},
	["Trails of Cold Stream FC (Part 1)"] = {id=27},
	["Extraterrestrial Pudding"] = {id=28},
	["Yin Yang"] = {id=29},
	["Fast Animu Music"] = {id=30},
	["The Bell"] = {id=31},
	["Mental Spectrum Hacker"] = {id=32},
	["Macrodose"] = {id=33},
	["Burn this moment into the retina of my eye"] = {id=34},
	["For the End of Set"] = {id=35},
	["Sayonara Planet Wars"] = {id=36},
	["Houkago Stride"] = {id=37},
	["Astral Reaper"] = {id=38},
	["Along A New Path"] = {id=39},
	["Spacetime"] = {id=40},
	["Happy Satanic Symbols"] = {id=41},
	["Trails of Cold Stream SC (Part 5)"] = {id=42},
	["FASTER Animu Music"] = {id=43},
	["Solar Storm"] = {id=44},
	["Glad you're back"] = {id=45},
	["In Time"] = {id=46},
	["Valestein Castle"] = {id=47},
	["Boogie Woogie Splatter Show"] = {id=48},
	["Beyond Our Star System"] = {id=49},
	["Ragnarok"] = {id=50},
	["Cyber Attack"] = {id=51},
	["Psychedelinger 2"] = {id=52},
	["I Can See The Lights"] = {id=53},
	["Vis Vitalis"] = {id=54},
	["Magical Tank Battle"] = {id=55},
	["Mental Meltdown"] = {id=56},
	["It's Alright"] = {id=57},
	["The Power Break's Over"] = {id=58},
	["Ramia"] = {id=59},
	["The Game"] = {id=60},
	["Fuck DJ"] = {id=61},
	["The Angel's Message"] = {id=62},
	["We Want To Run"] = {id=63},
	["Sinisterrrrrrrr"] = {id=64},
	["Shakunetsu Candle Master Tomosy"] = {id=65},
	["I'm A Maid (C-type Remix)"] = {id=66},
	["goretrance 9 (get happy or get fucked '97)"] = {id=67},
	["Dernier Voyage"] = {id=68},
	["A Bright Future"] = {id=69},
	["eat it up, boi!"] = {id=70},
	["FASTEST ANIMU MUSIC"] = {id=71},
	["Lifestyles of the Digital"] = {id=72},
	["The Message"] = {id=73},
	["Let's madness?"] = {id=74},
	["Souvenirs Du Futur"] = {id=75},
	["Awesome Powers"] = {id=76},
	["do i smile?"] = {id=77},
	["Unknown Depths"] = {id=78},
	["Chipspeed Allstars"] = {id=79},
	["Mirrors of Fate"] = {id=80},
	["Starfall"] = {id=81},
	["Blue Crew"] = {id=82},
	["Tachyon Beam Cannon"] = {id=83},
	["White Hair Little Swords Girl"] = {id=84},
	["Release of the Far West Ocean (jdk Band Spring 2008)"] = {id=85},
	["The Strongest Foe"] = {id=86},
	["Parallax"] = {id=87},
	["Everlasting"] = {id=88},
	["Erosion of Madness"] = {id=89},
	["Just Chill"] = {id=90},
}

InitializeECS()