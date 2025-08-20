package.path = './src/?.lua;' .. package.path

local util = require 'tests.util'

describe('config', function()
    it('loads defaults and saves configuration', function()
        util.with_temp_home(function(home)
            package.loaded['config'] = nil
            local config = require 'config'
            local cfg = config.load()
            assert.are.equal(home .. '/.yelua/cache', cfg.cache_dir)
            assert.are.equal(home .. '/.yelua/config.yaml', config.path)
            local new_cfg = { cache_dir = home .. '/custom_cache' }
            config.save(new_cfg)
            local cfg2 = config.load()
            assert.are.same(new_cfg, cfg2)
        end)
    end)
end)

