local typedefs = require "kong.db.schema.typedefs"

return {
  name = "middleware-plugin",
  fields = {
    { protocols = typedefs.protocols_http },
    { config = {
        type = "record",
        fields = {
          { api_host = typedefs.host },
          { api_port = typedefs.port({ default = 5010 }), },
          { api_route = { type = "string", len_min = 0, default = '/api/autorizar' }, },
    }, }, },
  }
}
