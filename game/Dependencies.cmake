include(../cmake/CPM.cmake)
include(ExternalProject)

function(GAPing_find_or_fetch package target cpm_spec)
  if(NOT TARGET ${target})
    find_package(${package} CONFIG QUIET)
  endif()

  if(NOT TARGET ${target})
    cpmaddpackage(${cpm_spec})
  endif()
endfunction()

function(GAPing_setup_dependencies)
  #GAPing_find_or_fetch(fmt fmt::fmt "gh:fmtlib/fmt#12.1.0")
  #GAPing_find_or_fetch(spdlog spdlog::spdlog "gh:gabime/spdlog@1.17.0")
  #GAPing_find_or_fetch(CLI11 CLI11::CLI11 "gh:CLIUtils/CLI11@2.6.1")
  #GAPing_find_or_fetch(ftxui ftxui::screen "gh:ArthurSonzogni/FTXUI@6.1.9")
  #GAPing_find_or_fetch(Catch2 Catch2::Catch2WithMain "gh:catchorg/Catch2@3.12.0")


  GAPing_find_or_fetch(cpptrace cpptrace::cpptrace "gh:jeremy-rifkin/cpptrace@1.0.4")
  #GAPing_find_or_fetch(glog glog::glog "gh:google/glog@0.7.1")

  GAPing_find_or_fetch(ng-log ng-log::ng-log "gh:ng-log/ng-log@0.7.1")
  #find_package(onnxruntime CONFIG REQUIRED)
  
  # GAPing_find_or_fetch(ccache ccache "gh:ccache/ccache@4.13.2")
  # GAPing_find_or_fetch(npcap npcap "gh:nmap/npcap@1.87")
  # GAPing_find_or_fetch(pcap pcap "gh:the-tcpdump-group/libpcap#f2972724f5639e793e035e6a679d8cce60c15dbd")
  #GAPing_find_or_fetch(PcapPlusPlus PcapPlusPlus::Pcap++ "gh:seladb/PcapPlusPlus@25.05")
  #GAPing_find_or_fetch(libtins tins "")
  #set(PCAP_ROOT_DIR ${CMAKE_BINARY_DIR}/vcpkg_installed/x64-windows/)
  #GAPing_find_or_fetch(peafowl peafowl "gh:DanieleDeSensi/peafowl#dd8f8b78c936023ebcd824cad312ef8668679fe0")
  #add_subdirectory(${CMAKE_SOURCE_DIR}/thirdparty/peafowl)

  # ExternalProject_Add(
  #   external_make_project
  #   SOURCE_DIR "${CMAKE_SOURCE_DIR}/thirdparty/nDPI"  # Путь к исходникам проекта
  #   CONFIGURE_COMMAND ""                                       # Этап конфигурации не нужен
  #   BUILD_COMMAND make -C <SOURCE_DIR> ${MAKE_TARGET}          # Команда для сборки (можно указать конкретную цель, например, libfoo.a)
  #   INSTALL_COMMAND ""                                         # Этап установки не нужен
  # )

  # unset(spdlog_target)
  # if(TARGET spdlog::spdlog_header_only)
  #   get_target_property(spdlog_target spdlog::spdlog_header_only ALIASED_TARGET)
  #   if(NOT spdlog_target)
  #     set(spdlog_target spdlog::spdlog_header_only)
  #   endif()
  # elseif(TARGET spdlog::spdlog)
  #   get_target_property(spdlog_target spdlog::spdlog ALIASED_TARGET)
  #   if(NOT spdlog_target)
  #     set(spdlog_target spdlog::spdlog)
  #   endif()
  # endif()

  # if(spdlog_target)
  #   target_compile_definitions(${spdlog_target} INTERFACE SPDLOG_FMT_EXTERNAL)
  # endif()
endfunction()
