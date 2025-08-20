local argparse = require 'argparse'
local config = require 'config'

local function main(input_args)
    local cfg = config.load()

    local parser = argparse('yelua', 'Yelua package manager')
    parser:command('install', 'Install packages')
    parser:command('remove', 'Remove packages')
    local cache = parser:command('cache', 'Cache operations')
    cache:command('clean', 'Purge cache')
    local args = parser:parse(input_args)

    if args.install then
        print('Installing packages...')
    elseif args.remove then
        print('Removing packages...')
    elseif args.cache and args.clean then
        os.execute(string.format('rm -rf %q', cfg.cache_dir))
        print('Cache cleaned')
    else
        parser:print_help()
    end
end

return main
