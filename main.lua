local ssl = require("ssl")
local socket = require("socket")

local ipAddress = socket.dns.toip("localhost")

local whitelist = {
    "192.168.1.1",
    "192.168.1.2",
    "example.com",
    ipAddress
}

local function isWhitelisted(address)
    for _, addr in ipairs(whitelist) do
        if address == addr then
            return true
        end
    end
    return false
end

local function connect(address)
    
    if not isWhitelisted(address) then
        error("Connection to " .. address .. " not allowed")
    end
  
    local conn = socket.tcp()
    conn:settimeout(5)
    conn:connect(address, 443)
    conn = ssl.wrap(conn, {mode="client", protocol="tlsv1_2"})
    conn:dohandshake()

    return conn
end

local conn1 = connect("192.168.1.1")
local conn2 = connect("example.com")
local conn3 = connect(ipAddress)
