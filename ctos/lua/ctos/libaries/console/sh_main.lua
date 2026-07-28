// LGTM! This module is needed for sending info. Will rework it OR put new things when ctOS will be done.

console = console or {}
console.prefix = '[ctOS] ' // you may replace it with your name if you want to //// MAYBE IN THE FUTURE I WILL CREATE SETTING TO REPLACE THIS!
console.color_r = Color(224,179,179)
console.color_y = Color(255,242,0)
console.color_g = Color(38,35,35)
console.color_w = Color(255,255,255)

function console.log(...) // for debbuging
    MsgC(console.color_y,console.prefix,console.color_w,...,'\n')
end

function console.info(...) // for logging info about admins and etc.
    MsgC(console.color_g,console.prefix,console.color_w,...,'\n')
end

function console.error(...)
    local args = {...}
    local prefix = "[ctOS | ERROR] "
    
    local msg = prefix
    for i, v in ipairs(args) do
        msg = msg .. tostring(v)
        if i < #args then
            msg = msg .. " "
        end
    end
    msg = msg .. "\n"
    
    ErrorNoHalt(msg)
end

return console