package = "yelua"
version = "0.1-1"
source = {
   url = "git+https://github.com/Loles25/yelua"
}
description = {
   summary = "Yelua package manager",
   detailed = [[Simple package manager written in Lua.]],
   license = "MIT",
   homepage = "https://github.com/Loles25/yelua"
}
dependencies = {
   "lua >= 5.1",
   "argparse",
   "lyaml",
   "dkjson"
}
build = {
   type = "builtin",
   modules = {
      ["main"] = "src/main.lua",
      ["config"] = "src/config.lua",
      ["git"] = "src/git.lua",
      ["list"] = "src/list.lua",
      ["remove"] = "src/remove.lua",
      ["search"] = "src/search.lua",
      ["update"] = "src/update.lua",
      ["whitelist"] = "src/whitelist.lua"
   },
   install = {
      bin = { yelua = "yelua" }
   }
}
