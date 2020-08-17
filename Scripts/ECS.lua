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
		id=0,
		name="Stone Blade",
		desc="A low-level blade made from stone. Somewhat enhanced by the accuracy of your attacks.",
		effect="Lv. 1 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=1,
		name="Stone Knife",
		desc="A low-level knife made from stone. Somewhat effective against fast opponents.",
		effect="Lv. 1 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=2,
		name="Stone Axe",
		desc="A low-level axe made from stone. Somewhat effective against large opponents.",
		effect="Lv. 1 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=3,
		name="Stone Arrow",
		desc="A low-level arrow tipped with stone. Deals weak damage with a bow equipped. Single use.",
		effect="+150 BP with bow equipped",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=4,
		name="Bronze Blade",
		desc="A mid-level blade made from bronze. Enhanced by the accuracy of your attacks.",
		effect="Lv. 2 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=5,
		name="Bronze Knife",
		desc="A mid-level knife made from bronze. Effective against fast opponents.",
		effect="Lv. 2 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=6,
		name="Bronze Axe",
		desc="A mid-level axe made from bronze. Effective against large opponents.",
		effect="Lv. 2 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=7,
		name="Bronze Arrow",
		desc="A mid-level arrow tipped with bronze. Deals good damage with a bow equipped. Single use.",
		effect="+350 BP with bow equipped",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=8,
		name="Mythril Blade",
		desc="A high-level blade made from mythril. Strongly enhanced by the accuracy of your attacks.",
		effect="Lv. 3 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=9,
		name="Mythril Knife",
		desc="A high-level knife made from mythril. Strongly effective against fast opponents.",
		effect="Lv. 3 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=10,
		name="Mythril Axe",
		desc="A high-level axe made from mythril. Strongly effective against large opponents.",
		effect="Lv. 3 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=11,
		name="Mythril Arrow",
		desc="A high-level arrow tipped with mythril. Deals strong damage with a bow equipped. Single use.",
		effect="+650 BP with bow equipped",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=12,
		name="Crystal Sword",
		desc="A stunningly beautiful crystal sword. Incredibly enhanced by the accuracy of your attacks.",
		effect="Lv. 4 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=13,
		name="Diamond Sword",
		desc="An immaculate diamond sword. Maximally enhanced by the accuracy of your attacks.",
		effect="Lv. 5 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=14,
		name="Shuriken",
		desc="Steel throwing star that can deal some good damage. Single use.",
		effect="+250 BP",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=15,
		name="Astral Earring",
		desc="Earrings that possess a magic enchantment to deter The Bois.",
		effect="Decents/WayOffs Off",
		is_consumable=true,
		is_marathon=false,
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				SL.Global.ActiveModifiers.TimingWindows = {true,true,true,false,false}
				PREFSMAN:SetPreference("TimingWindowSecondsW4", SL.Preferences.Competitive.TimingWindowSecondsW3)
				PREFSMAN:SetPreference("TimingWindowSecondsW5", SL.Preferences.Competitive.TimingWindowSecondsW3)
			end
		end
	},
	{
		id=16,
		name="Silver Stopwatch",
		desc="Stopwatch imbued with time magic.",
		effect="45 seconds added to break timer",
		is_consumable=true,
		is_marathon=false,
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEvaluationStage" then
				local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber())
				local failed = pss:GetFailed()
				if not failed then
					ECS.BreakTimer = ECS.BreakTimer + 45
				end
			end
		end
	},
	{
		id=17,
		name="Blood Rune",
		desc="Made from the blood of DPRT convicts, this morbid rune is only used to charge a specific relic. Creepy. Single use.",
		effect="+300 BP with Scythe of Vitur equipped|45 seconds added to break timer with Scythe of Vitur equipped",
		is_consumable=true,
		is_marathon=false,
		action=function() 
		--TODO(teejusb)
		end
	},
	{
		id=18,
		name="Lance of Longinus",
		desc="Extremely rare holy lance. Very effective against abominations.",
		effect="+3000 MP",
		is_consumable=false,
		is_marathon=true,
		action=function() end
	},
	{
		id=19,
		name="Mammon",
		desc="A massive war axe fueled by the essence of avarice. Has the potential to be extremely deadly.",
		effect="+600 BP for Rank 1 on Lifetime Song Gold|+BP based on Lifetime Song Gold for Rank 2 and below (Max 400)",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=20,
		name="Agility Potion",
		desc="Brewed in the Footspeed Empire by Arvin (who moonlights as a master alchemist), this potion grows more effective as you defeat fast enemies. Single use.",
		effect="At end of set, +BP equal to (average BPM of passed songs-120)^1.3",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=21,
		name="Dragon Arrow",
		desc="A vicious arrow tipped with a dragon fang. Strongly effective against fast opponents with a bow equipped. Single use.",
		effect="Lv. 3 DP Bonus with bow equipped|+500 BP with bow equipped",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=22,
		name="Crystal Dagger",
		desc="A stunningly beautiful crystal dagger. Incredibly effective against fast opponents.",
		effect="Lv. 4 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=23,
		name="Diamond Dagger",
		desc="An immaculate diamond dagger. Maximally effective against fast opponents.",
		effect="Lv. 5 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=24,
		name="Twisted Bow",
		desc="Prized bow recovered from the Chambers of Xeric. Maximally effective against difficult opponents.",
		effect="Lv. 5 RP Bonus with arrow equipped",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=25,
		name="Malefic Adumbration",
		desc="This dagger-- forged by Mad Matt deep within Mt. Sigatrev in ages past-- carries in it all the nice laughs, memes, and elitism of the Footspeed Empire. Transcendent effectiveness against fast opponents.",
		effect="+150 BP for tiers 270 and over|Lv. 6 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=26,
		name="Ivory Tower",
		desc="It's not a place, it's a thing. Just like you. Only the truly jej can wield this monstrous double-bladed polearm effectively. ",
		effect="+600 BP for Rank 1 on Lifetime JP|+BP based on Lifetime JP for Rank 2 and below (Max 400)",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=27,
		name="Dirk",
		desc="Not to be confused with Big Dirk. #upsfanboy420. Single use.",
		effect="+150 BP for 130 BPM songs",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=28,
		name="Spike Knuckles",
		desc="A threatening-looking set of hand to hand weapons. Single use.",
		effect="+150 BP for 140 BPM songs",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=29,
		name="Shashka",
		desc="Standard-issue blade from the Slav Coast. Single use.",
		effect="+150 BP for 150 BPM songs",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=30,
		name="Barbed Lariat",
		desc="A tricky, mid-range weapon fashioned with painful barbs. Single use.",
		effect="+150 BP for 160 BPM songs",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=31,
		name="Zweihander",
		desc="Wielded with two hands, this sword is a bit unbalanced, but packs a bunch. Single use.",
		effect="+150 BP for 170 BPM songs",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=32,
		name="Long Bow",
		desc="If you've got a good arrow, this bow is capable of inflicting some serious pain from a long distance. Made from a sturdy but pliable wood.",
		effect="+100 BP for 180 BPM songs with arrow equipped|+50 BP with arrow equipped",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=33,
		name="Epee",
		desc="Used by fencers, this weapon from French Coast Stamina is particularly useful for piercing weak spots in armor. Single use.",
		effect="+150 BP for 190 BPM songs",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=34,
		name="Carolingian Sword",
		desc="An old, runed sword recovered from a fjord in Viking Coast Stamina. Single use.",
		effect="+150 BP for 200 BPM songs",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=35,
		name="Regal Cutlass",
		desc="Practical, military-issue sword once used in the British Coast. Single use.",
		effect="+200 BP for 210 BPM songs",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=36,
		name="Scythe",
		desc="Farming tool adapted for combat. Single use.",
		effect="+200 BP for 220 BPM songs",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=37,
		name="Jagged Greataxe",
		desc="A rough but effective battle axe. Single use.",
		effect="+200 BP for 230 BPM songs",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=38,
		name="Sakabato",
		desc="Once held by a repentant assassin, this katana's blade is on the wrong side. Single use.",
		effect="+200 BP for 240 BPM songs",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=39,
		name="Heavy Glaive",
		desc="Nasty polearm that can do some serious damage. Single use.",
		effect="+200 BP for 250 BPM songs",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=40,
		name="Double Warblade",
		desc="This double-bladed sword staff is difficult to master, but a menace to face in battle. Single use.",
		effect="+200 BP for 260 BPM songs",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=41,
		name="Leavitas",
		desc="Sword tempered with the souls of slain n00bs. Levitas's left hand weapon. Incredibly effective against fast opponents.",
		effect="+100 BP for 270 BPM songs|Lv. 4 DP Bonus|+100 BP for tiers 280 and over with Laevitas equipped",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=42,
		name="Tizona",
		desc="Sword once used by a hero of Spanish Coast Stamina. Possesses strength that matches your skill.",
		effect="+BP equal to your skill in the speed tier",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=43,
		name="Zorlin Shape",
		desc="Sharp dagger with a uniquely shaped blade. Somewhat effective against fast opponents.",
		effect="+100 BP for 130 BPM songs|Lv. 1 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=44,
		name="Cat's Claws",
		desc="These long claws can inflict some hurting at a close range. Somewhat enhanced by the accuracy of your attacks.",
		effect="+100 BP for 140 BPM songs|Lv. 1 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=45,
		name="Samosek",
		desc="A magical, self-swinging sword originating from the Slav Coast. Somewhat effective against large opponents.",
		effect="+100 BP for 150 BPM songs|Lv. 1 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=46,
		name="Fire Lash",
		desc="This whip is wreathed in a magical flame that can induce painful burns. Effective against large opponents.",
		effect="+100 BP for 160 BPM songs|Lv. 2 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=47,
		name="Flamberge",
		desc="Two-handed long sword with a distinctive wave-shaped blade. Enhanced by the accuracy of your attacks.",
		effect="+100 BP for 170 BPM songs|Lv. 2 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=48,
		name="Eurytus Bow",
		desc="An ornately carved wooden bow made by a master craftsman. Effective against fast opponents.",
		effect="+100 BP for 180 BPM songs with arrow equipped|Lv. 2 DP Bonus with arrow equipped",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=49,
		name="Hauteclere",
		desc="Formerly a favored weapon of a famous paladin from French Coast Stamina in ages past. Strongly effective against large opponents.",
		effect="+100 BP for 190 BPM songs|Lv. 3 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=50,
		name="Gram",
		desc="Legendary sword of the Viking Coast that was used to slay a dragon. Strongly effective against fast opponents.",
		effect="+100 BP for 200 BPM songs|Lv. 3 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=51,
		name="Caliburn",
		desc="Pulled from a stone by an ancient king of the British Coast, this holy sword holds a deep history. Strongly enhanced by the accuracy of your attacks.",
		effect="+100 BP for 210 BPM songs|Lv. 3 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=52,
		name="Doom Sickle",
		desc="A deadly scythe previously used by a sorcerer king. Incredibly effective against large opponents.",
		effect="+100 BP for 220 BPM songs|Lv. 4 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=53,
		name="Bravura",
		desc="This huge, single-bladed axe is designed for efficient killing. Incredible effectiveness against opponents that are both large and fast.",
		effect="+100 BP for 230 BPM songs|Lv. 4 DP/EP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=54,
		name="Kusanagi",
		desc="Katana rumored to have been bequeathed to the early rulers of Japan Coast Stamina by a goddess. Incredibly effective against fast opponents.",
		effect="+100 BP for 240 BPM songs|Lv. 4 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=55,
		name="Gae Buide",
		desc="Vicious cursed spear that inflicts wounds that can't be healed. Maximum effectiveness against large opponents.",
		effect="+100 BP for 250 BPM songs|Lv. 5 EP Bonus|Lv. 1 AP Bonus if Gae Derg is equipped",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=56,
		name="Endurend",
		desc="An exotic polearm sporting a pair of colorful and extraordinarily sharp blades. Maximum effectiveness against opponents that are both large and fast.",
		effect="+100 BP for 260 BPM songs|Lv. 5 DP/EP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=57,
		name="Laevitas",
		desc="Overflowing with magical footspeed energy, this is Levitas's right hand weapon. Maximum effectiveness against fast opponents.",
		effect="+100 BP for 270 BPM songs|Lv. 5 DP Bonus|+100 BP for tiers 280 and over with Leavitas equipped",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=58,
		name="Armajejjon",
		desc="Being the most jej of all weapons, this massive scythe has been wielded by heroes and miscreants of the recent past.",
		effect="+700 BP|30 seconds removed from break timer",
		is_consumable=false,
		is_marathon=false,
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEvaluationStage" then
				ECS.BreakTimer = ECS.BreakTimer - 30
			end
		end
	},
	{
		id=59,
		name="Tiger Fangs",
		desc="Unusual claws fashioned from the fangs of a wild beast. Somewhat effective against large opponents.",
		effect="+150 BP for 140 BPM songs|Lv. 1 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=60,
		name="Kladenets",
		desc="Often confused with Samosek, this is another magic sword from the Slav Coast that, uh, can also swing itself. One might be tempted to say they were one in the same if it wasn't for the fact that they look different. Enhanced by the accuracy of your attacks.",
		effect="+100 BP for 150 BPM songs|Lv. 2 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=61,
		name="Vampire Killer",
		desc="Whip favored by a clan of vampire hunters (and rawinput). Effective against fast opponents.",
		effect="+150 BP for 160 BPM songs|Lv. 2 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=62,
		name="Pandemonium",
		desc="The Godfather's weapon of choice. Strongly effective against large opponents.",
		effect="+100 BP for 170 BPM songs|Lv. 3 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=63,
		name="Artemis Bow",
		desc="Supposedly once wielded by a goddess of many myths, this pristine bow is strongly enhanced by the accuracy of your attacks.",
		effect="+100 BP for 180 BPM songs with arrow equipped|Lv. 3 AP Bonus with arrow equipped",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=64,
		name="Durandal",
		desc="Indestructible sword once held by a hero of the French Coast. Strongly effective against fast opponents.",
		effect="+150 BP for 190 BPM songs|Lv. 3 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=65,
		name="Skofnung",
		desc="The greatest of all swords forged in the Viking Coast, this weapon is said to be imbued with the souls of berserkers from the distant past. Strongly effective against large opponents.",
		effect="+150 BP for 200 BPM songs|Lv. 3 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=66,
		name="Clarent",
		desc="Known as a sword of peace, this holy sword was used in ceremonies by a legendary king of British Coast Stamina. Incredibly enhanced by the accuracy of your attacks.",
		effect="+100 BP for 210 BPM songs|Lv. 4 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=67,
		name="Scythe of Vitur",
		desc="Cruel and brutal, this horrific weapon can be enhanced by Blood Runes from the Border Shop to add to its capabilities. Incredibly effective against large opponents.",
		effect="+200 BP for 220 BPM songs|Lv. 4 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=68,
		name="Wuuthrad",
		desc="An enormous ebony axe wrought to bring blight upon the elves. Incredibly effective against large opponents.",
		effect="+200 BP for 230 BPM songs|Lv. 4 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=69,
		name="Masamune",
		desc="Long, dangerous katana made by a legendary swordsmith. Incredible effectiveness against opponents that are both large and fast.",
		effect="+200 BP for 240 BPM songs|Lv. 4 DP/EP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=70,
		name="Gae Derg",
		desc="Spear with the ability to rend magic fields. Maximum effectiveness against large opponents.",
		effect="+200 BP for 250 BPM songs|Lv. 5 EP Bonus|Lv. 1 RP Bonus if Gae Buide is equipped",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=71,
		name="Endless River",
		desc="Transcendent effectiveness against large opponents.",
		effect="+150 BP for tiers 260 and under|Lv. 6 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=72,
		name="Sword, Made of Steel",
		desc="Strike like dragons, have no fear!",
		effect="+100 BP",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=73,
		name="Pendulum Blade",
		desc="One of those swinging-blade dungeon traps. How are you even planning on using it without hurting yourself?",
		effect="+200 BP|Lv. 4 RP Bonus|Forces life 5",
		is_consumable=false,
		is_marathon=false,
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				local cur_life_scale = PREFSMAN:GetPreference("LifeDifficultyScale")
				if cur_life_scale == 1.0 or (cur_life_scale ~= 1.0 and cur_life_scale < 0.8) then
					PREFSMAN:SetPreference("LifeDifficultyScale", 0.8)
					SM("Set to Life 5")
				end
			end
		end
	},
	{
		id=74,
		name="Baguette",
		desc="A week old baguette.",
		effect="Lv. 4 RP Bonus on any French Coast Stamina/BaguetteStreamz songs",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=75,
		name="Steel Wheat Bun",
		desc="A bun made from Steel Wheat, an extremely hardy and nutritious variety that grows in Texas Coast Stamina.",
		effect="None",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=76,
		name="Lon Lon Cheese",
		desc="High grade cheese made from the famous milk of Lon Lon Ranch. Delicious.",
		effect="None",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=77,
		name="Mandragora Lettuce",
		desc="Valued for its unique taste, this lettuce is considered to have the best flavor when it's harvested from a live mandragora. Considering how dangerous Mandragora are, that presents quite a bit of a problem for any would-be collectors.",
		effect="None",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=78,
		name="Maxim Tomato",
		desc="These huge tomatoes are thought to have healing properties. And they also have a big M on them.",
		effect="None",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=79,
		name="Dire Kangaroo Patty",
		desc="Made from the ground-up meat of a kangaroo variety native to East Coast Straya that can grow to be as tall as 9 meters. Considered a delicacy for its rarity.",
		effect="None",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=80,
		name="BURGER",
		desc="The ultimate burger, formed from expertly chosen ingredients in perfect harmony with one another. You can practically taste the aura of delicious burgerness radiating from it. Truly a divine entree.",
		effect="+1000 BP|The BP here stands for Burger Points|The Burger Points don't do anything",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=81,
		name="Fursuit",
		desc="'WEAR THIS TO BECOME STRAIGHT'\n\n--Zetorux (when asked for a relic description), 4 ABP",
		effect="Lv. 1 EP Bonus|Lv. 1 DP Bonus|Lv. 1 RP Bonus|Lv. 1 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=82,
		name="Cowboy Hat",
		desc="I reckon this here hat belongs to Rust! Yeehaw ! ! !",
		effect="None",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=83,
		name="GUNgnir",
		desc="Enchanted spear that supposedly never misses its mark... except some idiot tied a gun to the tip, which will probably blow it apart when you use it. What a dumb design.",
		effect="Lv. 4 DP Bonus|1/2 chance of forced life 3",
		is_consumable=true,
		is_marathon=false,
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				math.randomseed(os.time())
				if math.random() < 1.0/2.0 then
					local cur_life_scale = PREFSMAN:GetPreference("LifeDifficultyScale")
					if cur_life_scale == 1.0 or (cur_life_scale ~= 1.0 and cur_life_scale < 1.2) then
						PREFSMAN:SetPreference("LifeDifficultyScale", 1.2)
						SM("Set to Life 3")
					end
				end
			end
		end
	},
	{
		id=84,
		name="Ryuko's Scissor Blade",
		desc="Capable of changing size, this is half of a giant pair of scissors. It's pretty good at destroying clothes.",
		effect="Lv. 2 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=85,
		name="Nui's Scissor Blade",
		desc="Once used by the Grand Couturier of a nefarious textile company, this massive scissor blade can change forms depending on the user.",
		effect="Lv. 2 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=86,
		name="Rending Scissors",
		desc="Designed to sever life fibers, these huge scissors constitute a sizable threat to anyone that isn't naked.",
		effect="Lv. 2 AP Bonus|Lv. 2 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=87,
		name="Buster Sword",
		desc="Previously owned by various spikey haired warriors, this broadsword has inherited the hopes of those who fight.",
		effect="+77 BP",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=88,
		name="Vampiric Longsword",
		desc="Originally conferred unto those who sought to challenge a many-tentacled Horror, this weapon absorbs the lifeforce of your enemies.",
		effect="+50 BP per minute of song length|18% of song length added to break timer",
		is_consumable=false,
		is_marathon=false,
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
		id=89,
		name="Shards of Narsil",
		desc="These are shards from a legendary sword? Probably? Single use.",
		effect="Lv. 4 AP Bonus",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=90,
		name="Anduril",
		desc="Forged from the Shards of Narsil, this new weapon hails the return of the king. Transcendentally enhanced by the accuracy of your attacks.",
		effect="Lv. 6 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=91,
		name="Perish",
		desc="Possesses abominable power, but carries great risk with its use.",
		effect="+700 BP|Forces life 5",
		is_consumable=false,
		is_marathon=false,
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				local cur_life_scale = PREFSMAN:GetPreference("LifeDifficultyScale")
				if cur_life_scale == 1.0 or (cur_life_scale ~= 1.0 and cur_life_scale < 0.8) then
					PREFSMAN:SetPreference("LifeDifficultyScale", 0.8)
					SM("Set to Life 5")
				end
			end
		end
	},
	{
		id=92,
		name="Claiomh Solais",
		desc="Powerful sword once wielded by a paladin. Contains the essence of sacred fire and is extremely effective against abominations.",
		effect="+2000 MP",
		is_consumable=false,
		is_marathon=true,
		action=function() end
	},
	{
		id=93,
		name="Aegis",
		desc="Shield previously used by a paladin. Very effective protection against various opponents.",
		effect="Forces life 3",
		is_consumable=true,
		is_marathon=false,
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				local cur_life_scale = PREFSMAN:GetPreference("LifeDifficultyScale")
				if cur_life_scale == 1.0 or (cur_life_scale ~= 1.0 and cur_life_scale < 1.2) then
					PREFSMAN:SetPreference("LifeDifficultyScale", 1.2)
					SM("Set to Life 3")
				end
			end
		end
	},
	{
		id=94,
		name="Throne",
		desc="A strange, sentient-throne familiar. Will come to your aid against abominations.",
		effect="Forces life 3",
		is_consumable=true,
		is_marathon=true,
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				local cur_life_scale = PREFSMAN:GetPreference("LifeDifficultyScale")
				if cur_life_scale == 1.0 or (cur_life_scale ~= 1.0 and cur_life_scale < 1.2) then
					PREFSMAN:SetPreference("LifeDifficultyScale", 1.2)
					SM("Set to Life 3")
				end
			end
		end
	},
	{
		id=95,
		name="Skull Ring",
		desc="Magic ring that manipulates the flow of time in your favor -- at a price.",
		effect="Adds 60 seconds to the break timer|Forces life 5",
		is_consumable=true,
		is_marathon=false,
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				local cur_life_scale = PREFSMAN:GetPreference("LifeDifficultyScale")
				if cur_life_scale == 1.0 or (cur_life_scale ~= 1.0 and cur_life_scale < 0.8) then
					PREFSMAN:SetPreference("LifeDifficultyScale", 0.8)
					SM("Set to Life 5")
				end
			elseif SCREENMAN:GetTopScreen():GetName() == "ScreenEvaluationStage" then
				local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber())
				local failed = pss:GetFailed()
				if not failed then
					ECS.BreakTimer = ECS.BreakTimer + 60
				end
			end
		end
	},
	{
		id=96,
		name="Astral Ring",
		desc="Ring that possesses a magic enchantment to deter The Bois when you're facing abominations.",
		effect="Decents/WayOffs Off",
		is_consumable=true,
		is_marathon=true,
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				SL.Global.ActiveModifiers.TimingWindows = {true,true,true,false,false}
				PREFSMAN:SetPreference("TimingWindowSecondsW4", SL.Preferences.Competitive.TimingWindowSecondsW3)
				PREFSMAN:SetPreference("TimingWindowSecondsW5", SL.Preferences.Competitive.TimingWindowSecondsW3)
			end
		end
	},
	{
		id=97,
		name="Protect Ring",
		desc="Onyx ring imbued with powerful magic that will protect your life.",
		effect="Forces life 1",
		is_consumable=true,
		is_marathon=false,
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				local cur_life_scale = PREFSMAN:GetPreference("LifeDifficultyScale")
				if cur_life_scale == 1.0 or (cur_life_scale ~= 1.0 and cur_life_scale < 1.6) then
					PREFSMAN:SetPreference("LifeDifficultyScale", 1.6)
					SM("Set to Life 1")
				end
			end
		end
	},
	{
		id=98,
		name="Champion Belt",
		desc="Belt presented to the greatest champions of Stamina Nation. Single use.",
		effect="+100 BP|Allows user to equip one additional relic",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=99,
		name="Bronze Trophy",
		desc="The Stamina Corps awards these trophies to fledgling staminadventurers as thanks for their good deeds.",
		effect="Access to #bronze-bistro on the Stamina Nation discord (upon request)",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=100,
		name="Mythril Trophy",
		desc="A trophy made from a rare metal. Only given to those who have made substantial contributions to the Stamina Nation.",
		effect="Access to #mythril-lounge on the Stamina Nation discord (upon request)",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=101,
		name="Crystal Trophy",
		desc="Awarded to high class staminadventurers for exceptional achievements.",
		effect="Access to #crystal-cafe on the Stamina Nation discord (upon request)",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=102,
		name="Slime Badge",
		desc="A cheaply made badge presented to you by the Stamina Corps for services rendered.",
		effect="At end of set, +100 BP for each song with a different speed tier",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=103,
		name="Stamina Potion",
		desc="Engineered by Tom No Bar for use in the Stamina Corps, this potion grows more effective as you defeat large enemies. Single use.",
		effect="At end of set, +BP equal to total steps of passed songs divided by 75",
		is_consumable=true,
		is_marathon=false,
		action=function() end
	},
	{
		id=104,
		name="Golden Stopwatch",
		desc="Ornate stopwatch imbued with powerful time magic.",
		effect="90 seconds added to break timer",
		is_consumable=true,
		is_marathon=false,
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEvaluationStage" then
				local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber())
				local failed = pss:GetFailed()
				if not failed then
					ECS.BreakTimer = ECS.BreakTimer + 90
				end
			end
		end
	},
	{
		id=105,
		name="Arvin's Gambit",
		desc="Well-known set of playing cards from the Footspeed Empire. Highly prized for their magical qualities.",
		effect="If equipped, and you fail the marathon, you may reattempt it immediately with up to 20 additional minutes to warm up/fix the pads.",
		is_consumable=true,
		is_marathon=true,
		action=function()
		--TODO(teejusb)
		end
	},
	{
		id=106,
		name="Pandemonium Zero",
		desc="Forged by the Godfather in Chimney Rock on the Misty Moor, this weapon grows in strength alongside its wielder.",
		effect="+600 BP for Rank 1 on Lifetime EXP|+BP based on Lifetime EXP for Rank 2 and below (Max 400)",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=107,
		name="Faust's Scalpel",
		desc="This massive scalpel has the ability to split abominations in two.",
		effect="If equipped, the marathon is split into two parts, and you may take up to five minutes of break between them.",
		is_consumable=true,
		is_marathon=true,
		action=function()
		-- TODO(teejusb)
		end
	},
	{
		id=108,
		name="Reid",
		desc="Peerless sword passed down by a line of sword saints. The blade can only be drawn from its sheath against worthy adversaries. Transcendent effectiveness against difficult opponents.",
		effect="Lv. 6 RP Bonus",
		is_consumable=false,
		is_marathon=false,
		action=function() end
	},
	{
		id=109,
		name="Order of Ambrosia",
		desc="The greatest of honors bestowed upon staminadventurers.",
		effect="Allows user to equip an additional two relics",
		is_consumable=true,
		is_marathon=false,
		action=function() end
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

ECS.Players["Rust"] = {
	isupper=true,
	country="U.S.A.",
	level=100,
	exp=4501575,
	relics = {
		{name="Tattered Mario",					  quantity=1},
		{name="Contemporary Mario",				 quantity=1},
		{name="Mario For Business",				 quantity=1},
		{name="Calamity Mario"},
		{name="Fiery Broadsword"},
		{name="Max Blade"},
		{name="The Green Book"},
		{name="The Postcard"},
		{name="Perish"},
		{name="Sword, Made of Steel"},
		{name="Pendulum Blade"},
		{name="Pendulum Blade +"},
		{name="La Baguette de la Discorde",	  quantity=1},
		{name="Vampiric Longsword"},
		{name="Skull Ring",							quantity=1},
		{name="Astral Ring",						  quantity=1},
		{name="Protect Ring",						 quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Jewel Knuckles",					  quantity=1},
		{name="Warhammer"},
		{name="Morning Star",						 quantity=1},
		{name="Flamberge",							 quantity=1},
		{name="Wizard Rod",							quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Zweihander",							quantity=1},
		{name="Excalipur",							 quantity=1},
		{name="Kotetsu"},
		{name="Gale Bow",							  quantity=1},
		{name="Osafune",								quantity=1},
		{name="Vorpal Blade"},
		{name="Mage Masher",						  quantity=1},
		{name="Kain's Lance",						 quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Fist of Tulkas"},
		{name="Vampire Killer"},
		{name="Whale Whisker"},
		{name="Mjolnir"},
		{name="Caladbolg"},
		{name="Excalibur II"},
		{name="Jinu"},
		{name="Twisted Bow"},
		{name="Masamune"},
		{name="Bane of Aulis"},
		{name="Mehrunes' Razor",					 quantity=1},
		{name="Gungnir",								quantity=1},
		{name="Armajejjon"},
		{name="Spiral of Aulis"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
		{name="Black Robes Eternal",				quantity=1},
		{name="Rolling Black Robes",				quantity=1},
		{name="Accented Black Robes",			  quantity=1},
		{name="Black Robes With Extra Cheese",  quantity=1},
		{name="Trailing Black Robes",			  quantity=1},
		{name="Black Robes En Francais",		  quantity=1},
		{name="Yung Black Robes",					quantity=1},
		{name="Claiomh Solais"},
		{name="Aegis",								  quantity=1},
		{name="Throne",								 quantity=1},
		{name="Pandemonium Zero"},
		{name="Staminadventurer's License"},
		{name="Slime Badge",						  quantity=1},
		{name="Bronze Trophy"},
		{name="Golden Stopwatch",					quantity=1},
		{name="Mythril Trophy"},
		{name="Arvin's Gambit",					  quantity=1},
		{name="Crystal Trophy"},
		{name="Order of Ambrosia",				  quantity=1},
	}
}

ECS.Players["nico"] = {
	isupper=true,
	country="U.S.A.",
	level=99,
	exp=3007066,
	relics = {
		{name="Silver Stopwatch",					quantity=1},
		{name="Lance of Longinus"},
		{name="ECS Hat",								quantity=1},
		{name="Tattered Mario",					  quantity=1},
		{name="Contemporary Mario",				 quantity=1},
		{name="Mario For Business",				 quantity=1},
		{name="Calamity Mario"},
		{name="Maria Plush"},
		{name="Fiery Broadsword"},
		{name="Max Blade"},
		{name="The Postcard"},
		{name="Sword, Made of Steel"},
		{name="Pendulum Blade"},
		{name="Pendulum Blade +"},
		{name="La Baguette de la Discorde",	  quantity=1},
		{name="Vampiric Longsword"},
		{name="Skull Ring",							quantity=1},
		{name="Astral Ring",						  quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Jewel Knuckles",					  quantity=1},
		{name="Warhammer"},
		{name="Morning Star",						 quantity=1},
		{name="Wizard Rod",							quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Zweihander",							quantity=1},
		{name="Excalipur",							 quantity=1},
		{name="Gale Bow",							  quantity=1},
		{name="Osafune",								quantity=1},
		{name="Vorpal Blade"},
		{name="Mage Masher",						  quantity=1},
		{name="Kain's Lance",						 quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Twisted Bow"},
		{name="Masamune"},
		{name="Bane of Aulis"},
		{name="Mehrunes' Razor",					 quantity=1},
		{name="Gungnir",								quantity=1},
		{name="Armajejjon"},
		{name="Spiral of Aulis"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
		{name="Black Robes Eternal",				quantity=1},
		{name="Rolling Black Robes",				quantity=1},
		{name="Accented Black Robes",			  quantity=1},
		{name="Black Robes With Extra Cheese",  quantity=1},
		{name="Trailing Black Robes",			  quantity=1},
		{name="Black Robes En Francais",		  quantity=1},
		{name="Yung Black Robes",					quantity=1},
		{name="Claiomh Solais"},
		{name="Aegis",								  quantity=1},
		{name="Throne",								 quantity=1},
		{name="Pandemonium Zero"},
		{name="Staminadventurer's License"},
		{name="Slime Badge",						  quantity=1},
		{name="Bronze Trophy"},
		{name="Golden Stopwatch",					quantity=1},
		{name="Mythril Trophy"},
		{name="Arvin's Gambit",					  quantity=1},
		{name="Crystal Trophy"},
	}
}

ECS.Players["SoftTofu"] = {
	isupper=true,
	country="U.S.A.",
	level=99,
	exp=3330976,
	relics = {
		{name="Silver Stopwatch",					quantity=1},
		{name="Astral Earring",					  quantity=1},
		{name="Mammon"},
		{name="Lance of Longinus"},
		{name="Tattered Mario",					  quantity=1},
		{name="Contemporary Mario",				 quantity=1},
		{name="Mario For Business",				 quantity=1},
		{name="Calamity Mario"},
		{name="Maria Plush"},
		{name="Fiery Broadsword"},
		{name="Max Blade"},
		{name="The Green Book"},
		{name="The Postcard"},
		{name="Perish"},
		{name="Sword, Made of Steel"},
		{name="Pendulum Blade"},
		{name="Vampiric Longsword"},
		{name="Skull Ring",							quantity=1},
		{name="Astral Ring",						  quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Jewel Knuckles",					  quantity=1},
		{name="Warhammer"},
		{name="Morning Star",						 quantity=1},
		{name="Flamberge",							 quantity=1},
		{name="Wizard Rod",							quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Zweihander",							quantity=1},
		{name="Excalipur",							 quantity=1},
		{name="Kotetsu"},
		{name="Gale Bow",							  quantity=1},
		{name="Osafune",								quantity=1},
		{name="Mage Masher",						  quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Fist of Tulkas"},
		{name="Serp i Molot"},
		{name="Vampire Killer"},
		{name="Pandemonium"},
		{name="Whale Whisker"},
		{name="Mjolnir"},
		{name="Caladbolg"},
		{name="Excalibur II"},
		{name="Jinu"},
		{name="Twisted Bow"},
		{name="Masamune"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
		{name="Black Robes Eternal",				quantity=1},
		{name="Rolling Black Robes",				quantity=1},
		{name="Accented Black Robes",			  quantity=1},
		{name="Black Robes With Extra Cheese",  quantity=1},
		{name="Trailing Black Robes",			  quantity=1},
		{name="Black Robes En Francais",		  quantity=1},
		{name="Yung Black Robes",					quantity=1},
		{name="Claiomh Solais"},
		{name="Aegis",								  quantity=1},
		{name="Throne",								 quantity=1},
		{name="Pandemonium Zero"},
		{name="Staminadventurer's License"},
		{name="Slime Badge",						  quantity=1},
		{name="Bronze Trophy"},
		{name="Golden Stopwatch",					quantity=1},
		{name="Mythril Trophy"},
	}
}

ECS.Players["rawinput"] = {
	isupper=true,
	country="U.S.A.",
	level=99,
	exp=2160908,
	relics = {
		{name="Bronze Sword"},
		{name="Bronze Dagger"},
		{name="Bronze Axe"},
		{name="Bronze Flail"},
		{name="Bronze Rapier"},
		{name="Astral Earring",					  quantity=1},
		{name="ECS Hat",								quantity=1},
		{name="Tattered Mario",					  quantity=1},
		{name="Contemporary Mario",				 quantity=1},
		{name="Mario For Business",				 quantity=1},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Pendulum Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Astral Ring",						  quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Warhammer"},
		{name="Morning Star",						 quantity=1},
		{name="Flamberge",							 quantity=1},
		{name="Wizard Rod",							quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Zweihander",							quantity=1},
		{name="Excalipur",							 quantity=1},
		{name="Gale Bow",							  quantity=1},
		{name="Osafune",								quantity=1},
		{name="Mage Masher",						  quantity=1},
		{name="Kain's Lance",						 quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Serp i Molot"},
		{name="Pandemonium"},
		{name="Twisted Bow"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
		{name="Black Robes Eternal",				quantity=1},
		{name="Accented Black Robes",			  quantity=1},
		{name="Black Robes En Francais",		  quantity=1},
		{name="Yung Black Robes",					quantity=1},
	}
}

ECS.Players["milkopia"] = {
	isupper=true,
	country="",
	level=92,
	exp=1283028,
	relics = {
		{name="Bronze Sword"},
		{name="Bronze Dagger"},
		{name="Bronze Axe"},
		{name="Bronze Flail"},
		{name="Bronze Rapier"},
		{name="Silver Stopwatch",					quantity=1},
		{name="Astral Earring",					  quantity=1},
		{name="ECS Hat",								quantity=1},
		{name="Tattered Mario",					  quantity=1},
		{name="Contemporary Mario",				 quantity=1},
		{name="Mario For Business",				 quantity=1},
		{name="Tainted Broadsword"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Wizard Rod",							quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Zweihander",							quantity=1},
		{name="Excalipur",							 quantity=1},
		{name="Gale Bow",							  quantity=1},
		{name="Osafune",								quantity=1},
		{name="Mage Masher",						  quantity=1},
		{name="Colada"},
		{name="Twisted Bow"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
		{name="Yung Black Robes",					quantity=1},
	}
}

ECS.Players["Archi"] = {
	isupper=true,
	country="U.S.A.",
	level=99,
	exp=2168263,
	relics = {
		{name="Silver Stopwatch",					quantity=1},
		{name="Diamond Blade"},
		{name="Mammon"},
		{name="ECS Hat",								quantity=1},
		{name="Tattered Mario",					  quantity=1},
		{name="Contemporary Mario",				 quantity=1},
		{name="Mario For Business",				 quantity=1},
		{name="Maria Plush"},
		{name="Fiery Broadsword"},
		{name="Max Blade"},
		{name="The Green Book"},
		{name="The Postcard"},
		{name="Perish"},
		{name="Sword, Made of Steel"},
		{name="Skull Ring",							quantity=1},
		{name="Astral Ring",						  quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Jewel Knuckles",					  quantity=1},
		{name="Warhammer"},
		{name="Morning Star",						 quantity=1},
		{name="Flamberge",							 quantity=1},
		{name="Wizard Rod",							quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Zweihander",							quantity=1},
		{name="Excalipur",							 quantity=1},
		{name="Gale Bow",							  quantity=1},
		{name="Osafune",								quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Vampire Killer"},
		{name="Pandemonium"},
		{name="Mjolnir"},
		{name="Caladbolg"},
		{name="Excalibur II"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
		{name="Rolling Black Robes",				quantity=1},
		{name="Accented Black Robes",			  quantity=1},
		{name="Black Robes With Extra Cheese",  quantity=1},
		{name="Trailing Black Robes",			  quantity=1},
		{name="Black Robes En Francais",		  quantity=1},
		{name="Yung Black Robes",					quantity=1},
		{name="Staminadventurer's License"},
		{name="Slime Badge",						  quantity=1},
		{name="Bronze Trophy"},
		{name="Golden Stopwatch",					quantity=1},
	}
}

ECS.Players["hippaheikki"] = {
	isupper=true,
	country="Finland",
	level=87,
	exp=876966,
	relics = {
		{name="Silver Stopwatch",					quantity=1},
		{name="Astral Earring",					  quantity=1},
		{name="Tattered Mario",					  quantity=1},
		{name="Contemporary Mario",				 quantity=1},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Warhammer"},
		{name="Morning Star",						 quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Zweihander",							quantity=1},
		{name="Excalipur",							 quantity=1},
		{name="Gale Bow",							  quantity=1},
		{name="Osafune",								quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
		{name="Staminadventurer's License"},
		{name="Slime Badge",						  quantity=1},
	}
}

ECS.Players["Bran"] = {
	isupper=true,
	country="U.S.A.",
	level=99,
	exp=2467525,
	relics = {
		{name="Silver Stopwatch",					quantity=1},
		{name="Diamond Blade"},
		{name="Mammon"},
		{name="Lance of Longinus"},
		{name="ECS Hat",								quantity=1},
		{name="Tattered Mario",					  quantity=1},
		{name="Contemporary Mario",				 quantity=1},
		{name="Mario For Business",				 quantity=1},
		{name="Maria Plush"},
		{name="Fiery Broadsword"},
		{name="Max Blade"},
		{name="The Green Book"},
		{name="The Postcard"},
		{name="Sword, Made of Steel"},
		{name="Skull Ring",							quantity=1},
		{name="Astral Ring",						  quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Jewel Knuckles",					  quantity=1},
		{name="Warhammer"},
		{name="Morning Star",						 quantity=1},
		{name="Wizard Rod",							quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Zweihander",							quantity=1},
		{name="Excalipur",							 quantity=1},
		{name="Gale Bow",							  quantity=1},
		{name="Osafune",								quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
		{name="Accented Black Robes",			  quantity=1},
		{name="Black Robes With Extra Cheese",  quantity=1},
		{name="Black Robes En Francais",		  quantity=1},
		{name="Yung Black Robes",					quantity=1},
		{name="Staminadventurer's License"},
		{name="Slime Badge",						  quantity=1},
		{name="Bronze Trophy"},
	}
}

ECS.Players["lil_beastling"] = {
	isupper=true,
	country="Australia",
	level=82,
	exp=606665,
	relics = {
		{name="Silver Stopwatch",					quantity=1},
		{name="Lance of Longinus"},
		{name="ECS Hat",								quantity=1},
		{name="Tattered Mario",					  quantity=1},
		{name="Tainted Broadsword"},
		{name="Max Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Warhammer"},
		{name="Morning Star",						 quantity=1},
		{name="Wizard Rod",							quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Zweihander",							quantity=1},
		{name="Excalipur",							 quantity=1},
		{name="Colada"},
		{name="Serp i Molot"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
		{name="Staminadventurer's License"},
	}
}

ECS.Players["SteveReen"] = {
	isupper=true,
	country="U.S.A.",
	level=85,
	exp=743637,
	relics = {
		{name="Mythril Axe"},
		{name="Silver Stopwatch",					quantity=1},
		{name="ECS Hat",								quantity=1},
		{name="Tattered Mario",					  quantity=1},
		{name="Tainted Broadsword"},
		{name="Max Blade"},
		{name="The Green Book"},
		{name="Sword, Made of Steel"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Morning Star",						 quantity=1},
		{name="Wizard Rod",							quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Zweihander",							quantity=1},
		{name="Excalipur",							 quantity=1},
		{name="Colada"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
		{name="Black Robes En Francais",		  quantity=1},
		{name="Staminadventurer's License"},
		{name="Slime Badge",						  quantity=1},
	}
}

ECS.Players["Jeremy"] = {
	isupper=true,
	country="U.S.A.",
	level=76,
	exp=374781,
	relics = {
		{name="Silver Stopwatch",					quantity=1},
		{name="Astral Earring",					  quantity=1},
		{name="Tattered Mario",					  quantity=1},
		{name="Contemporary Mario",				 quantity=1},
		{name="Tainted Broadsword"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Morning Star",						 quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Zweihander",							quantity=1},
		{name="Excalipur",							 quantity=1},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
	}
}

ECS.Players["sudzi781"] = {
	isupper=true,
	country="U.S.A.",
	level=36,
	exp=12056,
	relics = {
		{name="Mythril Dagger"},
		{name="Silver Stopwatch",					quantity=1},
		{name="Tattered Mario",					  quantity=1},
		{name="Contemporary Mario",				 quantity=1},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Wizard Rod",							quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Zweihander",							quantity=1},
		{name="Excalipur",							 quantity=1},
		{name="Gale Bow",							  quantity=1},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
		{name="Black Robes Eternal",				quantity=1},
		{name="Accented Black Robes",			  quantity=1},
		{name="Black Robes With Extra Cheese",  quantity=1},
	}
}

ECS.Players["JDongs"] = {
	isupper=true,
	country="U.S.A.",
	level=85,
	exp=719071,
	relics = {
		{name="Champion Belt",						quantity=1},
		{name="Tattered Mario",					  quantity=1},
		{name="Contemporary Mario",				 quantity=1},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Sword, Made of Steel"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Morning Star",						 quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Zweihander",							quantity=1},
		{name="Gale Bow",							  quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
		{name="Staminadventurer's License"},
	}
}

ECS.Players["TheUltravioletCatastrophe"] = {
	isupper=true,
	country="U.S.A.",
	level=91,
	exp=1219226,
	relics = {
		{name="Tattered Mario",					  quantity=1},
		{name="Fiery Broadsword"},
		{name="Blade"},
		{name="Sword, Made of Steel"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Jewel Knuckles",					  quantity=1},
		{name="Warhammer"},
		{name="Morning Star",						 quantity=1},
		{name="Flamberge",							 quantity=1},
		{name="Wizard Rod",							quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Zweihander",							quantity=1},
		{name="Excalipur",							 quantity=1},
		{name="Gale Bow",							  quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Fist of Tulkas"},
		{name="Serp i Molot"},
		{name="Vampire Killer"},
		{name="Whale Whisker"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
		{name="Black Robes En Francais",		  quantity=1},
		{name="Yung Black Robes",					quantity=1},
		{name="Staminadventurer's License"},
		{name="Slime Badge",						  quantity=1},
		{name="Bronze Trophy"},
	}
}

ECS.Players["Koettmaskinen"] = {
	isupper=true,
	country="Sweden",
	level=87,
	exp=849398,
	relics = {
		{name="Silver Stopwatch",					quantity=1},
		{name="Lance of Longinus"},
		{name="Fiery Broadsword"},
		{name="Blade"},
		{name="Sword, Made of Steel"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Jewel Knuckles",					  quantity=1},
		{name="Warhammer"},
		{name="Morning Star",						 quantity=1},
		{name="Wizard Rod",							quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Zweihander",							quantity=1},
		{name="Excalipur",							 quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
		{name="Black Robes En Francais",		  quantity=1},
		{name="Staminadventurer's License"},
		{name="Slime Badge",						  quantity=1},
		{name="Bronze Trophy"},
	}
}

ECS.Players["Okami"] = {
	isupper=true,
	country="France",
	level=79,
	exp=451195,
	relics = {
		{name="Bronze Sword"},
		{name="Iron Sword"},
		{name="Bronze Dagger"},
		{name="Iron Dagger"},
		{name="Bronze Axe"},
		{name="Iron Axe"},
		{name="Bronze Flail"},
		{name="Iron Flail"},
		{name="Bronze Rapier"},
		{name="Iron Rapier"},
		{name="Fiery Broadsword"},
		{name="Max Blade"},
		{name="Sword, Made of Steel"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Morning Star",						 quantity=1},
		{name="Wizard Rod",							quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Zweihander",							quantity=1},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
		{name="Staminadventurer's License"},
	}
}

ECS.Players["GIEZ"] = {
	isupper=true,
	country="Japan",
	level=75,
	exp=322468,
	relics = {
		{name="Mythril Flail"},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Sword, Made of Steel"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Morning Star",						 quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Zweihander",							quantity=1},
		{name="Colada"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
		{name="Black Robes En Francais",		  quantity=1},
	}
}

ECS.Players["ITGAlex"] = {
	isupper=true,
	country="U.S.A.",
	level=82,
	exp=587551,
	relics = {
		{name="Mythril Dagger"},
		{name="Silver Stopwatch",					quantity=1},
		{name="ECS Hat",								quantity=1},
		{name="Tattered Mario",					  quantity=1},
		{name="Tainted Broadsword"},
		{name="Max Blade"},
		{name="Sword, Made of Steel"},
		{name="Pendulum Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Morning Star",						 quantity=1},
		{name="Wizard Rod",							quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Zweihander",							quantity=1},
		{name="Colada"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
		{name="Black Robes Eternal",				quantity=1},
	}
}

ECS.Players["RD"] = {
	isupper=true,
	country="U.S.A.",
	level=86,
	exp=822677,
	relics = {
		{name="Mythril Rapier"},
		{name="Silver Stopwatch",					quantity=1},
		{name="Astral Earring",					  quantity=1},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Sword, Made of Steel"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Jewel Knuckles",					  quantity=1},
		{name="Warhammer"},
		{name="Morning Star",						 quantity=1},
		{name="Wizard Rod",							quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Zweihander",							quantity=1},
		{name="Excalipur",							 quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Vampire Killer"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
		{name="Black Robes En Francais",		  quantity=1},
		{name="Staminadventurer's License"},
		{name="Slime Badge",						  quantity=1},
	}
}

ECS.Players["Dr.0ctgonapus"] = {
	isupper=true,
	country="U.S.A.",
	level=74,
	exp=313775,
	relics = {
		{name="Iron Axe"},
		{name="ECS Hat",								quantity=1},
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Morning Star",						 quantity=1},
		{name="Excalipur",							 quantity=1},
		{name="Colada"},
	}
}

ECS.Players["Sidro"] = {
	isupper=true,
	country="U.S.A.",
	level=81,
	exp=544738,
	relics = {
		{name="Silver Stopwatch",					quantity=1},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Sword, Made of Steel"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Jewel Knuckles",					  quantity=1},
		{name="Warhammer"},
		{name="Morning Star",						 quantity=1},
		{name="Wizard Rod",							quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Zweihander",							quantity=1},
		{name="Excalipur",							 quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
		{name="Black Robes En Francais",		  quantity=1},
		{name="Staminadventurer's License"},
		{name="Slime Badge",						  quantity=1},
		{name="Bronze Trophy"},
	}
}

ECS.Players["skateinmars"] = {
	isupper=true,
	country="France",
	level=80,
	exp=486345,
	relics = {
		{name="Silver Stopwatch",					quantity=1},
		{name="Astral Earring",					  quantity=1},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Sword, Made of Steel"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Morning Star",						 quantity=1},
		{name="Wizard Rod",							quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Zweihander",							quantity=1},
		{name="Excalipur",							 quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
		{name="Black Robes En Francais",		  quantity=1},
		{name="Staminadventurer's License"},
		{name="Slime Badge",						  quantity=1},
		{name="Bronze Trophy"},
	}
}

ECS.Players["Keaize"] = {
	isupper=true,
	country="U.S.A.",
	level=79,
	exp=460506,
	relics = {
		{name="Bronze Sword"},
		{name="Iron Sword"},
		{name="Bronze Dagger"},
		{name="Bronze Axe"},
		{name="Iron Axe"},
		{name="Bronze Flail"},
		{name="Bronze Rapier"},
		{name="Silver Stopwatch",					quantity=1},
		{name="Lance of Longinus"},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Jewel Knuckles",					  quantity=1},
		{name="Warhammer"},
		{name="Morning Star",						 quantity=1},
		{name="Flamberge",							 quantity=1},
		{name="Wizard Rod",							quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Zweihander",							quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Fist of Tulkas"},
		{name="Vampire Killer"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
		{name="Black Robes En Francais",		  quantity=1},
		{name="Staminadventurer's License"},
		{name="Slime Badge",						  quantity=1},
	}
}

ECS.Players["JOKR"] = {
	isupper=false,
	country="United Kingdom",
	level=77,
	exp=397352,
	relics = {
		{name="Bronze Sword"},
		{name="Iron Sword"},
		{name="Bronze Dagger"},
		{name="Iron Dagger"},
		{name="Bronze Axe"},
		{name="Bronze Flail"},
		{name="Iron Flail"},
		{name="Bronze Rapier"},
		{name="Iron Rapier"},
		{name="Silver Stopwatch",					quantity=1},
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Morning Star",						 quantity=1},
		{name="Wizard Rod",							quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Zweihander",							quantity=1},
		{name="Colada"},
		{name="Baguette"},
	}
}

ECS.Players["ensypuri"] = {
	isupper=false,
	country="U.S.A.",
	level=77,
	exp=408874,
	relics = {
		{name="Mythril Flail"},
		{name="Silver Stopwatch",					quantity=1},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Jewel Knuckles",					  quantity=1},
		{name="Warhammer"},
		{name="Morning Star",						 quantity=1},
		{name="Wizard Rod",							quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Vampire Killer"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
		{name="Black Robes En Francais",		  quantity=1},
		{name="Staminadventurer's License"},
		{name="Slime Badge",						  quantity=1},
	}
}

ECS.Players["Yung Kiki"] = {
	isupper=false,
	country="U.S.A.",
	level=71,
	exp=234050,
	relics = {
		{name="Iron Axe"},
		{name="Silver Stopwatch",					quantity=1},
		{name="Astral Earring",					  quantity=1},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Morning Star",						 quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
		{name="Black Robes En Francais",		  quantity=1},
	}
}

ECS.Players["lolipo"] = {
	isupper=false,
	country="U.S.A.",
	level=66,
	exp=162509,
	relics = {
		{name="ECS Hat",								quantity=1},
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Morning Star",						 quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Baguette"},
	}
}

ECS.Players["CaptainBlack"] = {
	isupper=true,
	country="U.S.A.",
	level=66,
	exp=159774,
	relics = {
		{name="ECS Hat",			quantity=1},
		{name="Champion Belt",			quantity=1},
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Morning Star",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
	}
}

ECS.Players["sefirot"] = {
	isupper=false,
	country="Japan",
	level=71,
	exp=239960,
	relics = {
		{name="Bronze Sword"},
		{name="Bronze Dagger"},
		{name="Iron Dagger"},
		{name="Bronze Axe"},
		{name="Iron Axe"},
		{name="Bronze Flail"},
		{name="Iron Flail"},
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Morning Star",						 quantity=1},
		{name="Wizard Rod",							quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Boomerang",							 quantity=1},
	}
}

ECS.Players["Andkaseywaslike"] = {
	isupper=false,
	country="U.S.A.",
	level=66,
	exp=159284,
	relics = {
		{name="Iron Sword"},
		{name="Iron Dagger"},
		{name="Iron Axe"},
		{name="Iron Flail"},
		{name="Iron Rapier"},
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Jewel Knuckles",					  quantity=1},
		{name="Morning Star",						 quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Fist of Tulkas"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Staminadventurer's License"},
	}
}

ECS.Players["zxevik"] = {
	isupper=false,
	country="U.S.A.",
	level=75,
	exp=327393,
	relics = {
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Jewel Knuckles",					  quantity=1},
		{name="Morning Star",						 quantity=1},
		{name="Wizard Rod",							quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Zweihander",							quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
		{name="Staminadventurer's License"},
	}
}

ECS.Players["Rems"] = {
	isupper=false,
	country="France",
	level=63,
	exp=129550,
	relics = {
		{name="Iron Sword"},
		{name="Bronze Dagger"},
		{name="Bronze Axe"},
		{name="Bronze Flail"},
		{name="ECS Hat",								quantity=1},
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Morning Star",						 quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
	}
}

ECS.Players["Kev"] = {
	isupper=false,
	country="U.S.A.",
	level=69,
	exp=208316,
	relics = {
		{name="Bronze Sword"},
		{name="Bronze Dagger"},
		{name="Iron Dagger"},
		{name="Bronze Axe"},
		{name="Bronze Flail"},
		{name="Iron Flail"},
		{name="Bronze Rapier"},
		{name="Iron Rapier"},
		{name="Silver Stopwatch",					quantity=1},
		{name="Astral Earring",					  quantity=1},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Jewel Knuckles",					  quantity=1},
		{name="Morning Star",						 quantity=1},
		{name="Wizard Rod",							quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Fist of Tulkas"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
		{name="Staminadventurer's License"},
	}
}

ECS.Players["dominick"] = {
	isupper=false,
	country="U.S.A.",
	level=81,
	exp=562911,
	relics = {
		{name="Mythril Sword"},
		{name="Mythril Flail"},
		{name="Silver Stopwatch",					quantity=1},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Jewel Knuckles",					  quantity=1},
		{name="Warhammer"},
		{name="Morning Star",						 quantity=1},
		{name="Wizard Rod",							quantity=1},
		{name="Gaia Hammer",						  quantity=1},
		{name="Zweihander",							quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Fist of Tulkas"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
		{name="Black Robes En Francais",		  quantity=1},
		{name="Staminadventurer's License"},
		{name="Slime Badge",						  quantity=1},
	}
}

ECS.Players["teejusb"] = {
	isupper=false,
	country="U.S.A.",
	level=57,
	exp=72804,
	relics = {
		{name="Bronze Axe"},
		{name="Iron Axe"},
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Jewel Knuckles",					  quantity=1},
		{name="Morning Star",						 quantity=1},
		{name="Colada"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Staminadventurer's License"},
	}
}

ECS.Players["Janus5k"] = {
	isupper=false,
	country="U.S.A.",
	level=64,
	exp=131362,
	relics = {
		{name="Bronze Sword"},
		{name="Bronze Dagger"},
		{name="Bronze Axe"},
		{name="Iron Axe"},
		{name="Bronze Flail"},
		{name="Iron Flail"},
		{name="Bronze Rapier"},
		{name="Silver Stopwatch",					quantity=1},
		{name="Astral Earring",					  quantity=1},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Jewel Knuckles",					  quantity=1},
		{name="Morning Star",						 quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Boomerang",							 quantity=1},
		{name="Staminadventurer's License"},
	}
}

ECS.Players["Xynn"] = {
	isupper=false,
	country="Canada",
	level=59,
	exp=91060,
	relics = {
		{name="Bronze Sword"},
		{name="Iron Sword"},
		{name="Bronze Dagger"},
		{name="Iron Axe"},
		{name="Bronze Flail"},
		{name="Bronze Rapier"},
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Jewel Knuckles",					  quantity=1},
		{name="Morning Star",						 quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Fist of Tulkas"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Staminadventurer's License"},
	}
}

ECS.Players["Made"] = {
	isupper=false,
	country="Chile",
	level=55,
	exp=61329,
	relics = {
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Jewel Knuckles",					  quantity=1},
		{name="Warhammer"},
		{name="Morning Star",						 quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Fist of Tulkas"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Staminadventurer's License"},
	}
}

ECS.Players["TYLR"] = {
	isupper=false,
	country="U.S.A.",
	level=59,
	exp=92387,
	relics = {
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Morning Star",						 quantity=1},
		{name="Colada"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Staminadventurer's License"},
	}
}

ECS.Players["VincentITG"] = {
	isupper=false,
	country="U.S.A.",
	level=50,
	exp=41181,
	relics = {
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Morning Star",						 quantity=1},
	}
}

ECS.Players["aminuteawayx"] = {
	isupper=false,
	country="U.S.A.",
	level=54,
	exp=57055,
	relics = {
		{name="Bronze Sword"},
		{name="Bronze Dagger"},
		{name="Bronze Axe"},
		{name="Iron Axe"},
		{name="Bronze Flail"},
		{name="Bronze Rapier"},
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Jewel Knuckles",					  quantity=1},
		{name="Morning Star",						 quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Staminadventurer's License"},
	}
}

ECS.Players["GALAGA"] = {
	isupper=false,
	country="U.S.A.",
	level=55,
	exp=nil,
	relics = {
		{name="Silver Stopwatch",					quantity=1},
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Jewel Knuckles",					  quantity=1},
		{name="Morning Star",						 quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
		{name="Staminadventurer's License"},
	}
}

ECS.Players["I_ONLY_PLAY_BOARD_GAMES_NOW"] = {
	isupper=false,
	country="U.S.A.",
	level=41,
	exp=18570,
	relics = {
		{name="Bronze Sword"},
		{name="Bronze Dagger"},
		{name="Broadsword"},
		{name="Morning Star",						 quantity=1},
		{name="Colada"},
	}
}

ECS.Players["pinkloon"] = {
	isupper=false,
	country="U.S.A.",
	level=42,
	exp=19832,
	relics = {
		{name="Broadsword"},
		{name="Blade"},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Colada"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
	}
}

ECS.Players["Sal!V2"] = {
	isupper=false,
	country="U.S.A.",
	level=45,
	exp=25851,
	relics = {
		{name="Broadsword"},
		{name="Blade"},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Morning Star",						 quantity=1},
		{name="Colada"},
	}
}

ECS.Players["Chief Skittles"] = {
	isupper=false,
	country="U.S.A.",
	level=50,
	exp=39879,
	relics = {
		{name="Iron Rapier"},
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Morning Star",						 quantity=1},
		{name="Colada"},
		{name="Markuksen Kirves",					quantity=1},
	}
}

ECS.Players["IKA3K"] = {
	isupper=false,
	country="Japan",
	level=50,
	exp=39783,
	relics = {
		{name="Iron Rapier"},
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Morning Star",						 quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",					quantity=1},
	}
}

ECS.Players["HOT TAKE"] = {
	isupper=false,
	country="U.S.A.",
	level=34,
	exp=9883,
	relics = {
		{name="Broadsword"},
		{name="Blade"},
		{name="Colada"},
	}
}

ECS.Players["Redzone"] = {
	isupper=false,
	country="U.S.A.",
	level=51,
	exp=45046,
	relics = {
		{name="Bronze Sword"},
		{name="Bronze Dagger"},
		{name="Bronze Axe"},
		{name="Bronze Flail"},
		{name="Bronze Rapier"},
		{name="Broadsword"},
		{name="Blade"},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
	}
}

ECS.Players["Kyy"] = {
	isupper=false,
	country="Finland",
	level=43,
	exp=21553,
	relics = {
		{name="Bronze Sword"},
		{name="Bronze Dagger"},
		{name="Bronze Axe"},
		{name="Bronze Flail"},
		{name="Broadsword"},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Staminadventurer's License"},
	}
}

ECS.Players["Sereni"] = {
	isupper=false,
	country="",
	level=50,
	exp=40451,
	relics = {
		{name="Iron Rapier"},
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",							quantity=1},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Morning Star",						 quantity=1},
		{name="Markuksen Kirves",					quantity=1},
		{name="Arrow Vortex",						 quantity=1},
		{name="Baguette"},
	}
}

ECS.Players["@@"] = {
	isupper=false,
	country="U.S.A.",
	level=28,
	exp=5386,
	relics = {
		{name="Broadsword"},
		{name="Colada"},
	}
}

ECS.Players["AV6"] = {
	isupper=false,
	country="France",
	level=25,
	exp=3824,
	relics = {
		{name="Broadsword"},
	}
}

ECS.Players["Pluto"] = {
	isupper=false,
	country="Russian Federation",
	level=27,
	exp=4722,
	relics = {
		{name="Broadsword"},
		{name="Blade"},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Colada"},
		{name="Markuksen Kirves",					quantity=1},
	}
}

ECS.Players["tom no bar"] = {
	isupper=false,
	country="U.S.A.",
	level=25,
	exp=3840,
	relics = {
		{name="Broadsword"},
		{name="Blade"},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Colada"},
	}
}

ECS.Players["robbumon"] = {
	isupper=false,
	country="U.S.A.",
	level=28,
	exp=5116,
	relics = {
		{name="Bronze Sword"},
		{name="Bronze Dagger"},
		{name="Bronze Axe"},
		{name="Bronze Flail"},
		{name="Bronze Rapier"},
		{name="Broadsword"},
		{name="Blade"},
		{name="Lapis Fly Wing Rapier",			 quantity=1},
		{name="Colada"},
	}
}

ECS.Players["rynker"] = {
	isupper=false,
	country="U.S.A.",
	level=15,
	exp=1117,
	relics = {
		{name="Champion Belt",						quantity=1},
		{name="Broadsword"},
		{name="Blade"},
	}
}

ECS.Players["StoryTime"] = {
	isupper=false,
	country="U.S.A.",
	level=13,
	exp=825,
	relics = {
		{name="Broadsword"},
		{name="Colada"},
	}
}

ECS.Players["titandude21"] = {
	isupper=false,
	country="U.S.A.",
	level=nil,
	exp=nil,
	relics = {
	}
}

ECS.Players["DMAC"] = {
	isupper=false,
	country="U.S.A.",
	level=49,
	exp=37710,
	relics = {
		{name="Bronze Sword"},
		{name="Bronze Dagger"},
		{name="Bronze Axe"},
		{name="Bronze Flail"},
		{name="Bronze Rapier"},
		{name="Broadsword"},
	}
}

ECS.Players["MLA"] = {
	isupper=false,
	country="U.S.A.",
	level=nil,
	exp=nil,
	relics = {
	}
}


InitializeECS()