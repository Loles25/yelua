local M = {}

local json
local ok, j = pcall(require, 'dkjson')
if ok then
    json = j
else
    ok, j = pcall(require, 'cjson')
    if ok then
        json = j
    else
        error('No JSON library found')
    end
end

local cache

function M.load_whitelist()
    if cache then
        return cache
    end

    local file = io.open('whitelist.json', 'r')
    if not file then
        cache = {}
        return cache
    end

    local data = file:read('*a')
    file:close()
    cache = json.decode(data)
    return cache
end

function M.is_allowed(pkg)
    local wl = M.load_whitelist()
    return wl[pkg] ~= nil
end

function M.update_whitelist()
    -- Placeholder for future synchronization with a central repository
    -- TODO: implement remote whitelist update logic
    return nil, 'not implemented'
end

return M
