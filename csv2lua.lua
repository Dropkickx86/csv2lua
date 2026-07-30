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
        print("Unable to open file")
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
        --Check for EOL
        while fileLine:len() > 0 do
            --Get index of next separator
            local ptr = fileLine:find(separator)
            if (ptr == nil) then
                ptr = fileLine:len()
            else
                ptr = ptr - 1
            end
            --Save headers, if applicable
            if firstLine and headers then
                headersTable[indexCol] = fileLine:sub(1, ptr)
            else
                --Index with headers if availible
                if headers then
                    if headersTable[indexCol] == nil then headersTable[indexCol] = indexCol end
                    if ptr == 0 then
                        outputTable[indexRow][headersTable[indexCol]] = nil
                    else
                        outputTable[indexRow][headersTable[indexCol]] = fileLine:sub(1, ptr)
                    end
                --Index with numbers if headers are not availible
                else
                    if ptr == 0 then
                        outputTable[indexRow][indexCol] = nil
                    else
                        outputTable[indexRow][indexCol] = fileLine:sub(1, ptr)
                    end
                end
            end
            indexCol = indexCol + 1
            fileLine = fileLine:sub(ptr + 2)
        end
        --Read next line
        fileLine = file:read()
        if firstLine and headers then
            firstLine = false
        elseif firstLine then
            firstLine = false
            indexRow = indexRow + 1
        else
            indexRow = indexRow + 1
        end
    end
    --Close file, return result
    io.close(file)
    return outputTable
end

--TODO: currently doesn't work with tables with labels
function csv2lua.toCsv(tb, separator, headers)
    if tb == nil then
        print("Table not specified")
        return nil
    end
    if verifyTable(tb) then
        for i, v in pairs(tb) do
            tb[i] = table.concat(v, separator)
        end
        tb = table.concat(tb, "\n")
        return tb
    else
        print("Table verification failed")
    end
end

return csv2lua