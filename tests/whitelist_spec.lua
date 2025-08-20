package.path = './src/?.lua;' .. package.path


describe('whitelist', function()
    local original

    setup(function()
        local f = assert(io.open('whitelist.json', 'r'))
        original = f:read('*a')
        f:close()
    end)

    before_each(function()
        local f = assert(io.open('whitelist.json', 'w'))
        f:write(original)
        f:close()
        package.loaded['whitelist'] = nil
    end)

    after_each(function()
        local f = assert(io.open('whitelist.json', 'w'))
        f:write(original)
        f:close()
        package.loaded['whitelist'] = nil
    end)

    it('loads whitelist and checks packages', function()
        local whitelist = require 'whitelist'
        local wl = whitelist.load_whitelist()
        assert.truthy(wl['example-package'])
        assert.is_true(whitelist.is_allowed('example-package'))
        assert.is_false(whitelist.is_allowed('not-in-list'))
    end)

    it('caches whitelist between calls', function()
        local whitelist = require 'whitelist'
        local wl1 = whitelist.load_whitelist()
        local f = assert(io.open('whitelist.json', 'w'))
        f:write('{}')
        f:close()
        local wl2 = whitelist.load_whitelist()
        assert.are.same(wl1, wl2)
    end)
end)

