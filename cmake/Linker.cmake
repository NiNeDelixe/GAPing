macro(GAPing_configure_linker project_name)
  set(GAPing_USER_LINKER_OPTION
    "DEFAULT"
      CACHE STRING "Linker to be used")
    set(GAPing_USER_LINKER_OPTION_VALUES "DEFAULT" "SYSTEM" "LLD" "GOLD" "BFD" "MOLD" "SOLD" "APPLE_CLASSIC" "MSVC")
  set_property(CACHE GAPing_USER_LINKER_OPTION PROPERTY STRINGS ${GAPing_USER_LINKER_OPTION_VALUES})
  list(
    FIND
    GAPing_USER_LINKER_OPTION_VALUES
    ${GAPing_USER_LINKER_OPTION}
    GAPing_USER_LINKER_OPTION_INDEX)

  if(${GAPing_USER_LINKER_OPTION_INDEX} EQUAL -1)
    message(
      STATUS
        "Using custom linker: '${GAPing_USER_LINKER_OPTION}', explicitly supported entries are ${GAPing_USER_LINKER_OPTION_VALUES}")
  endif()

  set_target_properties(${project_name} PROPERTIES LINKER_TYPE "${GAPing_USER_LINKER_OPTION}")
endmacro()
