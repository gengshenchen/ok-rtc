add_library(libwebrtcbuild INTERFACE)
add_library(ok-rtc::libwebrtcbuild ALIAS libwebrtcbuild)

target_link_libraries(libwebrtcbuild
INTERFACE
    ok-rtc::libyuv
)
if (NOT absl_FOUND)
    target_link_libraries(libwebrtcbuild INTERFACE ok-rtc::libabsl)
endif()

target_compile_definitions(libwebrtcbuild
INTERFACE
    $<$<NOT:$<CONFIG:Debug>>:NDEBUG>
    WEBRTC_ENABLE_PROTOBUF=0
    WEBRTC_APM_DEBUG_DUMP=0
    WEBRTC_USE_BUILTIN_ISAC_FLOAT
    WEBRTC_OPUS_VARIABLE_COMPLEXITY=0
    WEBRTC_OPUS_SUPPORT_120MS_PTIME=1
    WEBRTC_INCLUDE_INTERNAL_AUDIO_DEVICE
    WEBRTC_USE_H264
    WEBRTC_LIBRARY_IMPL
    WEBRTC_NON_STATIC_TRACE_EVENT_HANDLERS=1
    WEBRTC_HAVE_DCSCTP
    WEBRTC_HAVE_SCTP
    NO_MAIN_THREAD_WRAPPING
    HAVE_WEBRTC_VIDEO
    RTC_ENABLE_H265
    RTC_ENABLE_VP9
    RTC_DISABLE_TRACE_EVENTS
    BWE_TEST_LOGGING_COMPILE_TIME_ENABLE=0
)

if (OK_RTC_USE_X11)
    target_compile_definitions(libwebrtcbuild
    INTERFACE
        WEBRTC_USE_X11
    )
endif()

if (OK_RTC_USE_PIPEWIRE)
    target_compile_definitions(libwebrtcbuild
    INTERFACE
        WEBRTC_USE_PIPEWIRE
    )
endif()

if (NOT OK_RTC_BUILD_AUDIO_BACKENDS)
    target_compile_definitions(libwebrtcbuild
    INTERFACE
        WEBRTC_DUMMY_AUDIO_BUILD
    )
elseif (UNIX AND NOT APPLE)
    target_compile_definitions(libwebrtcbuild
    INTERFACE
        WEBRTC_ENABLE_LINUX_ALSA
        WEBRTC_ENABLE_LINUX_PULSE
    )
endif()

if (WIN32)
    target_compile_definitions(libwebrtcbuild
    INTERFACE
        WEBRTC_WIN
        RTC_ENABLE_WIN_WGC
    )
else()
    target_compile_definitions(libwebrtcbuild
    INTERFACE
        WEBRTC_POSIX
    )

    if (APPLE)
        target_compile_definitions(libwebrtcbuild
        INTERFACE
            WEBRTC_MAC
        )
        target_link_options(libwebrtcbuild
        INTERFACE
            -ObjC
        )
    endif()

    if (CMAKE_SYSTEM_NAME STREQUAL "Linux")
        target_compile_definitions(libwebrtcbuild
        INTERFACE
            WEBRTC_LINUX
        )
    elseif (CMAKE_SYSTEM_NAME STREQUAL "FreeBSD")
        target_compile_definitions(libwebrtcbuild
        INTERFACE
            WEBRTC_FREEBSD
        )
    elseif (CMAKE_SYSTEM_NAME STREQUAL "OpenBSD")
        target_compile_definitions(libwebrtcbuild
        INTERFACE
            WEBRTC_OPENBSD
        )
    endif()
endif()

target_include_directories(libwebrtcbuild
INTERFACE
    $<BUILD_INTERFACE:${webrtc_loc}>
    $<INSTALL_INTERFACE:${webrtc_includedir}>
)
