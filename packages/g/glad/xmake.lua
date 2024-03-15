package("glad")

    set_homepage("https://glad.dav1d.de/")
    set_description("Multi-Language Vulkan/GL/GLES/EGL/GLX/WGL Loader-Generator based on the official specs.")
    set_license("MIT")

    add_urls("https://github.com/Dav1dde/glad/archive/v$(version).tar.gz")
    add_versions("2.0.5", "850351f1960f3fed775f0b696d7f17615f306beb56be38a20423284627626df1")
    add_configs("api", {description = "gl:core", default = "gl:core", type = "string"})

    if is_plat("linux") then
        add_syslinks("dl")
    end

    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")
if is_plat("windows") then
    add_cxflags("/utf-8")
end

target("glad")
    set_kind("$(kind)")
    add_includedirs("gen/include")
    add_files("gen/src/*.c")
    add_headerfiles("gen/include/glad/*.h", {prefixdir = "glad"})
    add_headerfiles("gen/include/KHR/*.h", {prefixdir = "KHR"})
]], {encoding = "binary"})
        -- gen
        import("lib.detect.find_tool")
        local python = assert(find_tool("python3"), "python3 not found!")
        local api = package:config("api")
        os.vrunv(python.program, {"-m", "glad", "--out-path=gen", "--api="..api, "--merge"})
        local configs = {}
        import("package.tools.xmake").install(package, configs)
        local old_dir = os.cd(package:installdir("include/glad"))
        os.ln("gl.h", "glad.h")
        os.cd(old_dir)
    end)

    on_test(function (package)
        local api = package:config("api")
        assert(package:has_cfuncs("gladLoadGL", {includes = "glad/glad.h"}))
        -- assert(package:has_cfuncs("gladLoadGLES1", {includes = "glad/gl.h"}))
        -- assert(package:has_cfuncs("gladLoadGLES2", {includes = "glad/gl.h"}))
    end)
