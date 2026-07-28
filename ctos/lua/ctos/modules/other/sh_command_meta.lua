COMMAND = {}
COMMAND.__index = COMMAND
COMMAND.IsCommand = true 

function COMMAND:BlankFunc()
    // ... Just blank function.
    // [INTERNAL] DON'T USE IT IF YOU DON'T KNOW WHAT YOU ARE DOING!
    return true
end

function COMMAND:Create(data,settings)
    // Creates an object for future use of commands.
    // Needs: data.name, data.group, data.description and settings (may be {})
    // Returns command.
    
    if not (data and settings) then console.log('[1] Command doesn\'t have needed values!') return 1 end
    
    if not (data.name and data.group and data.description) then console.log('[2] Command doesn\'t have needed values!') return 2 end
    
    local command = setmetatable({},self)
    command.name = data.name
    command.permission = (data.permission or data.group..'.'..data.name) // will need check in the future!
    command.description = data.description
    command.category = (data.category or 'other')
    for k,v in pairs(settings) do command[k] = v end    // will be cool to trasfer methods thru it.
                                                        // like additional settings from other developers. 
    command.arguments = {}
    command.help_text = ''

    return command
end

function COMMAND:AddArgument(value)
    // Will be used when user tries to use an command.
    // Needs: value
    // Returns: command
    if not (value) then return self end
    self.arguments[#self.arguments + 1] = value
    return self
end

function COMMAND:AddArguments(value) 
    // Will be used when user tries to use an command.
    // Needs: value
    // Returns: command
    if not (value) then return self end
    self.arguments = value
    return self
end


function COMMAND:SetValue(key,value)
    // Creates an object for future use of commands.
    // Needs: key & value
    // Returns: command
    if not (key and value) then return self end
    self[key] = value
    return self
end

function COMMAND:LogInfo(user,args) 
    // So it's logs info  
    // return's string or false
    if true then return false end
    return 'nothing ever happens'
end

function COMMAND:Run(user,args) 
    // Just runs command without ANY checks. 
    // To replace it use: Command:SetValue()
    // [INTERNAL] DON'T USE IT IF YOU DON'T KNOW WHAT YOU ARE DOING!
    return (self.callback and self:callback(user,args) or self:BlankFunc())
end

return COMMAND