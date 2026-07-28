mdl = mdl or {}

mdl:CreateCommand({
    name = "time",
    description = "Тестовая команда",
    category = "utils",
    group = 'mdl.group'
}, {
    callback = function(self, ply, args)
        ply:ChatPrint("Команда test сработала!")
    end
})

mdl:CreateCommand({
    name = "kick",
    description = "Тестовая команда",
    category = "utils",
    group = 'mdl.group'  
}, {
    callback = function(self, ply, args)
        ply:ChatPrint("Команда test сработала!")
    end
})

