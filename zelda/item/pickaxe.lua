-- TODO this is a close copy to zelda.item.shovel
local ffi = require 'ffi'
local vec3f = require 'vec-ffi.vec3f'
local Tile = require 'zelda.tile'
local Item = require 'zelda.item.item'

local ItemPickaxe = Item:subclass()
ItemPickaxe.classname = 'zelda.item.pickaxe'
ItemPickaxe.name = 'pickaxe'
ItemPickaxe.sprite = 'item'
ItemPickaxe.seq = 'pickaxe'

-- static method
function ItemPickaxe:useInInventory(player)
	local map = player.map
	local game = player.game

	if player.attackEndTime >= game.time then return end
	player.swingPos = vec3f(player.pos.x, player.pos.y, player.pos.z + .7)
	player.attackTime = game.time
	player.attackEndTime = game.time + player.attackDuration

	local x,y,z = (player.pos + vec3f(
		math.cos(player.angle),
		math.sin(player.angle),
		0
	)):map(math.floor):unpack()
	
	for dz=1,-1,-1 do
		local tile = map:getTile(x,y,z+dz)
		if tile
		and tile.type == Tile.typeValues.Stone
		then
			tile.type = Tile.typeValues.Empty
			map:updateLight(
				x - ffi.C.MAX_LUM,
				y - ffi.C.MAX_LUM,
				z+dz - ffi.C.MAX_LUM,
				x + ffi.C.MAX_LUM,
				y + ffi.C.MAX_LUM,
				z+dz + ffi.C.MAX_LUM)		
			-- TODO an obj for all tile types?
			player:addItem(require 'zelda.item.stone')
			return
		end
	end
end

return ItemPickaxe 
