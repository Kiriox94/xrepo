add_rules("mode.debug", "mode.release")

option("installdir")
    if is_plat("windows", "mingw") then
        set_default("C:\\Program Files\\OpenSSL")
    else
        set_default("/usr/local/ssl")
    end
    set_description("openssl install dir")
    set_showmenu(true)
option_end()


if is_plat("windows", "mingw") then
    add_cflags("/TC", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
    add_defines("UNICODE", "_UNICODE")
end

set_encodings("utf-8")
add_requires("zeromake.rules")

local function plat_path_join(...)
    local p = path.join(...):gsub("\\", "/")
    return p
end

local openssldir = get_config("installdir") or "/usr/local/ssl"
local openssllibdir = plat_path_join(get_config("installdir"), "lib")
local disable_asm = false

if is_plat("windows") and is_arch("arm64.*", "x86") then
    disable_asm = true
end

if is_plat("windows", "mingw") then
    add_defines("WIN32_LEAN_AND_MEAN", "DSO_WIN32")
end
add_defines(
    "OPENSSLDIR=\""..openssldir.."\"",
    "ENGINESDIR=\""..plat_path_join(openssllibdir, "engines-81.3").."\"",
    "MODULESDIR=\""..plat_path_join(openssllibdir, "ossl-modules").."\"",
    "OPENSSL_BUILDING_OPENSSL",
    "STATIC_LEGACY"
)

if is_plat("windows") and is_arch("arm64.*") then
    add_defines(
        "L_ENDIAN",
        "OPENSSL_PIC",
        "OPENSSL_SYS_WIN32",
        "OPENSSL_SYS_WIN_CORE",
        "_ARM_WINAPI_PARTITION_DESKTOP_SDK_AVAILABLE",
        "_CRT_SECURE_NO_DEPRECATE"
    )
elseif is_arch("arm64.*") then
    add_defines(
        "OPENSSL_PIC",
        "BSAES_ASM",
        "ECP_NISTZ256_ASM",
        "ECP_SM2P256_ASM",
        "KECCAK1600_ASM",
        "OPENSSL_CPUID_OBJ",
        "SHA1_ASM",
        "SHA256_ASM",
        "SHA512_ASM",
        "SM4_ASM",
        "VPAES_ASM",
        "VPSM4_ASM",
        "OPENSSL_USE_NODELETE"
    )
elseif is_arch("x86_64", "x64") then
    add_defines(
        "OPENSSL_PIC",
        "L_ENDIAN",
        "_REENTRANT",
        "AES_ASM",
        "BSAES_ASM",
        "CMLL_ASM",
        "ECP_NISTZ256_ASM",
        "GHASH_ASM",
        "KECCAK1600_ASM",
        "MD5_ASM",
        "OPENSSL_BN_ASM_GF2m",
        "OPENSSL_BN_ASM_MONT",
        "OPENSSL_BN_ASM_MONT5",
        "OPENSSL_CPUID_OBJ",
        "OPENSSL_IA32_SSE2",
        "POLY1305_ASM",
        "RC4_ASM",
        "SHA1_ASM",
        "SHA256_ASM",
        "SHA512_ASM",
        "VPAES_ASM",
        "WHIRLPOOL_ASM",
        "X25519_ASM"
    )
end

add_includedirs("build/generate/include", "build/generate/providers/common/include", "crypto", ".", "include")

local crypto_dirs = {
    "crypto/aes",
    "crypto/aria",
    "crypto/asn1",
    "crypto/async",
    "crypto/async/arch",
    "crypto/bf",
    "crypto/bio",
    "crypto/bn",
    "crypto/buffer",
    "crypto/camellia",
    "crypto/cast",
    "crypto/cmac",
    "crypto/cmp",
    "crypto/cms",
    "crypto/comp",
    "crypto/conf",
    "crypto/crmf",
    "crypto/ct",
    "crypto/des",
    "crypto/dh",
    "crypto/dsa",
    "crypto/dso",
    "crypto/encode_decode",
    "crypto/engine",
    "crypto/err",
    "crypto/ess",
    "crypto/ffc",
    "crypto/hmac",
    "crypto/hpke",
    "crypto/http",
    "crypto/idea",
    "crypto/kdf",
    "crypto/lhash",
    "crypto/md4",
    "crypto/md5",
    "crypto/mdc2",
    "crypto/modes",
    "crypto/objects",
    "crypto/ocsp",
    "crypto/pem",
    -- "crypto/perlasm",
    "crypto/pkcs12",
    "crypto/pkcs7",
    "crypto/property",
    "crypto/rand",
    "crypto/rc2",
    "crypto/rc4",
    "crypto/ripemd",
    "crypto/seed",
    "crypto/sha",
    "crypto/siphash",
    "crypto/sm2",
    "crypto/sm3",
    "crypto/sm4",
    "crypto/srp",
    "crypto/stack",
    "crypto/store",
    "crypto/thread",
    "crypto/thread/arch",
    "crypto/ts",
    "crypto/txt_db",
    "crypto/ui",
    "crypto/whrlpool",
    "crypto/x509",

    "providers",
    "providers/common",
    "providers/common/der",
    "providers/implementations/asymciphers",
    "providers/implementations/ciphers",
    "providers/implementations/digests",
    "providers/implementations/encode_decode",
    "providers/implementations/exchange",
    "providers/implementations/kdfs",
    "providers/implementations/kem",
    "providers/implementations/keymgmt",
    "providers/implementations/macs",
    "providers/implementations/rands",
    "providers/implementations/rands/seeding",
    "providers/implementations/signature",
    "providers/implementations/storemgmt",

    "crypto",
    "crypto/ec",
    "crypto/ec/curve448",
    "crypto/ec/curve448/arch_32",
    "crypto/ec/curve448/arch_64",
    "crypto/evp",
    "crypto/poly1305",
    "crypto/rsa",

    "engines",

    "build/generate/providers/common/der",
    "build/generate/crypto",
}

local crypto_asm_dirs = {
    "crypto"
}

if is_arch("x86_64", "x64") then
    table.join2(crypto_asm_dirs, {
        "crypto/aes",
        "crypto/bn",
        "crypto/camellia",
        "crypto/chacha",
        "crypto/ec",
        "crypto/md5",
        "crypto/modes",
        "crypto/poly1305",
        "crypto/rc4",
        "crypto/sha",
        "crypto/whrlpool"
    })
elseif is_arch("arm64.*") then
    table.join2(crypto_asm_dirs, {
        "crypto/aes",
        "crypto/bn",
        "crypto/chacha",
        "crypto/ec",
        "crypto/md5",
        "crypto/modes",
        "crypto/sha",
        "crypto/sm3",
        "crypto/sm4"
    })
end

target("crypto")
    set_kind("$(kind)")
    add_packages("zeromake.rules")
    add_includedirs("providers/common/include", "providers/implementations/include")
    add_rules("@zeromake.rules/export_symbol", {file = 'scripts/crypto.sym'})
    for _, dir in ipairs(crypto_dirs) do
        add_files(path.join(dir, "*.c"))
    end
    local asmext = "*.S"
    if is_plat("windows") then
        asmext = "*.asm"
        add_syslinks("user32", "ws2_32", "advapi32", "crypt32", {public = true})
    end
    if not disable_asm then
        for _, dir in ipairs(crypto_asm_dirs) do
            add_files(path.join("build", "generate", dir, asmext))
        end
    end
    add_files(
        "ssl/record/methods/ssl3_cbc.c",
        "ssl/record/methods/tls_pad.c"
    )
    if is_plat("windows") and is_arch("x86_64", "x64") then
        remove_files(
            "crypto/LPdir_*.c",
            "crypto/loongarchcap.c",
            "crypto/ppccap.c",
            "crypto/sparcv9cap.c",
            "crypto/riscvcap.c",
            "crypto/s390xcap.c",
            "crypto/ec/ecx_s390x.c",
            "crypto/evp/legacy_md2.c",
            "crypto/poly1305/poly1305_base2_44.c",
            "crypto/poly1305/poly1305_ppc.c",
            "crypto/rsa/rsa_acvp_test_params.c",
            "crypto/ec/ecp_nistz256_table.c",
            "crypto/ec/ecp_s390x_nistp.c",
            "crypto/sha/sha_ppc.c",
            "crypto/sha/sha_riscv.c",
            "crypto/bn/bn_sparc.c",
            "crypto/bn/bn_ppc.c",
            "crypto/sm3/sm3_riscv.c",

            "crypto/ec/ecp_ppc.c",
            "crypto/aes/aes_x86core.c",
            "crypto/poly1305/poly1305_ieee754.c",
            "crypto/mem_clr.c",
            "crypto/sha/keccak1600.c",
            "crypto/des/ncbc_enc.c",
            
            "providers/common/securitycheck_fips.c",
            "providers/implementations/digests/md2_prov.c",
            "providers/implementations/rands/seeding/rand_vms.c",
            "providers/implementations/rands/seeding/rand_vxworks.c",
            "providers/implementations/macs/blake2_mac_impl.c",
            "providers/implementations/ciphers/cipher_rc5_hw.c",
            "providers/implementations/ciphers/cipher_rc5.c",

            "engines/e_devcrypto.c",
            "engines/e_afalg.c",
            "engines/e_padlock.c",
            "engines/e_capi.c",
            "engines/e_dasync.c",
            "engines/e_ossltest.c",
            "engines/e_loader_attic.c",

            "crypto/armcap.c",
            "crypto/ec/ecp_sm2p256_table.c",
            "crypto/ec/ecp_sm2p256.c",
            "crypto/rc4/rc4_skey.c",
            "crypto/rc4/rc4_enc.c",
            "crypto/aes/aes_cbc.c",
            "crypto/aes/aes_core.c",
            "crypto/camellia/cmll_cbc.c",
            "crypto/camellia/camellia.c",
            "crypto/whrlpool/wp_block.c",
            
            "crypto/ec/ecp_nistp224.c",
            "crypto/ec/ecp_nistp256.c",
            "crypto/ec/ecp_nistp384.c",
            "crypto/ec/ecp_nistp521.c"
        )
    elseif is_plat("windows") and is_arch("arm64.*") then
        add_files("crypto/chacha/chacha_enc.c")
        remove_files(
            "crypto/LPdir_*.c",
            "crypto/loongarchcap.c",
            "crypto/ppccap.c",
            "crypto/sparcv9cap.c",
            "crypto/riscvcap.c",
            "crypto/s390xcap.c",
            "crypto/ec/ecx_s390x.c",
            "crypto/evp/legacy_md2.c",
            "crypto/poly1305/poly1305_base2_44.c",
            "crypto/poly1305/poly1305_ppc.c",
            "crypto/rsa/rsa_acvp_test_params.c",
            "crypto/ec/ecp_nistz256_table.c",
            "crypto/ec/ecp_s390x_nistp.c",
            "crypto/sha/sha_ppc.c",
            "crypto/sha/sha_riscv.c",
            "crypto/bn/bn_sparc.c",
            "crypto/bn/bn_ppc.c",
            "crypto/sm3/sm3_riscv.c",

            "crypto/ec/ecp_ppc.c",
            "crypto/aes/aes_x86core.c",
            "crypto/poly1305/poly1305_ieee754.c",
            "crypto/des/ncbc_enc.c",
            
            "providers/common/securitycheck_fips.c",
            "providers/implementations/digests/md2_prov.c",
            "providers/implementations/rands/seeding/rand_vms.c",
            "providers/implementations/rands/seeding/rand_vxworks.c",
            "providers/implementations/macs/blake2_mac_impl.c",
            "providers/implementations/ciphers/cipher_rc5_hw.c",
            "providers/implementations/ciphers/cipher_rc5.c",

            "engines/e_devcrypto.c",
            "engines/e_afalg.c",
            "engines/e_padlock.c",
            "engines/e_capi.c",
            "engines/e_dasync.c",
            "engines/e_ossltest.c",
            "engines/e_loader_attic.c",
            
            "crypto/ec/ecp_nistp224.c",
            "crypto/ec/ecp_nistp256.c",
            "crypto/ec/ecp_nistp384.c",
            "crypto/ec/ecp_nistp521.c"
        )
    elseif is_plat("windows") and is_arch("x86") then
        add_files("crypto/chacha/chacha_enc.c")
        remove_files(
            "crypto/LPdir_*.c",
            "crypto/loongarchcap.c",
            "crypto/ppccap.c",
            "crypto/sparcv9cap.c",
            "crypto/riscvcap.c",
            "crypto/s390xcap.c",
            "crypto/ec/ecx_s390x.c",
            "crypto/evp/legacy_md2.c",
            "crypto/poly1305/poly1305_base2_44.c",
            "crypto/poly1305/poly1305_ppc.c",
            "crypto/rsa/rsa_acvp_test_params.c",
            "crypto/ec/ecp_nistz256_table.c",
            "crypto/ec/ecp_s390x_nistp.c",
            "crypto/sha/sha_ppc.c",
            "crypto/sha/sha_riscv.c",
            "crypto/bn/bn_sparc.c",
            "crypto/bn/bn_ppc.c",
            "crypto/sm3/sm3_riscv.c",

            "crypto/ec/ecp_ppc.c",
            "crypto/poly1305/poly1305_ieee754.c",
            "crypto/des/ncbc_enc.c",
            
            "providers/common/securitycheck_fips.c",
            "providers/implementations/digests/md2_prov.c",
            "providers/implementations/rands/seeding/rand_vms.c",
            "providers/implementations/rands/seeding/rand_vxworks.c",
            "providers/implementations/macs/blake2_mac_impl.c",
            "providers/implementations/ciphers/cipher_rc5_hw.c",
            "providers/implementations/ciphers/cipher_rc5.c",

            "engines/e_devcrypto.c",
            "engines/e_afalg.c",
            "engines/e_padlock.c",
            "engines/e_capi.c",
            "engines/e_dasync.c",
            "engines/e_ossltest.c",
            "engines/e_loader_attic.c",

            "crypto/armcap.c",
            "crypto/ec/ecp_sm2p256_table.c",
            "crypto/ec/ecp_sm2p256.c",
            "crypto/aes/aes_core.c",
            
            "crypto/ec/ecp_nistp224.c",
            "crypto/ec/ecp_nistp256.c",
            "crypto/ec/ecp_nistp384.c",
            "crypto/ec/ecp_nistp521.c"
        )
    elseif is_plat("macosx") and is_arch("x86_64", "x64") then
        remove_files(
            "crypto/LPdir_*.c",
            "crypto/loongarchcap.c",
            "crypto/ppccap.c",
            "crypto/sparcv9cap.c",
            "crypto/riscvcap.c",
            "crypto/s390xcap.c",
            "crypto/ec/ecx_s390x.c",
            "crypto/evp/legacy_md2.c",
            "crypto/poly1305/poly1305_base2_44.c",
            "crypto/poly1305/poly1305_ppc.c",
            "crypto/rsa/rsa_acvp_test_params.c",
            "crypto/ec/ecp_nistz256_table.c",
            "crypto/ec/ecp_s390x_nistp.c",
            "crypto/sha/sha_ppc.c",
            "crypto/sha/sha_riscv.c",
            "crypto/bn/bn_sparc.c",
            "crypto/bn/bn_ppc.c",
            "crypto/sm3/sm3_riscv.c",

            "crypto/ec/ecp_ppc.c",
            "crypto/aes/aes_x86core.c",
            "crypto/poly1305/poly1305_ieee754.c",
            "crypto/sha/keccak1600.c",
            "crypto/mem_clr.c",
            "crypto/des/ncbc_enc.c",
            
            "providers/common/securitycheck_fips.c",
            "providers/implementations/digests/md2_prov.c",
            "providers/implementations/rands/seeding/rand_vms.c",
            "providers/implementations/rands/seeding/rand_vxworks.c",
            "providers/implementations/macs/blake2_mac_impl.c",
            "providers/implementations/ciphers/cipher_rc5_hw.c",
            "providers/implementations/ciphers/cipher_rc5.c",

            "engines/e_devcrypto.c",
            "engines/e_afalg.c",
            "engines/e_padlock.c",
            "engines/e_capi.c",
            "engines/e_dasync.c",
            "engines/e_ossltest.c",
            "engines/e_loader_attic.c",

            "crypto/armcap.c",
            "crypto/ec/ecp_sm2p256_table.c",
            "crypto/ec/ecp_sm2p256.c",
            "crypto/rc4/rc4_skey.c",
            "crypto/rc4/rc4_enc.c",
            "crypto/aes/aes_cbc.c",
            "crypto/aes/aes_core.c",
            "crypto/camellia/cmll_cbc.c",
            "crypto/camellia/camellia.c",
            "crypto/whrlpool/wp_block.c",

            "providers/implementations/storemgmt/winstore_store.c"
        )
    elseif is_plat("macosx") and is_arch("arm64") then
        remove_files(
            "crypto/LPdir_*.c",
            "crypto/loongarchcap.c",
            "crypto/ppccap.c",
            "crypto/sparcv9cap.c",
            "crypto/riscvcap.c",
            "crypto/s390xcap.c",
            "crypto/ec/ecx_s390x.c",
            "crypto/evp/legacy_md2.c",
            "crypto/poly1305/poly1305_base2_44.c",
            "crypto/poly1305/poly1305_ppc.c",
            "crypto/rsa/rsa_acvp_test_params.c",
            "crypto/ec/ecp_nistz256_table.c",
            "crypto/ec/ecp_s390x_nistp.c",
            "crypto/sha/sha_ppc.c",
            "crypto/sha/sha_riscv.c",
            "crypto/bn/bn_sparc.c",
            "crypto/bn/bn_ppc.c",
            "crypto/sm3/sm3_riscv.c",

            "crypto/ec/ecp_ppc.c",
            "crypto/aes/aes_x86core.c",
            "crypto/poly1305/poly1305_ieee754.c",
            "crypto/des/ncbc_enc.c",
            
            "providers/common/securitycheck_fips.c",
            "providers/implementations/digests/md2_prov.c",
            "providers/implementations/rands/seeding/rand_vms.c",
            "providers/implementations/rands/seeding/rand_vxworks.c",
            "providers/implementations/macs/blake2_mac_impl.c",
            "providers/implementations/ciphers/cipher_rc5_hw.c",
            "providers/implementations/ciphers/cipher_rc5.c",

            "engines/e_devcrypto.c",
            "engines/e_afalg.c",
            "engines/e_padlock.c",
            "engines/e_capi.c",
            "engines/e_dasync.c",
            "engines/e_ossltest.c",
            "engines/e_loader_attic.c",

            "providers/implementations/storemgmt/winstore_store.c"
        )
    elseif is_arch("x86_64", "x64") then
        remove_files(
            "crypto/LPdir_*.c",
            "crypto/loongarchcap.c",
            "crypto/ppccap.c",
            "crypto/sparcv9cap.c",
            "crypto/riscvcap.c",
            "crypto/s390xcap.c",
            "crypto/ec/ecx_s390x.c",
            "crypto/evp/legacy_md2.c",
            "crypto/poly1305/poly1305_base2_44.c",
            "crypto/poly1305/poly1305_ppc.c",
            "crypto/rsa/rsa_acvp_test_params.c",
            "crypto/ec/ecp_nistz256_table.c",
            "crypto/ec/ecp_s390x_nistp.c",
            "crypto/sha/sha_ppc.c",
            "crypto/sha/sha_riscv.c",
            "crypto/bn/bn_sparc.c",
            "crypto/bn/bn_ppc.c",
            "crypto/sm3/sm3_riscv.c",

            "crypto/ec/ecp_ppc.c",
            "crypto/aes/aes_x86core.c",
            "crypto/poly1305/poly1305_ieee754.c",
            "crypto/sha/keccak1600.c",
            "crypto/mem_clr.c",
            "crypto/des/ncbc_enc.c",
            
            "providers/common/securitycheck_fips.c",
            "providers/implementations/digests/md2_prov.c",
            "providers/implementations/rands/seeding/rand_vms.c",
            "providers/implementations/rands/seeding/rand_vxworks.c",
            "providers/implementations/macs/blake2_mac_impl.c",
            "providers/implementations/ciphers/cipher_rc5_hw.c",
            "providers/implementations/ciphers/cipher_rc5.c",

            "engines/e_devcrypto.c",
            "engines/e_afalg.c",
            "engines/e_padlock.c",
            "engines/e_capi.c",
            "engines/e_dasync.c",
            "engines/e_ossltest.c",
            "engines/e_loader_attic.c",

            "crypto/armcap.c",
            "crypto/ec/ecp_sm2p256_table.c",
            "crypto/ec/ecp_sm2p256.c",
            "crypto/rc4/rc4_skey.c",
            "crypto/rc4/rc4_enc.c",
            "crypto/aes/aes_cbc.c",
            "crypto/aes/aes_core.c",
            "crypto/camellia/cmll_cbc.c",
            "crypto/camellia/camellia.c",
            "crypto/whrlpool/wp_block.c",

            "providers/implementations/storemgmt/winstore_store.c"
        )
    elseif is_arch("arm64.*") then
        remove_files(
            "crypto/LPdir_*.c",
            "crypto/loongarchcap.c",
            "crypto/ppccap.c",
            "crypto/sparcv9cap.c",
            "crypto/riscvcap.c",
            "crypto/s390xcap.c",
            "crypto/ec/ecx_s390x.c",
            "crypto/evp/legacy_md2.c",
            "crypto/poly1305/poly1305_base2_44.c",
            "crypto/poly1305/poly1305_ppc.c",
            "crypto/rsa/rsa_acvp_test_params.c",
            "crypto/ec/ecp_nistz256_table.c",
            "crypto/ec/ecp_s390x_nistp.c",
            "crypto/sha/sha_ppc.c",
            "crypto/sha/sha_riscv.c",
            "crypto/bn/bn_sparc.c",
            "crypto/bn/bn_ppc.c",
            "crypto/sm3/sm3_riscv.c",

            "crypto/ec/ecp_ppc.c",
            "crypto/aes/aes_x86core.c",
            "crypto/poly1305/poly1305_ieee754.c",
            "crypto/sha/keccak1600.c",
            "crypto/mem_clr.c",
            "crypto/des/ncbc_enc.c",
            
            "providers/common/securitycheck_fips.c",
            "providers/implementations/digests/md2_prov.c",
            "providers/implementations/rands/seeding/rand_vms.c",
            "providers/implementations/rands/seeding/rand_vxworks.c",
            "providers/implementations/macs/blake2_mac_impl.c",
            "providers/implementations/ciphers/cipher_rc5_hw.c",
            "providers/implementations/ciphers/cipher_rc5.c",

            "engines/e_devcrypto.c",
            "engines/e_afalg.c",
            "engines/e_padlock.c",
            "engines/e_capi.c",
            "engines/e_dasync.c",
            "engines/e_ossltest.c",
            "engines/e_loader_attic.c",

            "providers/implementations/storemgmt/winstore_store.c"
        )
    end
    

target("ssl")
    set_kind("$(kind)")
    add_deps("crypto")
    add_packages("zeromake.rules")
    add_rules("@zeromake.rules/export_symbol", {file = 'scripts/ssl.sym'})
    add_files(
        "ssl/*.c",
        "ssl/record/*.c",
        "ssl/record/methods/*.c",
        "ssl/rio/*.c",
        "ssl/statem/*.c"
    )
    remove_files(
        "ssl/record/methods/ktls_meth.c"
    )
    add_headerfiles("include/(openssl/*.h)", "build/generate/include/(openssl/*.h)")
