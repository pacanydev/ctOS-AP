MODULE = {}
MODULE.__index = MODULE
MODULE.IsModule = true 

function MODULE:BlankFunc()
    // ... Just blank function.
    // [INTERNAL] DON'T USE IT IF YOU DON'T KNOW WHAT YOU ARE DOING!
    return true
end

function MODULE:CreateCommand(data,settings)
    // Creates an object for future use of module.
    // Needs: data.name, data.group, data.description
    // Returns command.
    if not (data and settings) then console.log('... Unknown error ..') return false end 
    
    local cmd = COMMAND:Create(data,settings)
    if not cmd then return false end
    self.commands[#self.commands +1] = cmd 
    return cmd
end

function MODULE:Create(data)
    // Creates an object for future use of module.
    // Needs: data.name, data.group, data.description
    // Returns module.
    
    if not (data) then console.log('[1] Module doesn\'t have needed values!') return 1 end
    
    if not (data.name and data.group and data.description) then console.log('[2] Module doesn\'t have needed values!') return 2 end
    
    local new_module = setmetatable({},self)

    new_module.name = data.name
    new_module.permission = (data.permission or data.group..'.'..data.name) // will need check in the future!
    new_module.description = data.description
    new_module.group = data.group
    new_module.commands = {}
    new_module.hooks = {}
    
    return new_module
end

function MODULE:SetValue(key,value)
    // Creates an object for future use of commands.
    // Needs: key & value
    // Returns: command
    if not (key and value) then return self end
    self[key] = value
    return self
end

function MODULE:Init(user,args) 
    // Just runs command without ANY checks. 
    // [INTERNAL] DON'T USE IT IF YOU DON'T KNOW WHAT YOU ARE DOING!
    return (self.callback and self:callback(user,args) or self:BlankFunc())
end

return MODULE