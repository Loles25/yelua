package.path = './src/?.lua;' .. package.path

local util = require 'tests.util'
local json = require 'dkjson'

describe('git install', function()
    it('installs repository and writes lockfile', function()
        util.with_temp_home(function(home)
            package.loaded['config'] = nil
            package.loaded['git'] = nil
            local repo = util.make_git_repo()
            local project = util.tmpdir()
            local git = require 'git'
            local ok, err = git.install('mypkg', repo, nil, project)
            assert.is_true(ok, err)
            local f = assert(io.open(project .. '/lua_modules/mypkg/file.txt', 'r'))
            f:close()
            local lockf = assert(io.open(project .. '/yelua.lock', 'r'))
            local data = lockf:read('*a')
            lockf:close()
            local t = assert(json.decode(data))
            assert.are.equal('v1.0.0', t['mypkg'].version)
            assert.are.equal(repo, t['mypkg'].source)
            os.execute('rm -rf ' .. project)
        end)
    end)
end)

