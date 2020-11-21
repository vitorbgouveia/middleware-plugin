
local BasePlugin = require "kong.plugins.base_plugin"
local JSON = require "kong.plugins.middleware-plugin.json"

local string_format = string.format
local kong = kong
local error = error

local CheckPermissionsHandler = BasePlugin:extend()

CheckPermissionsHandler.VERSION  = "1.0.0"
CheckPermissionsHandler.PRIORITY = 900

function CheckPermissionsHandler:new()
  CheckPermissionsHandler.super.new(self, "middleware-plugin")
end

function compose_payload(conf)
  local headers = ngx.req.get_headers()
  headers["target_uri"] = ngx.var.request_uri
  headers["target_method"] = ngx.var.request_method

  local payload_body = [[{"headers":]] .. JSON:encode(headers) .. [[}]]
  
  local payload_headers = string_format(
    "POST %s HTTP/1.1\r\nHost: %s\r\nConnection: Keep-Alive\r\nContent-Type: application/json\r\nContent-Length: %s\r\n",
    conf.api_route, conf.api_host, #payload_body)

  return string_format("%s\r\n%s", payload_headers, payload_body)
end

local function check_permissions(conf)
  local sock = ngx.socket.tcp()
  sock:settimeout(10000)
  local ok = sock:connect(conf.api_host, tonumber(conf.api_port))
  local ok = sock:send(compose_payload(conf))
  local line = sock:receive("*l")
  local status_code = tonumber(string.match(line, "%s(%d%d%d)%s"))

  return status_code < 400
end

function CheckPermissionsHandler:access(conf)
  CheckPermissionsHandler.super.access(self)

  if not conf.run_on_preflight and kong.request.get_method() == "OPTIONS" then
    return
  end

  if conf.anonymous and kong.client.get_credential() then
    return
  end

  local ok, err = check_permissions(conf)
  if not ok then
    if conf.anonymous then
      local consumer_cache_key = kong.db.consumers:cache_key(conf.anonymous)
      local consumer, err      = kong.cache:get(consumer_cache_key, nil,
                                                kong.client.load_consumer,
                                                conf.anonymous, true)
      if err then
        return kong.response.exit(err.status, err.errors)
      end
    end
    return kong.response.exit(403, { message = 'Unauthorized' })
  end
end

return CheckPermissionsHandler
