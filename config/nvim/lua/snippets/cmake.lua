-- ~/.config/nvim/lua/snippets/cmake.lua
-- Load with:
--   require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets" })

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("cmake", {
    s(
        { trig = "cminit", name = "CMake Boilerplate" },
        fmt(
            [[
cmake_minimum_required(VERSION 3.28)
project({proj} LANGUAGES CXX)

set(CMAKE_CXX_STANDARD {std})
set(CMAKE_CXX_STANDARD_REQUIRED ON)

file(GLOB SOURCES src/*.cpp)
add_executable({exe} {exe}.cpp ${{SOURCES}})
target_include_directories({exe} PRIVATE {inc})
    ]],
            {
                proj = i(1, "MyProject"),
                std = i(2, "17"),
                exe = i(3, "main"),
                inc = i(4, "/path/to/headers"),
            }
        )
    ),
})
