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

local home = os.getenv('HOME') or '.'
local cache_base = home .. '/.yelua/cache'

local function ensure_dir(path)
    os.execute(string.format('mkdir -p %q', path))
end

local function dir_exists(path)
    local ok = os.execute(string.format('[ -d %q ]', path))
    return ok == true or ok == 0
end

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

local function link_or_copy(src, dest)
    os.execute(string.format('rm -rf %q', dest))
    local ok = os.execute(string.format('ln -s %q %q', src, dest))
    if ok ~= 0 then
        ok = os.execute(string.format('cp -r %q %q', src, dest))
    end
    return ok == 0
end

function M.clone(repo_url, pkg, version)
    local target = string.format('%s/%s/%s', cache_base, pkg, version)
    if not dir_exists(target) then
        ensure_dir(string.format('%s/%s', cache_base, pkg))
        local res = os.execute(string.format('git clone %q %q', repo_url, target))
        if res ~= 0 then
            return nil, 'git clone failed'
        end
    end
    return target
end

function M.install(pkg, repo_url, version, project_dir)
    project_dir = project_dir or '.'
    local cache_path, err = M.clone(repo_url, pkg, version)
    if not cache_path then
        return nil, err
    end
    local modules_dir = project_dir .. '/lua_modules'
    ensure_dir(modules_dir)
    local dest = string.format('%s/%s', modules_dir, pkg)
    if not link_or_copy(cache_path, dest) then
        return nil, 'failed to link or copy package'
    end
    local lock_path = project_dir .. '/yelua.lock'
    local lock = read_lock(lock_path)
    lock[pkg] = { version = version, source = repo_url }
    write_lock(lock_path, lock)
    return true
end

return M

