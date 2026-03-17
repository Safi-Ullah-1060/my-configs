local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("cpp", {

    s("#include", {
        t({ "#include <iostream>", "" }),
        t({ "using namespace std;", "", "" }),
        i(2), -- $2: extra includes/globals above main
        t({ "", "", "int main() {", "\t" }),
        i(1), -- $1: inside main body
        t({ "", "\treturn 0;", "}" }),
        i(0), -- $0: final resting position
    }),
})
