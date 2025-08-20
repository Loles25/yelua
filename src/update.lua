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
local git = require 'git'
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

return function(args)
    local lock_path = './yelua.lock'
    local lock = read_lock(lock_path)
    local targets = {}
    if args.package and #args.package > 0 then
        for _, p in ipairs(args.package) do
            if lock[p] then
                table.insert(targets, p)
            else
                print(string.format('Package %s not installed', p))
            end
        end
    else
        for p, _ in pairs(lock) do
            table.insert(targets, p)
        end
    end

    for _, pkg in ipairs(targets) do
        if whitelist.is_allowed(pkg) then
            local info = lock[pkg]
            local cache_path = string.format('%s/%s', cfg.cache_dir, pkg)
            if dir_exists(cache_path) then
                os.execute(string.format('rm -rf %q', cache_path))
            end
            local ok, err = git.install(pkg, info.source, nil, '.')
            if ok then
                print(string.format('Updated %s', pkg))
            else
                print(string.format('Failed to update %s: %s', pkg, err))
            end
        else
            print(string.format('Package %s is not permitted by whitelist', pkg))
        end
    end
end

