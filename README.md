# csv2lua
Module for converting CSV files to LUA tables

Currently in an early stage.

Function parse takes path to the CSV and what separator is used and returns a LUA table with the data. If specified in function call that the CSV contains headers, the parse function will use them as indexes. No headers are assumed if not specified.
