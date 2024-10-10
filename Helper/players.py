import csv
import json

def GetDivision(tplp, id):
	mid_overrides = [
		132065,
		7737
	]
	upper_overrides = [
		75693
	]
	mid_cutoff = 20000
	upper_cutooff = 120000

	if id in mid_overrides:
		return "mid"
	elif id in upper_overrides:
		return "upper"
	else:
		if tplp >= upper_cutooff:
			return "upper"
		elif tplp >= mid_cutoff:
			return "mid"
		else:
			return "lower"

def OptedForSpeed(tp):
	speed_cutoff = 65000
	return tp >= speed_cutoff

relics = {}
with open('relics.csv') as f:
	reader = csv.DictReader(f)
	for row in reader:
		relics[row["relics_id"]] = row["relics_name"]
		
with open("sqldump.json") as f:
	data = json.load(f)

for player in data:
	print(r"""ECS.Players["%s"] = {""" % player["members_name"])
	print(r"""	id=%s,""" % player["srpg8_entrants_member_id"])
	print(r"""	division="%s",""" % (GetDivision(int(player["srpg8_entrants_tplp"]), int(player["srpg8_entrants_member_id"]))))
	print(r"""	opted_for_speed=%s,""" % (OptedForSpeed(int(player["srpg8_entrants_tp"])) and "true" or "false"))
	print(r"""	country="%s",""" % player["COUNTRY"])
	print(r"""	level=%s,""" % player["srpg8_entrants_level"])
	print(r"""	exp=%s,""" % player["srpg8_entrants_exp"])
	print(r"""	relics = {""")

	relic_count = json.loads(player["RELIC_COUNT"])

	for i, relic in enumerate(relic_count):
		quantity = relic[str(i)]
		if quantity > 0:
			print(r"""		{name="%s", quantity=%d},""" % (relics[str(i)], quantity))
	print(r"""	},""")
	print(r"""	tier_skill = {%s},""" % ", ".join(["[%d]=%s" % (x, player["srpg8_entrants_%dskill" % x]) for x in range(120, 320, 10)])) # [120, 310]
	print(r"""	affinities = {%s},""" % ", ".join("%s=%s" % (name, player["srpg8_entrants_aff%s" % name]) for name in ["dp", "ep", "rp", "ap"]))
	print(r"""	lifetime_song_gold = %s,""" % player["srpg8_entrants_rankgold"])
	print(r"""	lifetime_jp = %s,""" % player["srpg8_entrants_rankjp"])
	print(r"""}""")
	print(r"")
