local vec3f = require 'vec-ffi.vec3f'
local Item = require 'zelda.item.item'

local ItemSword = Item:subclass()

ItemSword.name = 'sword'
ItemSword.sprite = 'fakeitem'
ItemSword.seq = 'item_sword'

-- static method
function ItemSword:useInInventory(player)
	local game = player.game
	local map = player.map

	if player.attackEndTime >= game.time then return end
	player.swingPos = vec3f(player.pos.x, player.pos.y, player.pos.z + .7)
	player.attackTime = game.time
	player.attackEndTime = game.time + player.attackDuration

	-- see if we hit anyone
	-- TODO iterate through all blocks within some range around us ...
	-- then iterate over their objs ...
	-- TODO TODO just do traceline
	for _,obj in ipairs(map.objs) do
		if not obj.removeFlag
		and obj ~= player 
		and obj.takesDamage
		and not obj.dead
		then
			local attackDist = 2	-- should match rFar in the draw code.  TODO as well consider object bbox / bounding radius.
			if (player.pos - obj.pos):lenSq() < attackDist*attackDist then
				obj:damage(1, player, self)
			end
		end
	end
end

return ItemSword 
