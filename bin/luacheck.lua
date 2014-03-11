#!/bin/env lua
local luacheck = require "luacheck"
local format = require "luacheck.format"
local argparse = require "argparse"

local parser = argparse "luacheck"
   :description "Simple static analyzer. "
parser:argument "files"
   :description "Files to check. "
   :args "+"
   :argname "<file>"
parser:option "--globals"
   :description "Defined globals. "
   :args "+"
   :argname "<global>"
parser:flag "-q" "--quiet"
   :description "Suppress output. "
parser:flag "-g" "--no-global"
   :description "Do not check for accessing global variables. "
parser:flag "-r" "--no-redefined"
   :description "Do not check for redefined variables. "
parser:flag "-u" "--no-unused"
   :description "Do not check for unused variables. "
local args = parser:parse()

local globals

if args.globals then
   globals = {}

   for _, global in ipairs(args.globals) do
      globals[global] = true
   end
end

local options = {
   globals = globals,
   check_global = not args["no-global"],
   check_redefined = not args["no-redefined"],
   check_unused = not args["no-unused"]
}

local report = luacheck(args.files, options)

if not args.quiet then
   print(format(report))
end

os.exit(report.n == 0 and 0 or 1)