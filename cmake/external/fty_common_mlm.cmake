
add_dependecy(fty_common_mlm
    GIT          "https://github.com/42ity/fty-common-mlm.git"
    VERSION      "master"
    LIB_OUTPUT   "lib/libfty_common_mlm.so"
    DEPENDENCIES czmq mlm cxxtools fty_common_logging fty_common
)
