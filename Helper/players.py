import csv
import json

def GetDivision(rank, id):
	mid_overrides = [
		66674,
		127205,
		66413,
		5023
	]
	upper_overrides = [
		66587
	]

	if id in mid_overrides:
		return "mid"
	elif id in upper_overrides:
		return "upper"
	else:
		if rank <= 16:
			return "upper"
		elif rank <= 88:
			return "mid"
		else:
			return "lower"

def OptedForSpeed(rank):
	return rank <= 24

relics = {}
with open('relics.csv') as f:
	reader = csv.DictReader(f)
	for row in reader:
		relics[row["id"]] = row["name"]
		
with open("sqldump.json") as f:
	data = json.load(f)

for player in data:
	print(r"""ECS.Players["%s"] = {""" % player["members_name"])
	print(r"""	id=%s,""" % player["srpg7_entrants_member_id"])
	print(r"""	division="%s",""" % (GetDivision(int(player["TPLP_RANK"]), int(player["srpg7_entrants_member_id"]))))
	print(r"""	opted_for_speed=%s,""" % (OptedForSpeed(int(player["TPLP_RANK"])) and "true" or "false"))
	print(r"""	country="%s",""" % player["COUNTRY"])
	print(r"""	level=%s,""" % player["srpg7_entrants_level"])
	print(r"""	exp=%s,""" % player["srpg7_entrants_exp"])
	print(r"""	relics = {""")

	relic_count = json.loads(player["RELIC_COUNT"])

	for i, relic in enumerate(relic_count):
		quantity = relic[str(i)]
		if quantity > 0:
			print(r"""		{name="%s", quantity=%d},""" % (relics[str(i)], quantity))
	print(r"""	},""")
	print(r"""	tier_skill = {%s},""" % ", ".join(["[%d]=%s" % (x, player["srpg7_entrants_%dskill" % x]) for x in range(120, 310, 10)])) # [120, 300]
	print(r"""	affinities = {%s},""" % ", ".join("%s=%s" % (name, player["srpg7_entrants_aff%s" % name]) for name in ["dp", "ep", "rp", "ap"]))
	print(r"""	lifetime_song_gold = %s,""" % player["srpg7_entrants_rankgold"])
	print(r"""	lifetime_jp = %s,""" % player["srpg7_entrants_rankjp"])
	print(r"""}""")
	print(r"")
