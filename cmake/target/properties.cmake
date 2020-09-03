set(ETN_POPULATED_PROPS
    INSTALL_DIR
    CMAKE_DIR
    CONFIG_DIR
    HEADERS_DIR
    CMAKE_EXPORT_FILE
    CMAKE_CONFIG_FILE
    CMAKE_VERSION_FILE
    CMAKE_PKG_FILE
)

function(etn_configure_file filename)
    cmake_parse_arguments(arg
        ""
        "TARGET;DESTINATION"
        ""
        ${ARGN}
    )

    set(targetProps
        NAME
        TYPE
    )

    get_filename_component(ext ${filename} EXT)
    get_filename_component(base ${filename} NAME_WE)
    string(REPLACE "." ";" ext ${ext})
    list(GET ext -1 last)

    if (last STREQUAL "in")
        list(REMOVE_AT ext -1)
        list(JOIN ext "." ext)

        if (arg_TARGET)
            foreach(prop ${targetProps})
                get_target_property(val ${arg_TARGET} ${prop})
                set(${prop} "${val}")
            endforeach()

            foreach(prop ${ETN_POPULATED_PROPS})
                etn_get_custom_property(val ${arg_TARGET} ${prop})
                set(${prop} "${val}")
            endforeach()
        endif()
        configure_file(${filename} ${base}${ext})
    endif()
    install(FILES ${base}${ext} DESTINATION ${arg_DESTINATION})
endfunction()

function(etn_get_custom_property var target name)
    get_target_property(type ${target} TYPE)
    if(type STREQUAL "INTERFACE_LIBRARY")
        get_target_property(_var ${target} INTERFACE_${name})
        set(${var} ${_var} PARENT_SCOPE)
    else()
        get_target_property(_var ${target} TARGET_${name})
        set(${var} ${_var} PARENT_SCOPE)
    endif()
endfunction()

function(etn_set_custom_property target name value)
    get_target_property(type ${target} TYPE)
    if(type STREQUAL "INTERFACE_LIBRARY")
        set_target_properties(${target} PROPERTIES INTERFACE_${name} "${value}")
    else()
        set_target_properties(${target} PROPERTIES TARGET_${name} "${value}")
    endif()
endfunction()

function(read_target_properties target)
    execute_process(
        COMMAND ${CMAKE_COMMAND} --help-property-list
        OUTPUT_VARIABLE propList
    )

    string(REPLACE ";" "\\\\;" propList "${propList}")
    string(REPLACE "\n" ";" propList "${propList}")
    list(FILTER propList EXCLUDE REGEX "^LOCATION$|^LOCATION_|_LOCATION$")
    list(REMOVE_DUPLICATES propList)

#    get_target_property(type ${target} TYPE)
#    if(type STREQUAL "INTERFACE_LIBRARY")
#    else()
#    endif()

    foreach(prop ${propList})
        string(REPLACE "<CONFIG>" "${CMAKE_BUILD_TYPE}" prop ${prop})
        get_target_property(propval ${target} ${prop})
        if (propval)
            get_target_property(propval ${target} ${prop})
            message ("${tgt} ${prop} = ${propval}")
        endif()
    endforeach()
endfunction()
