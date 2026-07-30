# csv2lua
Module for converting CSV files to LUA tables, and reverse.

Modules contains the following functions:

csv2lua.parse(filePath, separator, headers), returns table
csv2lua.toCsv(tb, separator, headers), returns string

filePath (string) = Path to CSV file
tb (table)        = Lua table to pass to function
separator (char)  = Separator used in the CSV
headers (boolean) = Whether the CSV contains headers

.parse() converts file contents to a table. The table is indexed by header if availible, and otherwise by number. No headers are assumed if not specified.

.toCsv() converts table contents into string. This string can be written straight to file to obtain a CSV. No headers are assumed if not specified.

All functions prints an error message and return nil if they encounter a problem.

Can be installed with luarocks

[source,bash]
----
git clone https://github.com/Dropkickx86/csv2lua.git
cd csv2lua
luarocks make
----
