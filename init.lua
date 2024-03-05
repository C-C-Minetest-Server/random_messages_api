-- random_messages/init.lua
-- Register random announcements
--[[
    Copyright (C) 2023  1F616EMO

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301
    USA
]]

random_messages_api = {
    list = {},
    interval = tonumber(minetest.settings:get("random_messages_api.interval") or 60) or 60,
    last_picked = nil
}

function random_messages_api.register_message(msg)
    random_messages_api.list[#random_messages_api.list + 1] = msg
end

function random_messages_api.from_table(tab)
    for _, msg in ipairs(tab) do
        random_messages_api.register_message(msg)
    end
end

function random_messages_api.from_file(filename)
    local file = io.open(filename, "r")
    if not file then
        return false
    end
    repeat
        local value = file:read("*l")
        if value and value ~= "" and string.sub(value, 1, 1) ~= "#" then
            random_messages_api.register_message(value)
        end
    until value == nil
    file:close()
    return true
end

function random_messages_api.pick_message()
    if #random_messages_api.list == 0 then
        return nil
    elseif #random_messages_api.list == 1 then
        return random_messages_api.list[1]
    end
    local id
    repeat
        id = math.random(1, #random_messages_api.list)
    until id ~= random_messages_api.last_picked
    random_messages_api.last_picked = id
    return random_messages_api.list[id]
end

if minetest.settings:get_bool("random_messages_api.load_custom_messages", true) then
    local WP = minetest.get_worldpath()
    if not random_messages_api.from_file(WP .. DIR_DELIM .. "random_messages.txt") then
        minetest.log("warning", "[random_messages_api] Load from random_messages.txt failed")
    end
end

local function loop()
    if minetest.settings:get_bool("random_messages_api.send_without_players", true)
        or #minetest.get_connected_players() ~= 0 then
        local msg = random_messages_api.pick_message()
        if msg then
            minetest.chat_send_all(minetest.get_color_escape_sequence("grey") .. msg)
            minetest.log("action", "[random_messages_api] MSG: " .. minetest.get_translated_string("en", msg))
        end
    end
    minetest.after(random_messages_api.interval, loop)
end

minetest.after(random_messages_api.interval, loop)
