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

	local platformshortname = 'arm'
	local androidndkpath = os.getenv('NDK')
	local androidapilevel = 'android-21'
	local archstldirname = 'armeabi'
	local androidapipath = androidndkpath .. '/platforms/' .. androidapilevel
	local androidsysroot = androidapipath .. '/arch-' .. platformshortname
	local androidincludepath = androidsysroot .. '/usr/include'
	local androidlibpath = androidsysroot .. '/usr/lib'
	local androidstlincludepath = androidndkpath .. '/sources/cxx-stl/llvm-libc++/libcxx/include'
	local androidstllibpath = androidndkpath .. '/sources/cxx-stl/llvm-libc++/libs/' .. archstldirname
	local androidsupportincludepath = androidndkpath .. '/sources/android/support/include'
	
	local androidstllibs = '-lc++_shared'
	local gcclibpath = 'armeabi'

	p.override(gcc, 'gettoolname', function(base, cfg, tool)
		local version = cfg.toolchainversion or '4.9'
		local platformtoolset = 'arm-linux-androideabi-'
		return androidndkpath .. '/toolchains/' .. platformtoolset .. version .. '/prebuilt/darwin-x86_64/bin/' .. platformtoolset .. 'g++'
	end)

	p.override(gcc, 'getincludedirs', function(base, cfg, dirs, sysdirs)
		local includes = base(cfg, dirs, sysdirs)
		table.insert(includes, '-isystem ' .. androidincludepath)
		table.insert(includes, '-isystem ' .. androidstlincludepath)
		table.insert(includes, '-isystem ' .. androidsupportincludepath)
		return includes
	end)

	p.override(gcc, 'getldflags', function(base, cfg) 
		local flags = base(cfg)
		table.insert(flags, '--sysroot ' .. androidsysroot)
		return flags
	end) 
	
	p.override(gcc, 'getLibraryDirectories', function(base, cfg) 
		local dir = androidlibpath
		local flags = base(cfg)
		table.insert(flags, '-L' .. premake.quoted(dir))
		table.insert(flags, '-L' .. premake.quoted(androidstllibpath))
		return flags
	end)

	p.override(gcc, 'getlinks', function(base, cfg, systemonly) 
		local result = base(cfg, systemonly)
		table.insert(result, androidstllibs)
		return result
	end)
