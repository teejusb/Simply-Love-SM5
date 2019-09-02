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
		name="Bronze Sword",
		desc="A low-level sword made from bronze.  A weak all-purpose weapon.",
		effect="+25 BP",
		is_consumable=false,
		is_marathon=false,
		img="bronzesword.png",
		action=function() end
	},
	{
		id=1,
		name="Iron Sword",
		desc="A mid-level sword made from iron.  A good all-purpose weapon.",
		effect="+75 BP",
		is_consumable=false,
		is_marathon=false,
		img="ironsword.png",
		action=function() end
	},
	{
		id=2,
		name="Mythril Sword",
		desc="A high-level sword made from mythril.  A strong all-purpose weapon.",
		effect="+125 BP",
		is_consumable=false,
		is_marathon=false,
		img="mythrilsword.png",
		action=function() end
	},
	{
		id=3,
		name="Bronze Dagger",
		desc="A low-level dagger made from bronze.  Somewhat effective against fast opponents.",
		effect="Lv. 1 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="bronzedagger.png",
		action=function() end
	},
	{
		id=4,
		name="Iron Dagger",
		desc="A mid-level dagger made from iron.  Effective against fast opponents.",
		effect="Lv. 2 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="irondagger.png",
		action=function() end
	},
	{
		id=5,
		name="Mythril Dagger",
		desc="A high-level dagger made from mythril.  Strongly effective against fast opponents.",
		effect="Lv. 3 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="mythrildagger.png",
		action=function() end
	},
	{
		id=6,
		name="Bronze Axe",
		desc="A low-level axe made from bronze.  Somewhat effective against large opponents.",
		effect="Lv. 1 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="bronzeaxe.png",
		action=function() end
	},
	{
		id=7,
		name="Iron Axe",
		desc="A mid-level axe made from iron.  Effective against large opponents.",
		effect="Lv. 2 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="ironaxe.png",
		action=function() end
	},
	{
		id=8,
		name="Mythril Axe",
		desc="A high-level axe made from mythril.  Strongly effective against large opponents.",
		effect="Lv. 3 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="mythrilaxe.png",
		action=function() end
	},
	{
		id=9,
		name="Bronze Flail",
		desc="A low-level flail made from bronze.  Somewhat effective against difficult opponents.",
		effect="Lv. 1 RP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="bronzeflail.png",
		action=function() end
	},
	{
		id=10,
		name="Iron Flail",
		desc="A mid-level flail made from iron.  Effective against difficult opponents.",
		effect="Lv. 2 RP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="ironflail.png",
		action=function() end
	},
	{
		id=11,
		name="Mythril Flail",
		desc="A high-level flail made from mythril.  Strongly effective against difficult opponents.",
		effect="Lv. 3 RP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="mythrilflail.png",
		action=function() end
	},
	{
		id=12,
		name="Bronze Rapier",
		desc="A low-level rapier made from bronze.  Somewhat enhanced by the accuracy of your attacks..",
		effect="Lv. 1 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="bronzerapier.png",
		action=function() end
	},
	{
		id=13,
		name="Iron Rapier",
		desc="A mid-level rapier made from iron.  Enhanced by the accuracy of your attacks.",
		effect="Lv. 2 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="ironrapier.png",
		action=function() end
	},
	{
		id=14,
		name="Mythril Rapier",
		desc="A high-level rapier made from mythril.  Strongly enhanced by the accuracy of your attacks.",
		effect="Lv. 3 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="mythrilrapier.png",
		action=function() end
	},
	{
		id=15,
		name="Silver Stopwatch",
		desc="Stopwatch imbued with time magic.",
		effect="45 seconds added to break timer",
		is_consumable=true,
		is_marathon=false,
		img="silverstopwatch.png",
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
		id=16,
		name="Astral Earring",
		desc="Earrings that possess a magic enchantment to deter The Bois.",
		effect="WayOffs/Decents Off",
		is_consumable=true,
		is_marathon=false,
		img="astralearring.png",
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				SL.Global.ActiveModifiers.WorstTimingWindow = 3
				PREFSMAN:SetPreference("TimingWindowSecondsW4", SL.Preferences.ITG.TimingWindowSecondsW3)
				PREFSMAN:SetPreference("TimingWindowSecondsW5", SL.Preferences.ITG.TimingWindowSecondsW3)
			end
		end
	},
	{
		id=17,
		name="Diamond Blade",
		desc="An immaculate diamond sword.  Maximally enhanced by the accuracy of your attacks.",
		effect="Lv. 5 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="diamondblade.png",
		action=function() end
	},
	{
		id=18,
		name="Mammon",
		desc="A massive war axe fueled by the essence of avarice.  Has the potential to be extremely deadly.",
		effect="+BP based off of Lifetime Gold (Max 600)",
		is_consumable=false,
		is_marathon=false,
		img="mammon.png",
		action=function() end
	},
	{
		id=19,
		name="Lance of Longinus",
		desc="Extremely rare holy lance.  Very effective against abominations.",
		effect="+1500 MP",
		is_consumable=false,
		is_marathon=true,
		img="lanceoflonginus.png",
		action=function() end
	},
	{
		id=20,
		name="ECS Hat",
		desc="Standard-issue Stamina Corps ECS cap.",
		effect="At the end of set, +60 BP for each song in set with the same speed tier as the song you use this on",
		is_consumable=true,
		is_marathon=false,
		img="ecshat.png",
		action=function() end
	},
	{
		id=21,
		name="Champion Belt",
		desc="Belt presented to the greatest champions of Stamina Nation.",
		effect="+100 BP & Allows user to equip one additional relic",
		is_consumable=true,
		is_marathon=false,
		img="championbelt.png",
		action=function() end
	},
	{
		id=22,
		name="Tattered Mario",
		desc="This Mario has gotten too much love :-(",
		effect="None",
		is_consumable=true,
		is_marathon=false,
		img="tatteredmario.png",
		action=function() end
	},
	{
		id=23,
		name="Contemporary Mario",
		desc="This Mario is styling !",
		effect="None",
		is_consumable=true,
		is_marathon=false,
		img="contemporarymario.png",
		action=function() end
	},
	{
		id=24,
		name="Mario For Business",
		desc="WE MARIO AT 255 BPM",
		effect="None",
		is_consumable=true,
		is_marathon=false,
		img="marioforbusiness.png",
		action=function() end
	},
	{
		id=25,
		name="Calamity Mario",
		desc="Lusting for power, this Mario has consumed many other Marios to gain their strength.",
		effect="None",
		is_consumable=false,
		is_marathon=false,
		img="calamitymario.png",
		action=function() end
	},
	{
		id=26,
		name="Maria Plush",
		desc="An adorable plush of the Godfather's waifu!",
		effect="None",
		is_consumable=false,
		is_marathon=false,
		img="mariaplush.png",
		action=function() end
	},
	{
		id=27,
		name="Broadsword",
		desc="A standard broadsword.",
		effect="+20 BP",
		is_consumable=false,
		is_marathon=false,
		img="broadsword.png",
		action=function() end
	},
	{
		id=28,
		name="Tainted Broadsword",
		desc="A broadsword corrupted by the scourge.",
		effect="-100 BP",
		is_consumable=false,
		is_marathon=false,
		img="taintedbroadsword.png",
		action=function() end
	},
	{
		id=29,
		name="Fiery Broadsword",
		desc="Forged in Chimney Rock on the Misty Moor, this weapon grows in strength alongside its wielder.",
		effect="BP based off of EXP (Max 200)",
		is_consumable=false,
		is_marathon=false,
		img="fierybroadsword.png",
		action=function() end
	},
	{
		id=30,
		name="Steel Wool",
		desc="Just some regular steel wool.  No idea why you would want this.",
		effect="None",
		is_consumable=false,
		is_marathon=false,
		img="steelwool.png",
		action=function() end
	},
	{
		id=31,
		name="Blade",
		desc="A rusty, disused blade.",
		effect="+1 BP",
		is_consumable=false,
		is_marathon=false,
		img="blade.png",
		action=function() end
	},
	{
		id=32,
		name="Max Blade",
		desc="A razor-sharp blade.",
		effect="+210 BP",
		is_consumable=false,
		is_marathon=false,
		img="maxblade.png",
		action=function() end
	},
	{
		id=33,
		name="The Green Book",
		desc="A thin green book.  It's full of strange stick figure drawings.  For some reason, you feel horribly sad looking at it.",
		effect="None",
		is_consumable=false,
		is_marathon=false,
		img="thegreenbook.png",
		action=function() end
	},
	{
		id=34,
		name="The Postcard",
		desc="A postcard with a painting of some birds perched in a moonlit tree on the reverse side.  Pangs of shame wash over you as you study it… but why?",
		effect="None",
		is_consumable=false,
		is_marathon=false,
		img="thepostcard.png",
		action=function() end
	},
	{
		id=35,
		name="Perish",
		desc="Possesses abominable power, but carries great risk with its use.",
		effect="+700 BP & Forces life 7",
		is_consumable=false,
		is_marathon=false,
		img="perish.png",
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				local cur_life_scale = PREFSMAN:GetPreference("LifeDifficultyScale")
				if cur_life_scale == 1.0 or (cur_life_scale ~= 1.0 and cur_life_scale < 0.4) then
					PREFSMAN:SetPreference("LifeDifficultyScale", 0.4)
					SM("Set to Life 7")
				end
			end
		end
	},
	{
		id=36,
		name="Sword, Made of Steel",
		desc="Raise our swords, we fight for life-- shields and armor shining bright!",
		effect="+100 BP",
		is_consumable=false,
		is_marathon=false,
		img="swordmadeofsteel.png",
		action=function() end
	},
	{
		id=37,
		name="Pendulum Blade",
		desc="One of those swinging-blade dungeon traps.  How are you even planning on using it without hurting yourself?",
		effect="Lv. 6 RP Bonus & Forces life 5",
		is_consumable=false,
		is_marathon=false,
		img="pendulumblade.png",
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
		id=38,
		name="Pendulum Blade +",
		desc="One of those swinging-blade dungeon traps, except this one is incredibly deadly-- to both you and your opponent.",
		effect="Lv. 10 RP Bonus & Forces life 5",
		is_consumable=false,
		is_marathon=false,
		img="pendulumbladeplus.png",
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
		id=39,
		name="La Baguette de la Discorde",
		desc="A month old baguette radiating intense magical energies.",
		effect="Lv. 8 RP Bonus on any French Coast Stamina/BaguetteStreamz songs",
		is_consumable=true,
		is_marathon=false,
		img="labaguettedeladiscorde.png",
		action=function() end
	},
	{
		id=40,
		name="Vampiric Longsword",
		desc="Originally conferred unto those who sought to challenge the many-tentacled Horror, this weapon absorbs the lifeforce of your enemies.",
		effect="+150 BP & 18% of song length added to break timer",
		is_consumable=false,
		is_marathon=false,
		img="vampiriclongsword.png",
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
		id=41,
		name="Skull Ring",
		desc="Magic ring that manipulates the flow of time in your favor… at a price.",
		effect="Adds 60 seconds to the break timer & Forces life 5",
		is_consumable=true,
		is_marathon=false,
		img="skullring.png",
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
		id=42,
		name="Astral Ring",
		desc="Ring that possesses a magic enchantment to deter The Bois in your greatest time of need.",
		effect="WayOffs/Decents Off",
		is_consumable=true,
		is_marathon=true,
		img="astralring.png",
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				SL.Global.ActiveModifiers.WorstTimingWindow = 3
				PREFSMAN:SetPreference("TimingWindowSecondsW4", SL.Preferences.ITG.TimingWindowSecondsW3)
				PREFSMAN:SetPreference("TimingWindowSecondsW5", SL.Preferences.ITG.TimingWindowSecondsW3)
			end
		end
	},
	{
		id=43,
		name="Protect Ring",
		desc="Onyx ring imbued with powerful magic that will protect your life.",
		effect="Forces life 1",
		is_consumable=true,
		is_marathon=false,
		img="protectring.png",
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
		id=44,
		name="Lapis Fly Wing Rapier",
		desc="Rapier previously belonging to a skilled chef, nyan.  Breaks after use.",
		effect="+150 BP for 130 BPM songs",
		is_consumable=true,
		is_marathon=false,
		img="lapisflywingrapier.png",
		action=function() end
	},
	{
		id=45,
		name="Jewel Knuckles",
		desc="Sparkling with various gems.  You'll look absolutely fabulous while you're beating up your enemies!  Breaks after use.",
		effect="+150 BP for 140 BPM songs",
		is_consumable=true,
		is_marathon=false,
		img="jewelknuckles.png",
		action=function() end
	},
	{
		id=46,
		name="Warhammer",
		desc="A well-made hammer favored by Archi's Friend.  Somewhat effective against large opponents.",
		effect="+100 BP for 150 BPM songs & Lv. 1 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="warhammer.png",
		action=function() end
	},
	{
		id=47,
		name="Morning Star",
		desc="A basic spiked ball weapon.  You can probably guess what end does the business.  Breaks after use.",
		effect="+150 BP for 160 BPM songs",
		is_consumable=true,
		is_marathon=false,
		img="morningstar.png",
		action=function() end
	},
	{
		id=48,
		name="Flamberge",
		desc="A greatsword with a blade made in the shape of a flame.  Enhanced by the accuracy of your attacks.",
		effect="+100 BP for 170 BPM songs & Lv. 2 AP Bonus",
		is_consumable=true,
		is_marathon=false,
		img="flamberge.png",
		action=function() end
	},
	{
		id=49,
		name="Wizard Rod",
		desc="Magical rod with BL affinity.  Favored by General Aoreo.  Breaks after use.",
		effect="+150 BP for 180 BPM songs",
		is_consumable=true,
		is_marathon=false,
		img="wizardrod.png",
		action=function() end
	},
	{
		id=50,
		name="Gaia Hammer",
		desc="This heavy hammer has been enchanted with the earth element.  Breaks after use.",
		effect="+150 BP for 190 BPM songs",
		is_consumable=true,
		is_marathon=false,
		img="gaiahammer.png",
		action=function() end
	},
	{
		id=51,
		name="Zweihander",
		desc="A large, two-handed sword.  But in German.  Breaks after use.",
		effect="+150 BP for 200 BPM songs",
		is_consumable=true,
		is_marathon=false,
		img="zweihander.png",
		action=function() end
	},
	{
		id=52,
		name="Excalipur",
		desc="The sword of legend...?  Breaks after use.",
		effect="+200 BP for 210 BPM songs",
		is_consumable=true,
		is_marathon=false,
		img="excalipur.png",
		action=function() end
	},
	{
		id=53,
		name="Kotetsu",
		desc="Powerful katana forged by a great swordsmith.  Incredibly effective against large opponents.",
		effect="+100 BP for 220 BPM songs & Lv. 4 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="kotetsu.png",
		action=function() end
	},
	{
		id=54,
		name="Gale Bow",
		desc="A suprisingly lightweight longbow, enhanced with the element of wind.  Breaks after use.",
		effect="+200 BP for 230 BPM songs",
		is_consumable=true,
		is_marathon=false,
		img="galebow.png",
		action=function() end
	},
	{
		id=55,
		name="Osafune",
		desc="Katana forged by a famous swordsmith.  Breaks after use.",
		effect="+200 BP for 240 BPM songs",
		is_consumable=true,
		is_marathon=false,
		img="osafune.png",
		action=function() end
	},
	{
		id=56,
		name="Vorpal Blade",
		desc="And through and through the Vorpal Blade went snicker-snack!  Maximum effectiveness against fast opponents.",
		effect="+100 BP for 250 BPM songs & Lv. 5 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="vorpalblade.png",
		action=function() end
	},
	{
		id=57,
		name="Mage Masher",
		desc="Dagger made for combat against wizards.  Breaks after use.",
		effect="+200 BP for 260 BPM songs",
		is_consumable=true,
		is_marathon=false,
		img="magemasher.png",
		action=function() end
	},
	{
		id=58,
		name="Kain's Lance",
		desc="A dragoon's lance, suitable for high-flying attacks.  Breaks after use.",
		effect="+200 BP for 270 BPM songs",
		is_consumable=true,
		is_marathon=false,
		img="kainslance.png",
		action=function() end
	},
	{
		id=59,
		name="Colada",
		desc="Famous weapon from Spanish Coast Stamina.  Possesses strength that matches your skill.",
		effect="+BP equal to your skill in the speed tier",
		is_consumable=false,
		is_marathon=false,
		img="colada.png",
		action=function() end
	},
	{
		id=60,
		name="Joyeuse",
		desc="Sword once owned by a king.  Somewhat effective against difficult opponents.",
		effect="+100 BP for 130 BPM songs & Lv. 1 RP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="joyeuse.png",
		action=function() end
	},
	{
		id=61,
		name="Fist of Tulkas",
		desc="Named for Tulkas the Valar, these knuckles possess brute strength and are effective against large opponents.",
		effect="+100 BP for 140 BPM songs & Lv. 2 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="fistoftulkas.png",
		action=function() end
	},
	{
		id=62,
		name="Serp i Molot",
		desc="A token of Seer Pluto's appreciation for saving the Slav Coast.  Maximum effectiveness against large opponents.",
		effect="+150 BP for tiers 210 and under & Lv. 5 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="serpimolot.png",
		action=function() end
	},
	{
		id=63,
		name="Vampire Killer",
		desc="Whip favored by the Belmont clan and Rawinput.  Powers up in the evening against difficult opponents.",
		effect="+100 BP for 160 BPM songs & Lv. 3 RP Bonus after 5 PM",
		is_consumable=false,
		is_marathon=false,
		img="vampirekiller.png",
		action=function() end
	},
	{
		id=64,
		name="Pandemonium",
		desc="The Godfather's weapon of choice.  Strongly effective against large opponents.",
		effect="+100 BP for 170 BPM songs & Lv. 3 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="pandemonium.png",
		action=function() end
	},
	{
		id=65,
		name="Whale Whisker",
		desc="Rod possessing powerful magic.  Effective against fast opponents.",
		effect="+100 BP for 180 BPM songs & Lv. 2 DP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="whalewhisker.png",
		action=function() end
	},
	{
		id=66,
		name="Mjolnir",
		desc="Hammer of thunder.  Strongly effective against enemies that are both large and fast.",
		effect="+100 BP for 190 BPM songs & Lv. 3 DP/EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="mjolnir.png",
		action=function() end
	},
	{
		id=67,
		name="Caladbolg",
		desc="Greatsword of legend said to have sliced the tops off of hills.  Possesses strong effectivity when used accurately against large opponents.",
		effect="+100 BP for 200 BPM songs & Lv. 3 AP/EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="caladbolg.png",
		action=function() end
	},
	{
		id=68,
		name="Excalibur II",
		desc="Abandoned in Memoria by Enkidu, this mysterious relic is incredibly enhanced by the accuracy of your attacks.",
		effect="+100 BP for 210 BPM songs & Lv. 4 AP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="excaliburii.png",
		action=function() end
	},
	{
		id=69,
		name="Jinu",
		desc="A katana once used by the Divine Blade.  Transcendent effectiveness against large opponents.",
		effect="+150 BP for tiers 220 and over & Lv. 6 EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="jinu.png",
		action=function() end
	},
	{
		id=70,
		name="Twisted Bow",
		desc="Prized bow found in the Chambers of Xeric.  Incredibly effective against difficult opponents.",
		effect="+100 BP for 230 BPM songs & Lv. 4 RP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="twistedbow.png",
		action=function() end
	},
	{
		id=71,
		name="Masamune",
		desc="Long, dangerous katana made by a legendary swordsmith.  Maximum effectiveness against opponents that are both large and fast.",
		effect="+100 BP for 240 BPM songs & Lv. 5 DP/EP Bonus",
		is_consumable=false,
		is_marathon=false,
		img="masamune.png",
		action=function() end
	},
	{
		id=72,
		name="Bane of Aulis",
		desc="my visions scattered/the ancient god slain, trembling/i obscure the blade",
		effect="+BP based on skill in all speed tiers (Max 850)",
		is_consumable=false,
		is_marathon=false,
		img="baneofaulis.png",
		action=function() end
	},
	{
		id=73,
		name="Mehrunes' Razor",
		desc="Daedric artifact that can instantly maim an opponent.",
		effect="+100 BP for 260 BPM songs & +450 BP & 1/3 chance of forced life 1",
		is_consumable=true,
		is_marathon=false,
		img="mehrunesrazor.png",
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				math.randomseed(os.time())
				if math.random() < 1.0/3.0 then
					local cur_life_scale = PREFSMAN:GetPreference("LifeDifficultyScale")
					if cur_life_scale == 1.0 or (cur_life_scale ~= 1.0 and cur_life_scale < 1.6) then
						PREFSMAN:SetPreference("LifeDifficultyScale", 1.6)
						SM("Set to Life 1")
					end
				end
			end
		end
	},
	{
		id=74,
		name="Gungnir",
		desc="Enchanted spear that supposedly never misses its mark.  Maximum effectiveness against fast opponents.",
		effect="+100 BP for 270 BPM songs & Lv. 5 DP Bonus & 1/3 chance of forced life 3",
		is_consumable=true,
		is_marathon=false,
		img="gungnir.png",
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEquipRelics" then
				math.randomseed(os.time())
				if math.random() < 1.0/3.0 then
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
		id=75,
		name="Armajejjon",
		desc="Deadly scythe once wielded by CardboardBox in the struggle against Trails III.",
		effect="+700 BP & 30 seconds removed from break timer",
		is_consumable=false,
		is_marathon=false,
		img="armajejjon.png",
		action=function()
			if SCREENMAN:GetTopScreen():GetName() == "ScreenEvaluationStage" then
				ECS.BreakTimer = ECS.BreakTimer - 30
			end
		end
	},
	{
		id=76,
		name="Spiral of Aulis",
		desc="feigning a brave face/to pierce my cloying weakness/i process the corpse",
		effect="+350 BP & Lv. 5 DP Bonus & Forces 1.02x rate",
		is_consumable=false,
		is_marathon=false,
		img="spiralofaulis.png",
		action=function()
			GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):MusicRate(1.02)
		end
	},
	{
		id=77,
		name="Markuksen Kirves",
		desc="Hippaheikki's legendary axe!",
		effect="+300 BP & -50 BP per speed tier past 200 on this song",
		is_consumable=true,
		is_marathon=false,
		img="markuksenkirves.png",
		action=function() end
	},
	{
		id=78,
		name="Arrow Vortex",
		desc="A specialty weapon from Dutch Coast Stamina.  ",
		effect="At end of set, +BP equal to total steps of passed songs divided by 75",
		is_consumable=true,
		is_marathon=false,
		img="arrowvortex.png",
		action=function() end
	},
	{
		id=79,
		name="Baguette",
		desc="A week old baguette.",
		effect="Lv. 5 RP Bonus on any French Coast Stamina or BaguetteStreamz songs",
		is_consumable=false,
		is_marathon=false,
		img="baguette.png",
		action=function() end
	},
	{
		id=80,
		name="Boomerang",
		desc="A traditional weapon from East Coast Straya, though you probably suck at throwing a boomerang so you only get to use this once.",
		effect="At end of set, +75 BP for each pass sharing this song's difficulty rating",
		is_consumable=true,
		is_marathon=false,
		img="boomerang.png",
		action=function() end
	},
	{
		id=81,
		name="Black Robes Eternal",
		desc="For some reason, just the sight of these robes pisses you off.",
		effect="Lv. 4 EP Bonus for charts by Archi",
		is_consumable=true,
		is_marathon=false,
		img="blackrobeseternal.png",
		action=function() end
	},
	{
		id=82,
		name="Rolling Black Robes",
		desc="You can really feel the bass in these robes.",
		effect="Lv. 4 EP/AP Bonus for charts by @@",
		is_consumable=true,
		is_marathon=false,
		img="rollingblackrobes.png",
		action=function() end
	},
	{
		id=83,
		name="Accented Black Robes",
		desc="I guess they probably don't sound like they have an accent if you're from East Coast Straya.",
		effect="Lv. 4 DP/EP Bonus for charts by Zaia",
		is_consumable=true,
		is_marathon=false,
		img="accentedblackrobes.png",
		action=function() end
	},
	{
		id=84,
		name="Black Robes With Extra Cheese",
		desc="Causes destruction to certain Peruvians, too.",
		effect="Lv. 4 DP Bonus for charts by Aoreo",
		is_consumable=true,
		is_marathon=false,
		img="blackrobeswithextracheese.png",
		action=function() end
	},
	{
		id=85,
		name="Trailing Black Robes",
		desc="These robes are literally finished.",
		effect="Lv. 4 RP Bonus for charts by Arvin",
		is_consumable=true,
		is_marathon=false,
		img="trailingblackrobes.png",
		action=function() end
	},
	{
		id=86,
		name="Black Robes En Francais",
		desc="You probably can't understand what these robes are saying unless you speak French.",
		effect="Lv. 4 EP/RP Bonus for charts by Rems",
		is_consumable=true,
		is_marathon=false,
		img="blackrobesenfrancais.png",
		action=function() end
	},
	{
		id=87,
		name="Yung Black Robes",
		desc="meep",
		effect="Lv. 4 DP/AP Bonus for charts by ITGAlex",
		is_consumable=true,
		is_marathon=false,
		img="yungblackrobes.png",
		action=function() end
	},
	{
		id=88,
		name="Claiomh Solais",
		desc="Powerful sword previously wielded by Raevous Archengrove.  Contains the essence of sacred fire and is extremely effective against abominations.",
		effect="+2000 MP",
		is_consumable=false,
		is_marathon=true,
		img="claiomhsolais.png",
		action=function() end
	},
	{
		id=89,
		name="Aegis",
		desc="The shield of Raevous Archengrove.  Very effective protection against various opponents.",
		effect="Forces life 3",
		is_consumable=true,
		is_marathon=false,
		img="aegis.png",
		action=function() end
	},
	{
		id=90,
		name="Throne",
		desc="Invalid Draoineach's loyal familiar.  Will come to your aid in your greatest time of need.",
		effect="Forces life 3",
		is_consumable=true,
		is_marathon=true,
		img="throne.png",
		action=function() end
	},
	{
		id=91,
		name="Pandemonium Zero",
		desc="Forged by the Godfather in Chimney Rock on the Misty Moor, this weapon grows in strength alongside its wielder.",
		effect="+BP based off of EXP (Max 600)",
		is_consumable=false,
		is_marathon=false,
		img="pandemoniumzero.png",
		action=function() end
	},
	{
		id=92,
		name="Staminadventurer's License",
		desc="Document issued by the Stamina Corps to prospective staminadventurers in Stamina Nation.",
		effect="None",
		is_consumable=false,
		is_marathon=false,
		img="staminadventurerslicense.png",
		action=function() end
	},
	{
		id=93,
		name="Slime Badge",
		desc="A cheaply made badge presented to you by the Stamina Corps for services rendered.",
		effect="At end of set, +100 BP for each song with a different speed tier",
		is_consumable=true,
		is_marathon=false,
		img="slimebadge.png",
		action=function() end
	},
	{
		id=94,
		name="Bronze Trophy",
		desc="The Stamina Corps awards these trophies to fledgling staminadventurers as thanks for their good deeds.",
		effect="None",
		is_consumable=false,
		is_marathon=false,
		img="bronzetrophy.png",
		action=function() end
	},
	{
		id=95,
		name="Golden Stopwatch",
		desc="Ornate stopwatch imbued with powerful time magic.",
		effect="90 seconds added to break timer",
		is_consumable=true,
		is_marathon=false,
		img="goldenstopwatch.png",
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
		id=96,
		name="Mythril Trophy",
		desc="A trophy made from a rare metal.  Only given to those who have made substantial contributions to the Stamina Nation.",
		effect="None",
		is_consumable=false,
		is_marathon=false,
		img="mythriltrophy.png",
		action=function() end
	},
	{
		id=97,
		name="Arvin's Gambit",
		desc="Deck of cards once owned by one of the Godfather's closest friends.",
		effect="If equipped, and you fail the marathon, you may reattempt it immediately with up to 20 additional minutes to warm up/fix the pads.",
		is_consumable=true,
		is_marathon=true,
		img="arvinsgambit.png",
		action=function() end
	},
	{
		id=98,
		name="Crystal Trophy",
		desc="Awarded to high class staminadventurers for exceptional achievements.",
		effect="None",
		is_consumable=false,
		is_marathon=false,
		img="crystaltrophy.png",
		action=function() end
	},
	{
		id=99,
		name="Order of Ambrosia",
		desc="The greatest of honors bestowed upon staminadventurers.",
		effect="Allows user to equip an additional two relics",
		is_consumable=true,
		is_marathon=false,
		img="orderofambrosia.png",
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

ECS.Players["CardboardBox"] = {
	isupper = true,
	relics = {
		{name="Iron Sword"},
		{name="Mythril Sword"},
		{name="Bronze Dagger"},
		{name="Iron Dagger"},
		{name="Mythril Dagger"},
		{name="Bronze Axe"},
		{name="Iron Axe"},
		{name="Mythril Axe"},
		{name="Bronze Flail"},
		{name="Iron Flail"},
		{name="Mythril Flail"},
		{name="Bronze Rapier"},
		{name="Iron Rapier"},
		{name="Mythril Rapier"},
		{name="Silver Stopwatch",	quantity=4},
		{name="Astral Earring",		quantity=4},
		{name="Diamond Blade"},
		{name="Mammon"},
		{name="Lance of Longinus"},
		{name="ECS Hat",			quantity=4},
		{name="Champion Belt",		quantity=4},
		{name="Tattered Mario",		quantity=4},
		{name="Contemporary Mario",	quantity=4},
		{name="Mario For Business",	quantity=4},
		{name="Calamity Mario"},
		{name="Maria Plush"},
		{name="Broadsword"},
		{name="Tainted Broadsword"},
		{name="Fiery Broadsword"},
		{name="Steel Wool"},
		{name="Blade"},
		{name="Max Blade"},
		{name="The Green Book"},
		{name="The Postcard"},
		{name="Perish"},
		{name="Sword, Made of Steel"},
		{name="Pendulum Blade"},
		{name="Pendulum Blade +"},
		{name="La Baguette de la Discorde",		quantity=4},
		{name="Vampiric Longsword"},
		{name="Skull Ring",				quantity=4},
		{name="Astral Ring",			quantity=4},
		{name="Protect Ring",			quantity=4},
		{name="Lapis Fly Wing Rapier",	quantity=4},
		{name="Jewel Knuckles",			quantity=4},
		{name="Warhammer"},
		{name="Morning Star",			quantity=4},
		{name="Flamberge",				quantity=4},
		{name="Wizard Rod",				quantity=4},
		{name="Gaia Hammer",			quantity=4},
		{name="Zweihander",				quantity=4},
		{name="Excalipur",				quantity=4},
		{name="Kotetsu"},
		{name="Gale Bow",				quantity=4},
		{name="Osafune",				quantity=4},
		{name="Vorpal Blade"},
		{name="Mage Masher",			quantity=4},
		{name="Kain's Lance",			quantity=4},
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
		{name="Bane of Aulis"},
		{name="Mehrunes' Razor",		quantity=4},
		{name="Gungnir",				quantity=4},
		{name="Armajejjon"},
		{name="Spiral of Aulis"},
		{name="Markuksen Kirves",		quantity=4},
		{name="Arrow Vortex",			quantity=4},
		{name="Baguette"},
		{name="Boomerang",				quantity=4},
		{name="Black Robes Eternal",	quantity=4},
		{name="Rolling Black Robes",	quantity=4},
		{name="Accented Black Robes",	quantity=4},
		{name="Black Robes With Extra Cheese",		quantity=4},
		{name="Trailing Black Robes",	quantity=4},
		{name="Black Robes En Francais",quantity=4},
		{name="Yung Black Robes",		quantity=4},
		{name="Claiomh Solais"},
		{name="Aegis",					quantity=4},
		{name="Throne",					quantity=4},
		{name="Pandemonium Zero"},
		{name="Staminadventurer's License"},
		{name="Slime Badge",			quantity=4},
		{name="Bronze Trophy"},
		{name="Golden Stopwatch",		quantity=4},
		{name="Mythril Trophy"},
		{name="Arvin's Gambit",			quantity=4},
		{name="Crystal Trophy"},
		{name="Order of Ambrosia",		quantity=4},
	}
}

ECS.Players["Rust"] = {
	isupper=true,
	relics = {
		{name="Tattered Mario",			quantity=1},
		{name="Contemporary Mario",			quantity=1},
		{name="Mario For Business",			quantity=1},
		{name="Calamity Mario"},
		{name="Fiery Broadsword"},
		{name="Max Blade"},
		{name="The Green Book"},
		{name="The Postcard"},
		{name="Perish"},
		{name="Sword, Made of Steel"},
		{name="Pendulum Blade"},
		{name="Pendulum Blade +"},
		{name="La Baguette de la Discorde",			quantity=1},
		{name="Vampiric Longsword"},
		{name="Skull Ring",			quantity=1},
		{name="Astral Ring",			quantity=1},
		{name="Protect Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Jewel Knuckles",			quantity=1},
		{name="Warhammer"},
		{name="Morning Star",			quantity=1},
		{name="Flamberge",			quantity=1},
		{name="Wizard Rod",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Zweihander",			quantity=1},
		{name="Excalipur",			quantity=1},
		{name="Kotetsu"},
		{name="Gale Bow",			quantity=1},
		{name="Osafune",			quantity=1},
		{name="Vorpal Blade"},
		{name="Mage Masher",			quantity=1},
		{name="Kain's Lance",			quantity=1},
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
		{name="Mehrunes' Razor",			quantity=1},
		{name="Gungnir",			quantity=1},
		{name="Armajejjon"},
		{name="Spiral of Aulis"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Boomerang",			quantity=1},
		{name="Black Robes Eternal",			quantity=1},
		{name="Rolling Black Robes",			quantity=1},
		{name="Accented Black Robes",			quantity=1},
		{name="Black Robes With Extra Cheese",			quantity=1},
		{name="Trailing Black Robes",			quantity=1},
		{name="Black Robes En Francais",			quantity=1},
		{name="Yung Black Robes",			quantity=1},
		{name="Claiomh Solais"},
		{name="Aegis",			quantity=1},
		{name="Throne",			quantity=1},
		{name="Pandemonium Zero"},
		{name="Staminadventurer's License"},
		{name="Slime Badge",			quantity=1},
		{name="Bronze Trophy"},
		{name="Golden Stopwatch",			quantity=1},
		{name="Mythril Trophy"},
		{name="Arvin's Gambit",			quantity=1},
		{name="Crystal Trophy"},
		{name="Order of Ambrosia",			quantity=1},
	}
}

ECS.Players["nico"] = {
	isupper=true,
	relics = {
		{name="Silver Stopwatch",			quantity=6},
		{name="Lance of Longinus"},
		{name="ECS Hat",			quantity=1},
		{name="Tattered Mario",			quantity=1},
		{name="Contemporary Mario",			quantity=1},
		{name="Mario For Business",			quantity=1},
		{name="Calamity Mario"},
		{name="Maria Plush"},
		{name="Fiery Broadsword"},
		{name="Max Blade"},
		{name="The Postcard"},
		{name="Sword, Made of Steel"},
		{name="Pendulum Blade"},
		{name="Pendulum Blade +"},
		{name="La Baguette de la Discorde",			quantity=1},
		{name="Vampiric Longsword"},
		{name="Skull Ring",			quantity=1},
		{name="Astral Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Jewel Knuckles",			quantity=1},
		{name="Warhammer"},
		{name="Morning Star",			quantity=1},
		{name="Wizard Rod",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Zweihander",			quantity=1},
		{name="Excalipur",			quantity=1},
		{name="Gale Bow",			quantity=1},
		{name="Osafune",			quantity=1},
		{name="Vorpal Blade"},
		{name="Mage Masher",			quantity=1},
		{name="Kain's Lance",			quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Twisted Bow"},
		{name="Masamune"},
		{name="Bane of Aulis"},
		{name="Mehrunes' Razor",			quantity=1},
		{name="Gungnir",			quantity=1},
		{name="Armajejjon"},
		{name="Spiral of Aulis"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Boomerang",			quantity=1},
		{name="Black Robes Eternal",			quantity=1},
		{name="Rolling Black Robes",			quantity=1},
		{name="Accented Black Robes",			quantity=1},
		{name="Black Robes With Extra Cheese",			quantity=1},
		{name="Trailing Black Robes",			quantity=1},
		{name="Black Robes En Francais",			quantity=1},
		{name="Yung Black Robes",			quantity=1},
		{name="Claiomh Solais"},
		{name="Aegis",			quantity=1},
		{name="Throne",			quantity=1},
		{name="Pandemonium Zero"},
		{name="Staminadventurer's License"},
		{name="Slime Badge",			quantity=1},
		{name="Bronze Trophy"},
		{name="Golden Stopwatch",			quantity=1},
		{name="Mythril Trophy"},
		{name="Arvin's Gambit",			quantity=1},
		{name="Crystal Trophy"},
	}
}

ECS.Players["SoftTofu"] = {
	isupper=true,
	relics = {
		{name="Silver Stopwatch",			quantity=7},
		{name="Astral Earring",			quantity=7},
		{name="Mammon"},
		{name="Lance of Longinus"},
		{name="Tattered Mario",			quantity=1},
		{name="Contemporary Mario",			quantity=1},
		{name="Mario For Business",			quantity=1},
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
		{name="Skull Ring",			quantity=1},
		{name="Astral Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Jewel Knuckles",			quantity=1},
		{name="Warhammer"},
		{name="Morning Star",			quantity=1},
		{name="Flamberge",			quantity=1},
		{name="Wizard Rod",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Zweihander",			quantity=1},
		{name="Excalipur",			quantity=1},
		{name="Kotetsu"},
		{name="Gale Bow",			quantity=1},
		{name="Osafune",			quantity=1},
		{name="Mage Masher",			quantity=1},
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
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Boomerang",			quantity=1},
		{name="Black Robes Eternal",			quantity=1},
		{name="Rolling Black Robes",			quantity=1},
		{name="Accented Black Robes",			quantity=1},
		{name="Black Robes With Extra Cheese",			quantity=1},
		{name="Trailing Black Robes",			quantity=1},
		{name="Black Robes En Francais",			quantity=1},
		{name="Yung Black Robes",			quantity=1},
		{name="Claiomh Solais"},
		{name="Aegis",			quantity=1},
		{name="Throne",			quantity=1},
		{name="Pandemonium Zero"},
		{name="Staminadventurer's License"},
		{name="Slime Badge",			quantity=1},
		{name="Bronze Trophy"},
		{name="Golden Stopwatch",			quantity=1},
		{name="Mythril Trophy"},
	}
}

ECS.Players["rawinput"] = {
	isupper=true,
	relics = {
		{name="Bronze Sword"},
		{name="Bronze Dagger"},
		{name="Bronze Axe"},
		{name="Bronze Flail"},
		{name="Bronze Rapier"},
		{name="Astral Earring",			quantity=7},
		{name="ECS Hat",			quantity=6},
		{name="Tattered Mario",			quantity=1},
		{name="Contemporary Mario",			quantity=1},
		{name="Mario For Business",			quantity=1},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Pendulum Blade"},
		{name="Skull Ring",			quantity=1},
		{name="Astral Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Warhammer"},
		{name="Morning Star",			quantity=1},
		{name="Flamberge",			quantity=1},
		{name="Wizard Rod",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Zweihander",			quantity=1},
		{name="Excalipur",			quantity=1},
		{name="Gale Bow",			quantity=1},
		{name="Osafune",			quantity=1},
		{name="Mage Masher",			quantity=1},
		{name="Kain's Lance",			quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Serp i Molot"},
		{name="Pandemonium"},
		{name="Twisted Bow"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Boomerang",			quantity=1},
		{name="Black Robes Eternal",			quantity=1},
		{name="Accented Black Robes",			quantity=1},
		{name="Black Robes En Francais",			quantity=1},
		{name="Yung Black Robes",			quantity=1},
	}
}

ECS.Players["milkopia"] = {
	isupper=true,
	relics = {
		{name="Bronze Sword"},
		{name="Bronze Dagger"},
		{name="Bronze Axe"},
		{name="Bronze Flail"},
		{name="Bronze Rapier"},
		{name="Silver Stopwatch",			quantity=2},
		{name="Astral Earring",			quantity=2},
		{name="ECS Hat",			quantity=1},
		{name="Tattered Mario",			quantity=1},
		{name="Contemporary Mario",			quantity=1},
		{name="Mario For Business",			quantity=1},
		{name="Tainted Broadsword"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Wizard Rod",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Zweihander",			quantity=1},
		{name="Excalipur",			quantity=1},
		{name="Gale Bow",			quantity=1},
		{name="Osafune",			quantity=1},
		{name="Mage Masher",			quantity=1},
		{name="Colada"},
		{name="Twisted Bow"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Boomerang",			quantity=1},
		{name="Yung Black Robes",			quantity=1},
	}
}

ECS.Players["Archi"] = {
	isupper=true,
	relics = {
		{name="Silver Stopwatch",			quantity=3},
		{name="Diamond Blade"},
		{name="Mammon"},
		{name="ECS Hat",			quantity=1},
		{name="Tattered Mario",			quantity=1},
		{name="Contemporary Mario",			quantity=1},
		{name="Mario For Business",			quantity=1},
		{name="Maria Plush"},
		{name="Fiery Broadsword"},
		{name="Max Blade"},
		{name="The Green Book"},
		{name="The Postcard"},
		{name="Perish"},
		{name="Sword, Made of Steel"},
		{name="Skull Ring",			quantity=1},
		{name="Astral Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Jewel Knuckles",			quantity=1},
		{name="Warhammer"},
		{name="Morning Star",			quantity=1},
		{name="Flamberge",			quantity=1},
		{name="Wizard Rod",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Zweihander",			quantity=1},
		{name="Excalipur",			quantity=1},
		{name="Gale Bow",			quantity=1},
		{name="Osafune",			quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Vampire Killer"},
		{name="Pandemonium"},
		{name="Mjolnir"},
		{name="Caladbolg"},
		{name="Excalibur II"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Boomerang",			quantity=1},
		{name="Rolling Black Robes",			quantity=1},
		{name="Accented Black Robes",			quantity=1},
		{name="Black Robes With Extra Cheese",			quantity=1},
		{name="Trailing Black Robes",			quantity=1},
		{name="Black Robes En Francais",			quantity=1},
		{name="Yung Black Robes",			quantity=1},
		{name="Staminadventurer's License"},
		{name="Slime Badge",			quantity=1},
		{name="Bronze Trophy"},
		{name="Golden Stopwatch",			quantity=1},
	}
}

ECS.Players["hippaheikki"] = {
	isupper=true,
	relics = {
		{name="Silver Stopwatch",			quantity=3},
		{name="Astral Earring",			quantity=1},
		{name="Tattered Mario",			quantity=1},
		{name="Contemporary Mario",			quantity=1},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Warhammer"},
		{name="Morning Star",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Zweihander",			quantity=1},
		{name="Excalipur",			quantity=1},
		{name="Gale Bow",			quantity=1},
		{name="Osafune",			quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Boomerang",			quantity=1},
		{name="Staminadventurer's License"},
		{name="Slime Badge",			quantity=1},
	}
}

ECS.Players["Bran"] = {
	isupper=true,
	relics = {
		{name="Silver Stopwatch",			quantity=2},
		{name="Diamond Blade"},
		{name="Mammon"},
		{name="Lance of Longinus"},
		{name="ECS Hat",			quantity=1},
		{name="Tattered Mario",			quantity=1},
		{name="Contemporary Mario",			quantity=1},
		{name="Mario For Business",			quantity=1},
		{name="Maria Plush"},
		{name="Fiery Broadsword"},
		{name="Max Blade"},
		{name="The Green Book"},
		{name="The Postcard"},
		{name="Sword, Made of Steel"},
		{name="Skull Ring",			quantity=1},
		{name="Astral Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Jewel Knuckles",			quantity=1},
		{name="Warhammer"},
		{name="Morning Star",			quantity=1},
		{name="Wizard Rod",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Zweihander",			quantity=1},
		{name="Excalipur",			quantity=1},
		{name="Gale Bow",			quantity=1},
		{name="Osafune",			quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Boomerang",			quantity=1},
		{name="Accented Black Robes",			quantity=1},
		{name="Black Robes With Extra Cheese",			quantity=1},
		{name="Black Robes En Francais",			quantity=1},
		{name="Yung Black Robes",			quantity=1},
		{name="Staminadventurer's License"},
		{name="Slime Badge",			quantity=1},
		{name="Bronze Trophy"},
	}
}

ECS.Players["lil_beastling"] = {
	isupper=true,
	relics = {
		{name="Silver Stopwatch",			quantity=4},
		{name="Lance of Longinus"},
		{name="ECS Hat",			quantity=1},
		{name="Tattered Mario",			quantity=1},
		{name="Tainted Broadsword"},
		{name="Max Blade"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Warhammer"},
		{name="Morning Star",			quantity=1},
		{name="Wizard Rod",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Zweihander",			quantity=1},
		{name="Excalipur",			quantity=1},
		{name="Colada"},
		{name="Serp i Molot"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Boomerang",			quantity=1},
		{name="Staminadventurer's License"},
	}
}

ECS.Players["SteveReen"] = {
	isupper=true,
	relics = {
		{name="Mythril Axe"},
		{name="Silver Stopwatch",			quantity=6},
		{name="ECS Hat",			quantity=1},
		{name="Tattered Mario",			quantity=1},
		{name="Tainted Broadsword"},
		{name="Max Blade"},
		{name="The Green Book"},
		{name="Sword, Made of Steel"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Morning Star",			quantity=1},
		{name="Wizard Rod",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Zweihander",			quantity=1},
		{name="Excalipur",			quantity=1},
		{name="Colada"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Boomerang",			quantity=1},
		{name="Black Robes En Francais",			quantity=1},
		{name="Staminadventurer's License"},
		{name="Slime Badge",			quantity=1},
	}
}

ECS.Players["Jeremy"] = {
	isupper=true,
	relics = {
		{name="Silver Stopwatch",			quantity=1},
		{name="Astral Earring",			quantity=1},
		{name="Tattered Mario",			quantity=1},
		{name="Contemporary Mario",			quantity=1},
		{name="Tainted Broadsword"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Morning Star",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Zweihander",			quantity=1},
		{name="Excalipur",			quantity=1},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Boomerang",			quantity=1},
	}
}

ECS.Players["sudzi781"] = {
	isupper=true,
	relics = {
		{name="Mythril Dagger"},
		{name="Silver Stopwatch",			quantity=1},
		{name="Tattered Mario",			quantity=1},
		{name="Contemporary Mario",			quantity=1},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Wizard Rod",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Zweihander",			quantity=1},
		{name="Excalipur",			quantity=1},
		{name="Gale Bow",			quantity=1},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Boomerang",			quantity=1},
		{name="Black Robes Eternal",			quantity=1},
		{name="Accented Black Robes",			quantity=1},
		{name="Black Robes With Extra Cheese",			quantity=1},
	}
}

ECS.Players["JDongs"] = {
	isupper=true,
	relics = {
		{name="Champion Belt",			quantity=1},
		{name="Tattered Mario",			quantity=1},
		{name="Contemporary Mario",			quantity=1},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Sword, Made of Steel"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Morning Star",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Zweihander",			quantity=1},
		{name="Gale Bow",			quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Boomerang",			quantity=1},
		{name="Staminadventurer's License"},
	}
}

ECS.Players["TheUltravioletCatastrophe"] = {
	isupper=true,
	relics = {
		{name="Tattered Mario",			quantity=1},
		{name="Fiery Broadsword"},
		{name="Blade"},
		{name="Sword, Made of Steel"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Jewel Knuckles",			quantity=1},
		{name="Warhammer"},
		{name="Morning Star",			quantity=1},
		{name="Flamberge",			quantity=1},
		{name="Wizard Rod",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Zweihander",			quantity=1},
		{name="Excalipur",			quantity=1},
		{name="Gale Bow",			quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Fist of Tulkas"},
		{name="Serp i Molot"},
		{name="Vampire Killer"},
		{name="Whale Whisker"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Boomerang",			quantity=1},
		{name="Black Robes En Francais",			quantity=1},
		{name="Yung Black Robes",			quantity=1},
		{name="Staminadventurer's License"},
		{name="Slime Badge",			quantity=1},
		{name="Bronze Trophy"},
	}
}

ECS.Players["Koettmaskinen"] = {
	isupper=true,
	relics = {
		{name="Silver Stopwatch",			quantity=3},
		{name="Lance of Longinus"},
		{name="Fiery Broadsword"},
		{name="Blade"},
		{name="Sword, Made of Steel"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Jewel Knuckles",			quantity=1},
		{name="Warhammer"},
		{name="Morning Star",			quantity=1},
		{name="Wizard Rod",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Zweihander",			quantity=1},
		{name="Excalipur",			quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Boomerang",			quantity=1},
		{name="Black Robes En Francais",			quantity=1},
		{name="Staminadventurer's License"},
		{name="Slime Badge",			quantity=1},
		{name="Bronze Trophy"},
	}
}

ECS.Players["GIEZ"] = {
	isupper=true,
	relics = {
		{name="Mythril Flail"},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Sword, Made of Steel"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Morning Star",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Zweihander",			quantity=1},
		{name="Colada"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Boomerang",			quantity=1},
		{name="Black Robes En Francais",			quantity=1},
	}
}

ECS.Players["ITGAlex"] = {
	isupper=true,
	relics = {
		{name="Mythril Dagger"},
		{name="Silver Stopwatch",			quantity=4},
		{name="ECS Hat",			quantity=1},
		{name="Tattered Mario",			quantity=1},
		{name="Tainted Broadsword"},
		{name="Max Blade"},
		{name="Sword, Made of Steel"},
		{name="Pendulum Blade"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Morning Star",			quantity=1},
		{name="Wizard Rod",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Zweihander",			quantity=1},
		{name="Colada"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Boomerang",			quantity=1},
		{name="Black Robes Eternal",			quantity=1},
	}
}

ECS.Players["RD"] = {
	isupper=true,
	relics = {
		{name="Mythril Rapier"},
		{name="Silver Stopwatch",			quantity=4},
		{name="Astral Earring",			quantity=3},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Sword, Made of Steel"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Jewel Knuckles",			quantity=1},
		{name="Warhammer"},
		{name="Morning Star",			quantity=1},
		{name="Wizard Rod",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Zweihander",			quantity=1},
		{name="Excalipur",			quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Vampire Killer"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Boomerang",			quantity=1},
		{name="Black Robes En Francais",			quantity=1},
		{name="Staminadventurer's License"},
		{name="Slime Badge",			quantity=1},
	}
}

ECS.Players["Dr.0ctgonapus"] = {
	isupper=true,
	relics = {
		{name="Iron Axe"},
		{name="ECS Hat",			quantity=1},
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",			quantity=1},
		{name="Morning Star",			quantity=1},
		{name="Excalipur",			quantity=1},
		{name="Colada"},
	}
}

ECS.Players["Sidro"] = {
	isupper=true,
	relics = {
		{name="Silver Stopwatch",			quantity=5},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Sword, Made of Steel"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Jewel Knuckles",			quantity=1},
		{name="Warhammer"},
		{name="Morning Star",			quantity=1},
		{name="Wizard Rod",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Zweihander",			quantity=1},
		{name="Excalipur",			quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Boomerang",			quantity=1},
		{name="Black Robes En Francais",			quantity=1},
		{name="Staminadventurer's License"},
		{name="Slime Badge",			quantity=1},
		{name="Bronze Trophy"},
	}
}

ECS.Players["skateinmars"] = {
	isupper=true,
	relics = {
		{name="Silver Stopwatch",			quantity=3},
		{name="Astral Earring",			quantity=1},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Sword, Made of Steel"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Morning Star",			quantity=1},
		{name="Wizard Rod",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Zweihander",			quantity=1},
		{name="Excalipur",			quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Boomerang",			quantity=1},
		{name="Black Robes En Francais",			quantity=1},
		{name="Staminadventurer's License"},
		{name="Slime Badge",			quantity=1},
		{name="Bronze Trophy"},
	}
}

ECS.Players["Keaize"] = {
	isupper=true,
	relics = {
		{name="Bronze Sword"},
		{name="Iron Sword"},
		{name="Bronze Dagger"},
		{name="Bronze Axe"},
		{name="Iron Axe"},
		{name="Bronze Flail"},
		{name="Bronze Rapier"},
		{name="Silver Stopwatch",			quantity=1},
		{name="Lance of Longinus"},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Jewel Knuckles",			quantity=1},
		{name="Warhammer"},
		{name="Morning Star",			quantity=1},
		{name="Flamberge",			quantity=1},
		{name="Wizard Rod",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Zweihander",			quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Fist of Tulkas"},
		{name="Vampire Killer"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Boomerang",			quantity=1},
		{name="Black Robes En Francais",			quantity=1},
		{name="Staminadventurer's License"},
		{name="Slime Badge",			quantity=1},
	}
}

ECS.Players["JOKR"] = {
	isupper=false,
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
		{name="Silver Stopwatch",			quantity=1},
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Morning Star",			quantity=1},
		{name="Wizard Rod",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Zweihander",			quantity=1},
		{name="Colada"},
		{name="Baguette"},
	}
}

ECS.Players["ensypuri"] = {
	isupper=false,
	relics = {
		{name="Mythril Flail"},
		{name="Silver Stopwatch",			quantity=1},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Jewel Knuckles",			quantity=1},
		{name="Warhammer"},
		{name="Morning Star",			quantity=1},
		{name="Wizard Rod",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Vampire Killer"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Boomerang",			quantity=1},
		{name="Black Robes En Francais",			quantity=1},
		{name="Staminadventurer's License"},
		{name="Slime Badge",			quantity=1},
	}
}

ECS.Players["Yung Kiki"] = {
	isupper=false,
	relics = {
		{name="Iron Axe"},
		{name="Silver Stopwatch",			quantity=1},
		{name="Astral Earring",			quantity=2},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Skull Ring",			quantity=1},
		{name="Morning Star",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Boomerang",			quantity=1},
		{name="Black Robes En Francais",			quantity=1},
	}
}

ECS.Players["lolipo"] = {
	isupper=false,
	relics = {
		{name="ECS Hat",			quantity=1},
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Morning Star",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Baguette"},
	}
}

ECS.Players["sefirot"] = {
	isupper=false,
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
		{name="Skull Ring",			quantity=1},
		{name="Morning Star",			quantity=1},
		{name="Wizard Rod",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Boomerang",			quantity=1},
	}
}

ECS.Players["Andkaseywaslike"] = {
	isupper=false,
	relics = {
		{name="Iron Sword"},
		{name="Iron Dagger"},
		{name="Iron Axe"},
		{name="Iron Flail"},
		{name="Iron Rapier"},
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Jewel Knuckles",			quantity=1},
		{name="Morning Star",			quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Fist of Tulkas"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Staminadventurer's License"},
	}
}

ECS.Players["zxevik"] = {
	isupper=false,
	relics = {
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Jewel Knuckles",			quantity=1},
		{name="Morning Star",			quantity=1},
		{name="Wizard Rod",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Zweihander",			quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Boomerang",			quantity=1},
		{name="Staminadventurer's License"},
	}
}

ECS.Players["Rems"] = {
	isupper=false,
	relics = {
		{name="Iron Sword"},
		{name="Bronze Dagger"},
		{name="Bronze Axe"},
		{name="Bronze Flail"},
		{name="ECS Hat",			quantity=1},
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Morning Star",			quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
	}
}

ECS.Players["Kev"] = {
	isupper=false,
	relics = {
		{name="Bronze Sword"},
		{name="Bronze Dagger"},
		{name="Iron Dagger"},
		{name="Bronze Axe"},
		{name="Bronze Flail"},
		{name="Iron Flail"},
		{name="Bronze Rapier"},
		{name="Iron Rapier"},
		{name="Silver Stopwatch",			quantity=1},
		{name="Astral Earring",			quantity=1},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Jewel Knuckles",			quantity=1},
		{name="Morning Star",			quantity=1},
		{name="Wizard Rod",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Fist of Tulkas"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Boomerang",			quantity=1},
		{name="Staminadventurer's License"},
	}
}

ECS.Players["dominick"] = {
	isupper=false,
	relics = {
		{name="Mythril Sword"},
		{name="Mythril Flail"},
		{name="Silver Stopwatch",			quantity=3},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Jewel Knuckles",			quantity=1},
		{name="Warhammer"},
		{name="Morning Star",			quantity=1},
		{name="Wizard Rod",			quantity=1},
		{name="Gaia Hammer",			quantity=1},
		{name="Zweihander",			quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Fist of Tulkas"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Boomerang",			quantity=1},
		{name="Black Robes En Francais",			quantity=1},
		{name="Staminadventurer's License"},
		{name="Slime Badge",			quantity=1},
	}
}

ECS.Players["teejusb"] = {
	isupper=false,
	relics = {
		{name="Bronze Axe"},
		{name="Iron Axe"},
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Jewel Knuckles",			quantity=1},
		{name="Morning Star",			quantity=1},
		{name="Colada"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Staminadventurer's License"},
	}
}

ECS.Players["Janus5k"] = {
	isupper=false,
	relics = {
		{name="Bronze Sword"},
		{name="Bronze Dagger"},
		{name="Bronze Axe"},
		{name="Iron Axe"},
		{name="Bronze Flail"},
		{name="Iron Flail"},
		{name="Bronze Rapier"},
		{name="Silver Stopwatch",			quantity=1},
		{name="Astral Earring",			quantity=1},
		{name="Tainted Broadsword"},
		{name="Blade"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Jewel Knuckles",			quantity=1},
		{name="Morning Star",			quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Boomerang",			quantity=1},
		{name="Staminadventurer's License"},
	}
}

ECS.Players["Xynn"] = {
	isupper=false,
	relics = {
		{name="Bronze Sword"},
		{name="Iron Sword"},
		{name="Bronze Dagger"},
		{name="Iron Axe"},
		{name="Bronze Flail"},
		{name="Bronze Rapier"},
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Jewel Knuckles",			quantity=1},
		{name="Morning Star",			quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Fist of Tulkas"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Staminadventurer's License"},
	}
}

ECS.Players["Made"] = {
	isupper=false,
	relics = {
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Jewel Knuckles",			quantity=1},
		{name="Warhammer"},
		{name="Morning Star",			quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Fist of Tulkas"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Staminadventurer's License"},
	}
}

ECS.Players["TYLR"] = {
	isupper=false,
	relics = {
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Morning Star",			quantity=1},
		{name="Colada"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Staminadventurer's License"},
	}
}

ECS.Players["VincentITG"] = {
	isupper=false,
	relics = {
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",			quantity=1},
		{name="Morning Star",			quantity=1},
	}
}

ECS.Players["aminuteawayx"] = {
	isupper=false,
	relics = {
		{name="Bronze Sword"},
		{name="Bronze Dagger"},
		{name="Bronze Axe"},
		{name="Iron Axe"},
		{name="Bronze Flail"},
		{name="Bronze Rapier"},
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Jewel Knuckles",			quantity=1},
		{name="Morning Star",			quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
		{name="Staminadventurer's License"},
	}
}

ECS.Players["I_ONLY_PLAY_BOARD_GAMES_NOW"] = {
	isupper=false,
	relics = {
		{name="Bronze Sword"},
		{name="Bronze Dagger"},
		{name="Broadsword"},
		{name="Morning Star",			quantity=1},
		{name="Colada"},
	}
}

ECS.Players["pinkloon"] = {
	isupper=false,
	relics = {
		{name="Broadsword"},
		{name="Blade"},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Colada"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
	}
}

ECS.Players["Sal!V2"] = {
	isupper=false,
	relics = {
		{name="Broadsword"},
		{name="Blade"},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Morning Star",			quantity=1},
		{name="Colada"},
	}
}

ECS.Players["Chief Skittles"] = {
	isupper=false,
	relics = {
		{name="Iron Rapier"},
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Morning Star",			quantity=1},
		{name="Colada"},
		{name="Markuksen Kirves",			quantity=1},
	}
}

ECS.Players["IKA3K"] = {
	isupper=false,
	relics = {
		{name="Iron Rapier"},
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Morning Star",			quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",			quantity=1},
	}
}

ECS.Players["HOT TAKE"] = {
	isupper=false,
	relics = {
		{name="Broadsword"},
		{name="Blade"},
		{name="Colada"},
	}
}

ECS.Players["Redzone"] = {
	isupper=false,
	relics = {
		{name="Bronze Sword"},
		{name="Bronze Dagger"},
		{name="Bronze Axe"},
		{name="Bronze Flail"},
		{name="Bronze Rapier"},
		{name="Broadsword"},
		{name="Blade"},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
	}
}

ECS.Players["Kyy"] = {
	isupper=false,
	relics = {
		{name="Bronze Sword"},
		{name="Bronze Dagger"},
		{name="Bronze Axe"},
		{name="Bronze Flail"},
		{name="Broadsword"},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Colada"},
		{name="Joyeuse"},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Staminadventurer's License"},
	}
}

ECS.Players["Sereni"] = {
	isupper=false,
	relics = {
		{name="Iron Rapier"},
		{name="Broadsword"},
		{name="Blade"},
		{name="Skull Ring",			quantity=1},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Morning Star",			quantity=1},
		{name="Markuksen Kirves",			quantity=1},
		{name="Arrow Vortex",			quantity=1},
		{name="Baguette"},
	}
}

ECS.Players["@@"] = {
	isupper=false,
	relics = {
		{name="Broadsword"},
		{name="Colada"},
	}
}

ECS.Players["AV6"] = {
	isupper=false,
	relics = {
		{name="Broadsword"},
	}
}

ECS.Players["Pluto"] = {
	isupper=false,
	relics = {
		{name="Broadsword"},
		{name="Blade"},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Colada"},
		{name="Markuksen Kirves",			quantity=1},
	}
}

ECS.Players["tom no bar"] = {
	isupper=false,
	relics = {
		{name="Broadsword"},
		{name="Blade"},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Colada"},
	}
}

ECS.Players["robbumon"] = {
	isupper=false,
	relics = {
		{name="Bronze Sword"},
		{name="Bronze Dagger"},
		{name="Bronze Axe"},
		{name="Bronze Flail"},
		{name="Bronze Rapier"},
		{name="Broadsword"},
		{name="Blade"},
		{name="Lapis Fly Wing Rapier",			quantity=1},
		{name="Colada"},
	}
}

ECS.Players["rynker"] = {
	isupper=false,
	relics = {
		{name="Champion Belt",			quantity=1},
		{name="Broadsword"},
		{name="Blade"},
	}
}

ECS.Players["StoryTime"] = {
	isupper=false,
	relics = {
		{name="Broadsword"},
		{name="Colada"},
	}
}

ECS.Players["titandude21"] = {
	isupper=false,
	relics = {
	}
}

ECS.Players["DMAC"] = {
	isupper=false,
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
	relics = {
	}
}

InitializeECS()