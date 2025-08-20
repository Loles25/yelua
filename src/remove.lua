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

local function json_encode(tbl)
    local ok, res = pcall(json.encode, tbl, { indent = true })
    if ok then
        return res
    end
    ok, res = pcall(json.encode, tbl)
    if ok then
        return res
    end
    error('Failed to encode JSON')
end

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

local function write_lock(path, tbl)
    local file = assert(io.open(path, 'w'))
    file:write(json_encode(tbl))
    file:close()
end

local function dir_exists(path)
    local ok = os.execute(string.format('[ -d %q ]', path))
    return ok == true or ok == 0
end

return function(args)
    local lock_path = './yelua.lock'
    local lock = read_lock(lock_path)
    for _, pkg in ipairs(args.package or {}) do
        if whitelist.is_allowed(pkg) then
            local mod_path = string.format('./lua_modules/%s', pkg)
            if dir_exists(mod_path) then
                os.execute(string.format('rm -rf %q', mod_path))
            end
            lock[pkg] = nil
            local cache_path = string.format('%s/%s', cfg.cache_dir, pkg)
            if dir_exists(cache_path) then
                os.execute(string.format('rm -rf %q', cache_path))
            end
            print(string.format('Removed %s', pkg))
        else
            print(string.format('Package %s is not permitted by whitelist', pkg))
        end
    end
    write_lock(lock_path, lock)
end

