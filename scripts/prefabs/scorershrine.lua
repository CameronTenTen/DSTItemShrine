local assets =
{
	Asset("ANIM", "anim/pig_king.zip"),
	Asset("SOUND", "sound/pig.fsb"),
}
-- INFO: this prefab was based off pigking.lua

local DEPLOY_BLOCKER_RADIUS = 4 -- this is 4 due to "birdblocker" hardcoding its radius
local DEPLOY_BLOCKER_SPACING = 5 -- so the diagonals overlay

local function CreateBuildingBlocker()
	local inst = CreateEntity()

	--[[Non-networked entity]]
	inst.entity:SetCanSleep(false)
	inst.persists = false

	inst.entity:AddTransform()
--[[
	-- hack for debug rendering
	inst.entity:AddPhysics()
	inst.Physics:SetMass(0)
	inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
	inst.Physics:ClearCollisionMask()
	inst.Physics:CollidesWith(COLLISION.GIANTS)
	inst.Physics:SetCylinder(DEPLOY_BLOCKER_RADIUS, 1)
]]
	inst:AddTag("NOCLICK")
	inst:AddTag("birdblocker")
	inst:AddTag("antlion_sinkhole_blocker")

	inst:SetDeployExtraSpacing(DEPLOY_BLOCKER_RADIUS)

	return inst
end

local function RemoveBuildingBlockers(inst)
	if inst._blockers ~= nil then
		for i, v in ipairs(inst._blockers) do
			v:Remove()
		end
		inst._blockers = nil
	end
end

local function AddBuildingBlockers(inst)
	if inst._blockers == nil then
		inst._blockers = {}
		local x0, y0, z0 = inst.Transform:GetWorldPosition()
		local cells_across = 3
		for x = -cells_across, cells_across do
			for z = -cells_across, cells_across do
				local blocker = CreateBuildingBlocker()
				blocker.Transform:SetPosition(x0 + x*DEPLOY_BLOCKER_SPACING, 0, z0 + z*DEPLOY_BLOCKER_SPACING)
				table.insert(inst._blockers, blocker)
			end
		end
	end
end

local function OnBlockBuildingDirty(inst)
	if inst._blockbuilding:value() then
		AddBuildingBlockers(inst)
	else
		RemoveBuildingBlockers(inst)
	end
end

--------------------------------------------------------------------------

local function OnHaunt(inst, haunter)
	if inst.components.trader ~= nil and inst.components.trader.enabled then
		OnRefuseItem(inst)
		return true
	end
	return false
end

--------------------------------------------------------------------------

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, 2, .5)

	inst.MiniMapEntity:SetIcon("pigking.png")
	inst.MiniMapEntity:SetPriority(1)

	inst.DynamicShadow:SetSize(10, 5)

	--inst.Transform:SetScale(1.5, 1.5, 1.5)

	inst.AnimState:SetBank("Pig_King")
	inst.AnimState:SetBuild("Pig_King")
	inst.AnimState:SetFinalOffset(1)

	inst.AnimState:PlayAnimation("idle", true)

	--trader (from trader component) added to pristine state for optimization
	inst:AddTag("trader")

	inst:AddTag("king")
	inst:AddTag("birdblocker")
	inst:AddTag("antlion_sinkhole_blocker")

	inst._blockbuilding = net_bool(inst.GUID, "pigking._blockbuilding", "blockbuildingdirty")

	inst.OnRemoveEntity = RemoveBuildingBlockers

	inst.entity:SetPristine()

	inst:AddComponent("talker")
	inst.components.talker.fontsize = 35
	inst.components.talker.font = TALKINGFONT
	inst.components.talker.offset = Vector3(0, -650, 0)

	if not TheWorld.ismastersim then
		inst:ListenForEvent("blockbuildingdirty", OnBlockBuildingDirty)
		return inst
	end

	inst:AddComponent("inspectable")

	-- trader will be hooked up with the exporter in the export half of this mod
	inst:AddComponent("trader")

	inst.ANNOUNCE_SUBMISSION = nil

	inst.components.trader.onaccept = function (inst, giver, item)
		inst.sg:GoToState("happy")
	 	if inst.ANNOUNCE_SUBMISSION == "global" or inst.ANNOUNCE_SUBMISSION == "both" then
			-- Does a plain "announcement" message in the chat
			TheNet:Announce(giver.name.." has submitted "..item.name.."!")
			-- Does a message in the chat with a `Server` indicator in front of it
			-- TheNet:SystemMessage(giver.name.." has submitted "..item.name.."!")
		end
		if inst.ANNOUNCE_SUBMISSION == "local" or inst.ANNOUNCE_SUBMISSION == "both" then
			inst.components.talker:Say(item.name.." Accepted!")
		end
	end
	inst.components.trader.onrefuse = function (inst, giver, item)
		inst.sg:GoToState("unimpressed")
		if inst.ANNOUNCE_SUBMISSION == "local" or inst.ANNOUNCE_SUBMISSION == "both" then
			inst.components.talker:Say(item.name.." Denied!")
		end
	end

	inst:SetStateGraph("SGpigking")

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	inst.components.hauntable:SetOnHauntFn(OnHaunt)

	return inst
end

--------------------------------------------------------------------------

return Prefab("scorershrine", fn, assets)
