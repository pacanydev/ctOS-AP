ctOS = ctOS or {}

local sides = {
	["sv_"] = "sv_",
	["sh_"] = "sh_",
	["cl_"] = "cl_",
	["_sv"] = "sv_",
	["_sh"] = "sh_",
	["_cl"] = "cl_",
}

local function AddFile(File, dir)
	File = File:gsub("//", "/")
	dir = dir:gsub("//", "/")
	local fileSide = string.lower(string.Left(File, 3))
	local fileSide2 = string.lower(string.Right(string.sub(File, 1, -5), 3))
	local side = sides[fileSide] or sides[fileSide2]
	//print(dir..File)
	if SERVER and side == "sv_" then
		include(dir .. File)
	elseif side == "sh_" then
		if SERVER then AddCSLuaFile(dir .. File) end
		include(dir .. File)
	elseif side == "cl_" then
		if SERVER then
			AddCSLuaFile(dir .. File)
		else
			include(dir .. File)
		end
	else
		if SERVER then AddCSLuaFile(dir .. File) end
		include(dir .. File)
	end
end

local function IncludeDir(dir)
	dir = dir .. "/"
	local files, directories = file.Find(dir .. "*", "LUA")
	if files then
		local shit = {}
		for k, v in ipairs(files) do
			if string.EndsWith(v, ".lua") and !(string.find(v,'init') or string.find(v,'main')) then table.insert(shit,v) 
			else if string.EndsWith(v,'.lua') then AddFile(v, dir) end end
		end
		for k, v in ipairs(shit) do
			if string.EndsWith(v, ".lua") then AddFile(v, dir) end
		end
	end

	if directories then
		for k, v in ipairs(directories) do
			IncludeDir(dir .. v)
		end
	end
end

local function ReloadModules()
	if not (COMMAND) then return timer.Simple(0.5,ReloadModules) end
	if not (MODULE) then return timer.Simple(0.5,ReloadModules) end
	IncludeDir("ctos_modules/")
end
local function Run()
	local time = SysTime()
	print("Loading ctOS...")
	ctOS.loaded = false
	IncludeDir("ctos/")
	ctOS.loaded = true
	print("Loaded ctOS " .. tostring(math.Round(SysTime() - time, 5)) .. " seconds needed")
	ReloadModules()
end

ctOS.IncludeDir = IncludeDir

hook.Add("InitPostEntity", "ctOS_main_loader", function() Run() end)
if ctOS.loaded then Run() end