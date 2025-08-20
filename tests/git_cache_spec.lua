package.path = './src/?.lua;' .. package.path

local util = require 'tests.util'

describe('git cache', function()
    it('reuses existing clone', function()
        util.with_temp_home(function(home)
            package.loaded['config'] = nil
            package.loaded['git'] = nil
            local repo = util.make_git_repo()
            local git = require 'git'
            local path = assert(git.clone(repo, 'mypkg', 'v1.0.0'))
            local marker = path .. '/marker'
            local f = assert(io.open(marker, 'w'))
            f:write('x')
            f:close()
            local path2 = assert(git.clone(repo, 'mypkg', 'v1.0.0'))
            assert.are.equal(path, path2)
            local f2 = assert(io.open(marker, 'r'))
            f2:close()
        end)
    end)
end)

