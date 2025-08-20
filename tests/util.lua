local M = {}

function M.tmpdir()
    local pipe = assert(io.popen('mktemp -d', 'r'))
    local dir = pipe:read('*l')
    pipe:close()
    return dir
end

function M.with_temp_home(fn)
    local dir = M.tmpdir()
    local orig = os.getenv
    os.getenv = function(key)
        if key == 'HOME' then
            return dir
        end
        return orig(key)
    end
    local ok, err = pcall(fn, dir)
    os.getenv = orig
    os.execute('rm -rf ' .. dir)
    if not ok then error(err) end
end

function M.make_git_repo()
    local repo = M.tmpdir()
    os.execute('git init ' .. repo .. ' >/dev/null')
    os.execute('git -C ' .. repo .. ' config user.email "test@example.com"')
    os.execute('git -C ' .. repo .. ' config user.name "Test User"')
    os.execute('touch ' .. repo .. '/file.txt')
    os.execute('git -C ' .. repo .. ' add file.txt >/dev/null')
    os.execute('git -C ' .. repo .. ' commit -m "init" >/dev/null')
    os.execute('git -C ' .. repo .. ' tag v1.0.0')
    return repo
end

return M
