local function getVersion(version)
    local versions ={
        ["2025.02.25-alpha"] = "archive/e1000de7d174af8f84935db9a59b365d1ae55d32.tar.gz",
        ["2025.03.05-alpha"] = "archive/db758697661c59718ae02786d667d24f94d3c88b.tar.gz",
        ["2025.03.10-alpha"] = "archive/63026450dedbf7d8aeee99d9086719f425b2bb4d.tar.gz",
        --insert getVersion
    }
    return versions[tostring(version)]
end

package("sdl3_shadercross")
    set_kind("binary")
    set_homepage("https://github.com/libsdl-org/SDL_shadercross")
    set_description("Shader translation library for SDL's GPU API. ")
    set_license("Zlib")
    set_urls("https://github.com/libsdl-org/SDL_shadercross/$(version)", {
        version = getVersion
    })
    --insert version
    add_versions("2025.03.10-alpha", "6c7cddf99dc0dee5dbe4a50aac1c3e8c492072d69e3ca7f8ae7544867896e8ad")
    add_versions("2025.03.05-alpha", "e7069ac732a9a22fa70cd29689d93d5743e50751094c471f30a9cf5f4a7c55b6")
    add_versions("2025.02.25-alpha", "85d355fcb4414c343817675be821112bbbab6720dac717b433346796c1b5c007")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
        os.cp("export_shared/*", package:installdir("bin"))
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
