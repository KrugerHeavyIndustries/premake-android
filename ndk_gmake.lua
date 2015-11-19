--
-- android/ndk_gmake.lua
-- android integration for gmake.
-- Copyright (c) 2012-2015 Chris Kruger and the Premake project
--

	local p = premake

	p.modules.vsandroid = { }

	local android = p.modules.android
	local gmake = p.modules.gmake
	local project = p.project
	local config = p.config

	local gcc = p.tools.gcc

	local platformshortname = 'android'
	local androidndkpath = os.getenv('NDK')
	local androidapilevel = ''
	local archstldirname = 'armeabi'
	local androidapipath = androidndkpath .. '/platforms/' .. androidapilevel
	local androidincludepath = androidapipath .. '/arch-' .. platformshortname .. '/usr/include'
	local androidlibpath = androidapipath .. '/arch-' .. platformshortname .. '/usr/lib'
	local androidstlincludepath = androidndkpath .. '/sources/cxx-stl/llvm-libc++/libcxx/include'
	local androidstllibpath = androidndkpath .. '/sources/cxx-stl/llvm-libc++/libs/' .. archstldirname
	
	local androidstllibs = '-lc++_static'
	local gcclibpath = 'armeabi'

	local platformtoolsetversion = 'arm-linux-androideabi-4.8'
	local gcctoolspath = androidndkpath .. '/toolchains/' .. platformtoolsetversion .. '/prebuilt/darwin-x86_64/bin'
	p.override(gcc, 'gettoolname', function(base, cfg)
		local toolchain_prefix = 'arm-linux-androideabi'
		return gcctoolspath .. '/' .. toolchain_prefix .. '-g++'
	end)
