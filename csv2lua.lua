local csv2lua = {}

function csv2lua.parse(filePath, separator)
    local file = io.open(filePath, "r")
    local outputTable = {}
    --Check that file exists
    if file ~= nil then
        --Read next line
        local temp = file:read()
        --If line is read, aka not EOF
        while temp ~= nil do
            local index = 1
            local indexName
            local charStart = 1
            local charEnd = 1
            --Check for EOL
            while temp:len() > charStart do
                --Read until separator
                while temp:sub(charEnd, charEnd) ~= separator do
                    charEnd = charEnd + 1
                end
                charEnd = charEnd - 1
                if indexName == nil then
                    indexName = temp:sub(charStart, charEnd)
                    outputTable[indexName] = {}
                else
                    if charStart > charEnd then
                        outputTable[indexName][index] = nil
                    else
                        outputTable[indexName][index] = temp:sub(charStart, charEnd)
                    end
                    index = index + 1
                end
                charStart = charEnd + 2
                charEnd = charEnd + 2
            end
            temp = file:read()
        end
    end
    io.close(file)
    return outputTable
end

return csv2lua