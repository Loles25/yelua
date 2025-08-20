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

local config = require 'config'
local whitelist = require 'whitelist'
local cfg = config.load()

local function read_lock(path)
    local file = io.open(path, 'r')
    if file then
        local data = file:read('*a')
        file:close()
        local ok, t = pcall(json.decode, data)
        if ok and type(t) == 'table' then
            return t
        end
    end
    return {}
end

local function dir_exists(path)
    local ok = os.execute(string.format('[ -d %q ]', path))
    return ok == true or ok == 0
end

return function()
    local lock = read_lock('./yelua.lock')
    if next(lock) == nil then
        print('No packages installed')
        return
    end
    for pkg, info in pairs(lock) do
        local allowed = whitelist.is_allowed(pkg) and 'yes' or 'no'
        local cache_path = string.format('%s/%s/%s', cfg.cache_dir, pkg, info.version or 'latest')
        local cached = dir_exists(cache_path) and 'yes' or 'no'
        print(string.format('%s %s (whitelist: %s, cached: %s)', pkg, info.version or '', allowed, cached))
    end
end

