local config = require 'config'
local whitelist = require 'whitelist'
local cfg = config.load()

local function dir_exists(path)
    local ok = os.execute(string.format('[ -d %q ]', path))
    return ok == true or ok == 0
end

return function(args)
    local term = args.term and args.term:lower() or ''
    local wl = whitelist.load_whitelist()
    for pkg, info in pairs(wl) do
        if pkg:lower():find(term, 1, true) then
            local cache_path = string.format('%s/%s', cfg.cache_dir, pkg)
            local cached = dir_exists(cache_path) and 'yes' or 'no'
            local desc = info.description or ''
            print(string.format('%s - %s (cached: %s)', pkg, desc, cached))
        end
    end
end

