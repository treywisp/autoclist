--[[

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <https://unlicense.org>

]]

script_author("treywisp")
script_name("autoclist")

local sampev = require("samp.events")
local inicfg = require("inicfg")

local config_path = "autoclist.ini"
local settings = inicfg.load({
    settings = {
        active = false,
        clist = 0,
    }
}, config_path)
inicfg.save(settings, config_path)

local function notify(msg)
    sampAddChatMessage("[autoclist] {FFFFFF}"..msg, 0x6495ED)
end

local function toggleActive()
    settings.settings.active = not settings.settings.active
    inicfg.save(settings, config_path)
    notify("Скрипт "..(settings.settings.active and "активирован" or "деактивирован"))
end

local function changeClist(arg)
    local clist = tonumber(arg)
    if clist and clist >= 0 and clist <= 33 then
        settings.settings.clist = clist
        inicfg.save(settings, config_path)
        notify("Установлен клист: "..clist)
    else
        notify("Введите число от 0 до 33. Пример: /changeclist 26")
    end
end

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    notify("Загружен. Активация - /autoclist, установка клиста - /changeclist 12")

    sampRegisterChatCommand("autoclist", toggleActive)
    sampRegisterChatCommand("changeclist", changeClist)
end

function sampev.onSendSpawn()
    if settings.settings.active then
        lua_thread.create(function()
            wait(2000)
            sampSendChat("/clist "..settings.settings.clist)
        end)
    end
end

