local function getVersion(version)
    local versions = {}
    if versions[tostring(version)] == nil then
        return "/archive/refs/tags/"..tostring(version)..".tar.gz"
    end
    return versions[tostring(version)]
end

package("luau")
    set_homepage("https://luau-lang.org")
    set_description("A fast, small, safe, gradually typed embeddable scripting language derived from Lua")
    set_license("MIT")
    set_urls("https://github.com/luau-lang/luau/$(version)", {
        version = getVersion
    })

    --insert version
    add_versions("0.661", "d55c99c8df926c600eb2cf654aa5c1c357e2715bee6b2b6cdaeb13fbc45f3f9e")
    add_versions("0.660", "9953b520f3515e3aa09df3896b91dc32141eaddaaac08a4e3758bd53683036e0")
    add_versions("0.656", "c5523f2381b3a107a0a4f3746e27c93d598fcac4d49a9562199e55c3c481fb10")
    add_versions("0.655", "1c0ff05ce18493d6c83062a17cf6822a71ce254bfa0db41dd086d313b674ca33")
    add_versions("0.654", "b40d75580df0e23fde5d4bbe43806c1098a32ac59902895f367ff2a0c41c013e")
    
    add_configs("extern_c", {description = "extern C", default = false, type = "boolean"})
    add_configs("cli", {description = "cli", default = false, type = "boolean"})

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {
            extern_c = package:config("extern_c") and "y" or "n",
            cli = package:config("cli") and "y" or "n"
        }
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
