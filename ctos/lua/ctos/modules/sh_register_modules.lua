ctOS = ctOS or {}
ctOS.Modules = ctOS.Modules or {}
ctOS.Modules.Registered = ctOS.Modules.Registered or {}
ctOS.Modules.Modules = ctOS.Modules.Modules or {}

function ctOS.Modules.RegisterModule(tbl) 
    // Every module need to have Init function (for the commands)
    // Init function will have permission and etc.

    if (!tbl.name) then return false end
    if (!tbl.group) then return false end
    if (!tbl.description) then return false end 

    if (!tbl.commands) then return false end 
    if type(tbl.commands) ~= "table" then return false end
    
    //if (!tbl.hooks) then return false end 
    //if type(tbl.hooks) ~= "table" then return false end

    if ctOS.Modules.Registered[tbl.name] then return false end // mdl is registered so fuck you!

    for k,v in pairs(tbl.commands) do
        ctOS.Modules.RegisterCommand(tbl.group,v)
    end

    //for k,v in pairs(tbl.hooks) do
        // ctOS.Modules.RegisterCommand(v) later
    //end

    if tbl.Init then tbl.Init() end // you can initializate database in this file
    ctOS.Modules.Modules[tbl.name] = tbl

    return true
end



function ctOS.Modules.Restart(name)
    local mod = ctOS.Modules.Modules[name]
    if not mod then return false end

    if mod.commands then
        for _, cmd in pairs(mod.commands) do
            local group = cmd.category or mod.group or 'other'
            if ctOS.Commands.RegisteredCommands[group] then
                ctOS.Commands.RegisteredCommands[group][cmd.name:lower()] = nil
            end
            
            for i, c in ipairs(ctOS.Commands.AutoComplete) do
                if c:lower() == cmd.name:lower() then
                    table.remove(ctOS.Commands.AutoComplete, i)
                    break
                end
            end
        end
    end

    ctOS.Modules.Registered[name] = nil

    for k,v in pairs(mod.commands) do
        ctOS.Modules.RegisterCommand(mod.group, v)
    end

    if mod.Init then 
        mod.Init() 
    end

    ctOS.Modules.Registered[name] = true

    return true
end

function ctOS.Modules.RestartAll()
    for name,_ in pairs(ctOS.Modules.Modules) do
        ctOS.Modules.Restart(name)
    end
end

function ctOS.Modules.IsModuleEnabled(name)
    local mod = ctOS.Modules.Modules[name]
    if not mod then return false end
    return mod.enabled ~= false
end

function ctOS.Modules.SetEnabled(name, state)
    local mod = ctOS.Modules.Modules[name]
    if not mod then return false end
    mod.enabled = state
    return true
end

//ctOS.Modules.RestartAll()