
add_dependecy(fty_security_wallet
    GIT          "https://github.com/42ity/fty-security-wallet.git"
    VERSION      "master"
    LIB_OUTPUT   "lib/libfty_security_wallet.so"
    DEPENDENCIES mlm cxxtools fty_common_logging czmq fty_common_socket fty_common_messagebus fty_common_dto fty_lib_certificate
)
