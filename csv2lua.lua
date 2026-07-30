local csv2lua = {}

--Function to check that the provided table can be converted to CSV
--@param tb Table
--@return boolean
local function verifyTable(tb)
    if tb == nil then
        print("Table is nil")
        return false
    end
    for _, row in pairs(tb) do
        if type(row) ~= "table" then
            print("Only two-dimentional tables can be converted to CSV")
            return false
        end
        for _, col in pairs(row) do
            if type(col) == "table" then
                print("Only two-dimentional tables can be converted to CSV")
                return false
            end
        end
    end
    return true
end

--Function for reading a CSV and creating a table with the values
--@param filepath Path to file
--@param separator Separator used in file
--@param Boolean if the data contains headers
--@return table|nil
function csv2lua.parse(filePath, separator, headers)
    if filePath == nil then
        print("Filepath not specified")
        return nil
    elseif separator == nil then
        print("Separator not specified")
        return nil
    end

    local f = io.open(filePath, "r")
    if f == nil then
        print("Unable to open file")
        return nil
    end
    
    local outputTb = {}
    local row = 1
    local headersTb = {}
    local firstLine = true
    if headers == nil then headers = false end
    
    local fLine = f:read()
    while fLine ~= nil do
        outputTb[row] = {}
        local col = 1
        while fLine:len() > 0 do
            local ptr = fLine:find(separator)
            if (ptr == nil) then
                ptr = fLine:len()
            else
                ptr = ptr - 1
            end
            
            if firstLine and headers then
                headersTb[col] = fLine:sub(1, ptr)
            else
                if headers then
                    if headersTb[col] == nil then headersTb[col] = col end
                    if ptr == 0 then
                        outputTb[row][headersTb[col]] = nil
                    else
                        outputTb[row][headersTb[col]] = fLine:sub(1, ptr)
                    end
                else
                    if ptr == 0 then
                        outputTb[row][col] = nil
                    else
                        outputTb[row][col] = fLine:sub(1, ptr)
                    end
                end
            end

            col = col + 1
            fLine = fLine:sub(ptr + 2)
        end

        fLine = f:read()
        if firstLine and headers then
            firstLine = false
        elseif firstLine then
            firstLine = false
            row = row + 1
        else
            row = row + 1
        end
    end
    
    io.close(f)
    return outputTb
end

--TODO: currently doesn't work with tables with labels
--Function to convert a table to a string in format of csv
--@param tb Table to convert
--@param separator What separator to use
--@param headers Boolean whether field names should be used as headers
--@return string|nil
function csv2lua.toCsv(tb, separator, headers)
    if verifyTable(tb) then
        local retVal = ""
        for _, row in pairs(tb) do
            for _, v in pairs(row) do
                retVal = retVal .. v .. separator
            end
            retVal = retVal:sub(1, retVal:len() - 1) .. "\n"
        end
        return retVal
    else
        print("Table verification failed")
        return nil
    end
end

return csv2lua