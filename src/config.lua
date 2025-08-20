local yaml = require 'lyaml'

local M = {}

local home = os.getenv('HOME') or '.'
local config_dir = home .. '/.yelua'
local config_path = config_dir .. '/config.yaml'

local default_config = {
    cache_dir = config_dir .. '/cache'
}

local function ensure_dir(path)
    os.execute(string.format('mkdir -p %q', path))
end

function M.save(cfg)
    ensure_dir(config_dir)
    local file = assert(io.open(config_path, 'w'))
    file:write(yaml.dump({cfg}))
    file:close()
end

function M.load()
    ensure_dir(config_dir)
    local file = io.open(config_path, 'r')
    if file then
        local content = file:read('*a')
        file:close()
        local ok, cfg = pcall(yaml.load, content)
        if ok and type(cfg) == 'table' then
            for k, v in pairs(default_config) do
                if cfg[k] == nil then
                    cfg[k] = v
                end
            end
            return cfg
        end
    end
    local cfg = {}
    for k, v in pairs(default_config) do
        cfg[k] = v
    end
    M.save(cfg)
    return cfg
end

M.path = config_path

return M

