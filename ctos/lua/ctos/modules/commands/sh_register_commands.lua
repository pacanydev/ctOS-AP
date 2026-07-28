ctOS = ctOS or {}
ctOS.Modules = ctOS.Modules or {}
ctOS.Commands = ctOS.Commands or {}
ctOS.Commands.AutoComplete = ctOS.Commands.AutoComplete or {}
ctOS.Commands.RegisteredCommands = ctOS.Commands.RegisteredCommands or {}

function ctOS.Modules.RegisterCommand(group,cmds)
    if not (cmds.name and cmds.description) then console.log('Command doesn\'t have needed values!') return false end
    if table.HasValue(ctOS.Commands.AutoComplete,cmds.name:lower()) then console.log(cmds.name:lower()..' is already registered!') return false end

    ctOS.Commands.AutoComplete[cmds.name:lower()] = group 

    ctOS.Commands.RegisteredCommands[group] = ctOS.Commands.RegisteredCommands[group] or {}
    ctOS.Commands.RegisteredCommands[group][(cmds.name):lower()] = cmds // callback and etc.

    return true
end

function ctOS.Modules.AutoComplete(command,parameter)
    local parameters = {}

    for _, v in ipairs(parameter:Split(' ')) do
        if v ~= '' then
            table.insert(parameters, v)
        end
    end

    if #parameters == 0 then 
        local list_autocomplete = {}
        for k,v in pairs(ctOS.Commands.AutoComplete) do 
            list_autocomplete[#list_autocomplete+1] = command..' '..k
        end
        return list_autocomplete
    end
    
    if ctOS.Commands.AutoComplete[parameters[1]:lower()] then
        local list_autocomplete = {}
        for k,v in pairs(ctOS.Commands.AutoComplete) do 
            if v:lower():StartsWith(parameters[1]:lower()) then
                list_autocomplete[#list_autocomplete+1] = command..' '..k
            end
        end
        return list_autocomplete
    else

    end
end

concommand.Add("ct", function(ply, cmd, args)
    if #args == 0 then
        console.log('Welcome to the ctOS!')
        return
    end
    local command = args[1]:lower()

    if ctOS.Commands.AutoComplete[command] then
        local group = ctOS.Commands.AutoComplete[command]
        local commnd = ctOS.Commands.RegisteredCommands[group][command]

        if ctOS.Roles.Has(ply,commnd.permission) then
            commnd:Run(ply,args)
        end
    end
    
end, ctOS.Modules.AutoComplete)