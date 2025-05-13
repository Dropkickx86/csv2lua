local csv2lua = {}

function csv2lua.parse(filePath, separator, headers)
    --If headers is not specified, set to false
    if headers == nil then headers = false end
    --Open file
    local file = io.open(filePath, "r")
    local outputTable = {}
    --Check that file exists
    if file ~= nil then
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
    end
    --Close file, return result
    io.close(file)
    return outputTable
end

return csv2lua