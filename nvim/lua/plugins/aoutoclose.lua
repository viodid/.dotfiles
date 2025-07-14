local config = {
   ["("] = { escape = false, close = true, pair = "()"},
   ["["] = { escape = false, close = true, pair = "[]"},
   ["{"] = { escape = false, close = true, pair = "{}"},

   [">"] = { escape = true, close = false, pair = "<>"},
   [")"] = { escape = true, close = false, pair = "()"},
   ["]"] = { escape = true, close = false, pair = "[]"},
   ["}"] = { escape = true, close = false, pair = "{}"},

   ['"'] = { escape = true, close = true, pair = '""'},
   ["'"] = { escape = true, close = true, pair = "''"},
   ["`"] = { escape = true, close = true, pair = "``"},
}

require("autoclose").setup(config)
