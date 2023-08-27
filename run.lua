#!/usr/bin/env luajit

-- setup before running
-- configure your luajit ffi library locations here

local cmdline = require 'ext.cmdline'(...)

--[[ specify GL version first:
require 'gl.setup'()	-- for desktop GL.  Windows needs this.
--require 'gl.setup' 'OpenGLES1'	-- for GLES1 ... but GLES1 has no shaders afaik?
--require 'gl.setup' 'OpenGLES2'	-- for GLES2
--require 'gl.setup' 'OpenGLES3'	-- for GLES3.  Linux or Raspberry Pi can handle this.
--]]
-- [[ pick gl vs gles based on OS (Linux has GLES and includes embedded)
local glfn = nil	-- default gl
local ffi = require 'ffi'
if ffi.os == 'Linux' then
	glfn = 'OpenGLES3'	-- linux / raspi (which is also classified under ffi.os == 'Linux') can use GLES3
end
if cmdline.gl ~= nil then	-- allow cmdline override
	glfn = cmdline.gl
end
require 'gl.setup'(glfn)
--]]


-- hack vector, instead of resizing by 32 bytes (slowly)
-- how about increase by 20% then round up to nearest 32
local vector = require 'ffi.cpp.vector'
function vector:resize(newsize)
	newsize = assert(tonumber(newsize))
	local newcap = newsize + bit.rshift(newsize, 1)
	newcap = bit.lshift(bit.rshift(newcap, 5) + 1, 5)
	self:reserve(newcap)
	self.size = newsize
end

return require 'zelda.app'():run()
