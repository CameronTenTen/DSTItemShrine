
PrefabFiles = {"scorershrine"}
-- can be spawned with c_spawn("scorershrine")

AddPrefabPostInit("scorershrine", function (inst)
	if GLOBAL.TheWorld.ismastersim then
		inst.ANNOUNCE_SUBMISSION = GetModConfigData("ANNOUNCE_SUBMISSION")
	end
end)