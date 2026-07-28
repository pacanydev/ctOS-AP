mdl = mdl or MODULE:Create({
    name = 'SBS',
    description = '123',
    group = '123'
}) 

function mdl:Init() 
    // code...
end

timer.Simple(0.01,function() ctOS.Modules.RegisterModule(mdl) end)