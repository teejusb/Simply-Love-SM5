import csv
import json

PREFIX = "srpg9"

def GetDivision(tplp, id):
	mid_overrides = [
		66364,
		132065,
		75645
	]
	upper_overrides = [
		77437
	]
	mid_cutoff = 22500
	upper_cutooff = 140000

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
	print(r"""	id=%s,""" % player[f"{PREFIX}_entrants_member_id"])
	print(r"""	division="%s",""" % (GetDivision(int(player[f"{PREFIX}_entrants_tplp"]), int(player[f"{PREFIX}_entrants_member_id"]))))
	print(r"""	opted_for_speed=%s,""" % (OptedForSpeed(int(player[f"{PREFIX}_entrants_tp"])) and "true" or "false"))
	print(r"""	country="%s",""" % player["COUNTRY"])
	print(r"""	level=%s,""" % player[f"{PREFIX}_entrants_level"])
	print(r"""	exp=%s,""" % player[f"{PREFIX}_entrants_exp"])
	print(r"""	relics = {""")

	relic_count = json.loads(player["RELIC_COUNT"])

	for i, relic in enumerate(relic_count):
		quantity = relic[str(i)]
		if quantity > 0:
			print(r"""		{name="%s", quantity=%d},""" % (relics[str(i)], quantity))
	print(r"""	},""")
	print(r"""	tier_skill = {%s},""" % ", ".join(["[%d]=%s" % (x, player[f"{PREFIX}_entrants_%dskill" % x]) for x in range(120, 320, 10)])) # [120, 310]
	print(r"""	affinities = {%s},""" % ", ".join("%s=%s" % (name, player[f"{PREFIX}_entrants_aff%s" % name]) for name in ["dp", "ep", "rp", "ap"]))
	print(r"""	lifetime_song_gold = %s,""" % player[f"{PREFIX}_entrants_rankgold"])
	print(r"""	lifetime_jp = %s,""" % player[f"{PREFIX}_entrants_rankjp"])
	print(r"""}""")
	print(r"")
