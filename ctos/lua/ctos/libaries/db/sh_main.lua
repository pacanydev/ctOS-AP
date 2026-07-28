ctOS.DB = ctOS.DB or {}
ctOS.DB.DefualtValue = {
    module = "sqlite",
    password = "Change_Me_To_Your_Password",
    hostname = "Here_Is_YOUR_Host_Name",
    port = 3306,
    database = "Your_DB_Name_HERE",
    username = "User_Name_For_DB_HERE!"
}


function ctOS.DB.Init()
    // [INTERNAL] Init DB. Creates object for DataBase. 
    // Returns db object.

    local value = file.Read('ctos/db_data.json','DATA') // I want to change .json to .lol :D
    if !value then 
        file.Write('ctos/db_data.json',util.TableToJSON(ctOS.DB.DefualtValue)) 
        value = table.Copy(ctOS.DB.DefualtValue)
    else
        value = util.JSONToTable(value)
        if !value then
            console.info('"ctos/db_data.json" is broken. Using defualt variables')
            value = table.Copy(ctOS.DB.DefualtValue)
        end
    end



    msql_wrapper:SetModule((value.module or 'sqlite'))
    msql_wrapper:Connect((value.hostname or 'none'),(value.username or 'none'),(value.password or 'none'),(value.database or 'none'),(value.port or 3306))
    
    ctOS.DB.obj = msql_wrapper 
    console.log('Database is connected. Using module '..value.module)
end

hook.Add("Think", "q_SQL", function()
    if not ctOS.DB.obj or not ctOS.DB.obj.Think then ctOS.DB.Init() end
    ctOS.DB.obj:Think()
end)
