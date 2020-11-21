package = "check-permissions"
version = "1.0.0-1"
source = {
   url = "http://gitlab.publicsoftsolutions.com/devops/ps-check-permissions-plugin.git"
}
description = {
   homepage = "*** please enter a project homepage ***",
   license = "© 2020 PublicSoft"
}
build = {
   type = "builtin",
   modules = {
      ["kong.plugins.check-permissions.handler"] = "kong/plugins/check-permissions/handler.lua",
      ["kong.plugins.check-permissions.json"] = "kong/plugins/check-permissions/json.lua",
      ["kong.plugins.check-permissions.schema"] = "kong/plugins/check-permissions/schema.lua"
   }
}
