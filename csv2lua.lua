local csv2lua = {}

--Function to check that the provided table can be converted to CSV
local function verifyTable(table)
    for i, v in pairs(table) do
        if type(v) ~= "table" then
            print("Only two-dimentional tables can be converted to CSV")
            return false
        end
        for i, s in pairs(v) do
            if type(s) == "table" then
                print("Only two-dimentional tables can be converted to CSV")
                return false
            end
        end
    end
    return true
end

function csv2lua.parse(filePath, separator, headers)
    --Check that arguments are given
    if filePath == nil then
        print("Filepath not specified")
        return nil
    elseif separator == nil then
        print("Separator not specified")
        return nil
    end
    --Open file
    local file = io.open(filePath, "r")
    --Check that file exists
    if file == nil then
        print("unable to open file")
        return nil
    end
    --Create table where to store output value
    local outputTable = {}
    --If headers is not specified, set to false
    if headers == nil then headers = false end
    --Read first line
    local fileLine = file:read()
    local indexRow = 1
    local headersTable = {}
    local firstLine = true
    --If line is read, aka not EOF
    while fileLine ~= nil do
        outputTable[indexRow] = {}
        local indexCol = 1
        local charStart = 1
        local charEnd = 1
        --Check for EOL
        while fileLine:len() > charStart do
            --Read until separator or EOL
            while fileLine:sub(charEnd, charEnd) ~= separator and charEnd ~= fileLine:len() do
                charEnd = charEnd + 1
            end
            --Ignore separator
            charEnd = charEnd - 1
            --Save headers, if applicable
            if firstLine and headers then
                headersTable[indexCol] = fileLine:sub(charStart, charEnd)
            else
                --Index with headers if aavailible
                if headers then
                    if charStart > charEnd then
                        outputTable[indexRow][headersTable[indexCol]] = nil
                    else
                        outputTable[indexRow][headersTable[indexCol]] = fileLine:sub(charStart, charEnd)
                    end
                --Index with numbers if headers are not availible
                else
                    if charStart > charEnd then
                        outputTable[indexRow][indexCol] = nil
                    else
                        outputTable[indexRow][indexCol] = fileLine:sub(charStart, charEnd)
                    end
                end
            end
            indexCol = indexCol + 1
            charStart = charEnd + 2
            charEnd = charEnd + 2
        end
        --Read next line
        fileLine = file:read()
        if firstLine then
            firstLine = false
        else
            indexRow = indexRow + 1
        end
    end
    --Close file, return result
    io.close(file)
    return outputTable
end

function csv2lua.toCsv(tb, separator, headers)
    if tb == nil then
        print("Table not specified")
        return nil
    end
    if verifyTable(tb) then
        for i, v in pairs(tb) do
            tb[i] = table.concat(v, ";")
        end
        tb = table.concat(tb, "\n")
        return tb
    else
        print("Table verification failed")
    end
end

return csv2lua