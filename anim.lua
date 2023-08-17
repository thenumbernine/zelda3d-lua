-- anim[sprite][seq][frame]

local anim = {
	link = {
		useDirs = true,
		stand_r = {
			{filename = 'sprites/link/stand_r.png'},
		},
		stand_u = {
			{filename = 'sprites/link/stand_u.png'},
		},
		stand_l = {
			{filename = 'sprites/link/stand_r.png', hflip=true},
		},
		stand_d = {
			{filename = 'sprites/link/stand_d.png'},
		},
	},
	goomba = {
		stand = {
			{filename = 'sprites/goomba/stand.png'},
		},
	},
	
	-- [[ ground sprites ... TODO instead use a dif rendering system for these ...
	hoed = {
		stand = {
			{filename = 'sprites/hoed/stand.obj'},
		},
	},
	watered = {
		stand = {
			{filename = 'sprites/watered/stand.obj'},
		},
	},
	seededground = {
		stand = {
			{filename = 'sprites/seededground/stand.obj'},
		},
	},
	--]]
	-- [[ 3D
	bed = {
		stand = {
			{filename = 'sprites/bed/stand.obj'},
		},
	},
	--]]
}

-- TODO use the filesystem for the whole thing? and no table?
-- or TODO use spritesheets?
--[[
local path = require 'ext.path'
for _,spritename in ipairs{'goomba'} do
	local sprite = {}
	anim[spritename] = sprite
	for f in path('sprites/'..spritename):dir() do
		local base, ext = path(f):getext()
		local seqname, frameindex = base:match'^(.-)(%d*)$'
		frameindex = tonumber(frameindex) or frameindex
		-- TODO auto group sequences of numbers?
		sprite[seqname] = sprite[seqname] or {}
		table.insert(sprite[seqname], {
			filename = 'sprites/'..spritename..'/'..f, 
			index = frameindex,
		})
	end
	for seqname,seq in pairs(sprite) do
		table.sort(seq, function(a,b) return a.index < b.index end)
	end
	-- I don't need the frames after sorting, right?
	for seqname,seq in pairs(sprite) do
		for index,frame in ipairs(seq) do
			frame.index = nil
		end
	end
end
--]]

return anim
