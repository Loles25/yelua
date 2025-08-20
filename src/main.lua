local argparse = require 'argparse'
local config = require 'config'

local function main(input_args)
    local cfg = config.load()

    local parser = argparse('yelua', 'Yelua package manager')

    local install = parser:command('install', 'Install packages')
    install:argument('package', 'Packages to install'):args('+')

    local remove = parser:command('remove', 'Remove packages')
    remove:argument('package', 'Packages to remove'):args('+')

    local update = parser:command('update', 'Update packages')
    update:argument('package', 'Packages to update'):args('*')

    parser:command('list', 'List installed packages')

    local search = parser:command('search', 'Search whitelist')
    search:argument('term', 'Search term')

    local cache = parser:command('cache', 'Cache operations')
    cache:command('clean', 'Purge cache')

    local args = parser:parse(input_args)

    if args.install then
        print('Installing packages...')
    elseif args.remove then
        local cmd = require 'remove'
        cmd(args)
    elseif args.update then
        local cmd = require 'update'
        cmd(args)
    elseif args.list then
        local cmd = require 'list'
        cmd()
    elseif args.search then
        local cmd = require 'search'
        cmd(args)
    elseif args.cache and args.cache.clean then
        os.execute(string.format('rm -rf %q', cfg.cache_dir))
        print('Cache cleaned')
    else
        parser:print_help()
    end
end

return main
