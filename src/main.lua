local argparse = require 'argparse'
local config = require 'config'

local function main(input_args)
    local cfg = config.load()

    local parser = argparse('yelua', 'Yelua package manager')
    parser:command('install', 'Install packages')
    parser:command('remove', 'Remove packages')
    local args = parser:parse(input_args)

    if args.install then
        print('Installing packages...')
    elseif args.remove then
        print('Removing packages...')
    else
        parser:print_help()
    end
end

return main
