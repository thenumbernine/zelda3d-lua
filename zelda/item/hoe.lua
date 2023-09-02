local vec3f = require 'vec-ffi.vec3f'
local Tile = require 'zelda.tile'
local HoedGround = require 'zelda.obj.hoedground'
local Plant = require 'zelda.obj.plant'
local Item = require 'zelda.item.item'

local ItemHoe = Item:subclass()

ItemHoe.name = 'hoe'
ItemHoe.sprite = 'item'
ItemHoe.seq = 'hoe'

-- static method
function ItemHoe:useInInventory(player)
	local map = player.map
	
	local x,y,z = (player.pos + vec3f(
		math.cos(player.angle),
		math.sin(player.angle),
		0
	)):map(math.floor):unpack()
	local topVoxelType = map:getType(x,y,z)
	local groundVoxel = map:getTile(x,y,z-1)
	if groundVoxel
	and groundVoxel.type == Tile.typeValues.Grass
	and topVoxelType == Tile.typeValues.Empty
	and not map:hasObjType(x,y,z,HoedGround)
	then
		local half = -.5 * groundVoxel.half
		local dx, dy, dz = x+.5, y+.5, z + half
		-- TODO any kind of solid object
		--  a better classification would be only allow watered/hoedground/seededground types (which should all have a common parent class / flag)
		if not map:hasObjType(dx,dy,dz,Plant) then
			player.map:newObj{
				class = HoedGround,
				pos = vec3f(dx, dy, dz),
			}
		end
	end
end

return ItemHoe 
