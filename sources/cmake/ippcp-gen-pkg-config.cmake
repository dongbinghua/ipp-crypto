#===============================================================================
# Copyright (C) 2021 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions
# and limitations under the License.
# 
#===============================================================================

set(IPPCP_PC_LIB_NAME ippcp)
set(CRYPTO_MB_PC_LIB_NAME crypto_mb)

set(PREFIX_FOR_PC_FILE "\${pcfiledir}/../..")
set(INCDIR_FOR_PC_FILE "\${prefix}/${IPPCP_INC_REL_PATH}")
set(ARCH_TYPES "intel64;ia32")

if (WIN32)
    set(STATIC_LIBRARY_PREFIX "")
    set(STATIC_LIBRARY_SUFFIX "mt.lib")
else()
    set(STATIC_LIBRARY_PREFIX "lib")
    set(STATIC_LIBRARY_SUFFIX ".a")
endif()

if (APPLE)
    set(LIBDIR_FOR_PC_FILE "\${prefix}/${IPPCP_LIB_REL_PATH}")
    set(IPPCP_PC_LIB_NAME ippcp)

    configure_file("${IPP_CRYPTO_DIR}/sources/cmake/pkg-config/ippcp-static.pc.in" "${CMAKE_BINARY_DIR}/ippcp-static-intel64.pc" @ONLY)
    configure_file("${IPP_CRYPTO_DIR}/sources/cmake/pkg-config/ippcp-dynamic.pc.in" "${CMAKE_BINARY_DIR}/ippcp-dynamic-intel64.pc" @ONLY)
    configure_file("${IPP_CRYPTO_DIR}/sources/cmake/pkg-config/crypto_mb-static.pc.in" "${CMAKE_BINARY_DIR}/crypto_mb-static-intel64.pc" @ONLY)
    configure_file("${IPP_CRYPTO_DIR}/sources/cmake/pkg-config/crypto_mb-dynamic.pc.in" "${CMAKE_BINARY_DIR}/crypto_mb-dynamic-intel64.pc" @ONLY)
else()
    # pkg-config files for ippcp static libs
    set(LIBDIR_FOR_PC_FILE "\${prefix}/${IPPCP_LIB_REL_PATH}")
    configure_file("${IPP_CRYPTO_DIR}/sources/cmake/pkg-config/ippcp-static.pc.in" "${CMAKE_BINARY_DIR}/ippcp-static-intel64.pc" @ONLY)
    set(LIBDIR_FOR_PC_FILE "\${prefix}/${IPPCP_LIB32_REL_PATH}")
    configure_file("${IPP_CRYPTO_DIR}/sources/cmake/pkg-config/ippcp-static.pc.in" "${CMAKE_BINARY_DIR}/ippcp-static-ia32.pc" @ONLY)
    
    # Pkg-config file for crypto_mb static lib
    set(LIBDIR_FOR_PC_FILE "\${prefix}/${IPPCP_LIB_REL_PATH}")
    configure_file("${IPP_CRYPTO_DIR}/sources/cmake/pkg-config/crypto_mb-static.pc.in" "${CMAKE_BINARY_DIR}/crypto_mb-static-intel64.pc" @ONLY)

    # pkg-config files for static nonpic libs under Linux and dynamic libs
    if (WIN32)
        # ippcp dynamic libs
        set(LIBDIR_FOR_PC_FILE "\${prefix}/${IPPCP_BIN_REL_PATH}")
        configure_file("${IPP_CRYPTO_DIR}/sources/cmake/pkg-config/ippcp-dynamic.pc.in" "${CMAKE_BINARY_DIR}/ippcp-dynamic-intel64.pc" @ONLY)
        set(LIBDIR_FOR_PC_FILE "\${prefix}/${IPPCP_BIN32_REL_PATH}")
        configure_file("${IPP_CRYPTO_DIR}/sources/cmake/pkg-config/ippcp-dynamic.pc.in" "${CMAKE_BINARY_DIR}/ippcp-dynamic-ia32.pc" @ONLY)
        
        # crypto_mb dynamic lib
        set(LIBDIR_FOR_PC_FILE "\${prefix}/${IPPCP_BIN_REL_PATH}")
        configure_file("${IPP_CRYPTO_DIR}/sources/cmake/pkg-config/crypto_mb-dynamic.pc.in" "${CMAKE_BINARY_DIR}/crypto_mb-dynamic-intel64.pc" @ONLY)
    # Linux
    else() 
        # ippcp dynamic and static nonpic libs
        set(LIBDIR_FOR_PC_FILE "\${prefix}/${IPPCP_LIB_REL_PATH}/nonpic")
        configure_file("${IPP_CRYPTO_DIR}/sources/cmake/pkg-config/ippcp-static.pc.in" "${CMAKE_BINARY_DIR}/ippcp-static-intel64-nonpic.pc" @ONLY)
        set(LIBDIR_FOR_PC_FILE "\${prefix}/${IPPCP_LIB32_REL_PATH}/nonpic")
        configure_file("${IPP_CRYPTO_DIR}/sources/cmake/pkg-config/ippcp-static.pc.in" "${CMAKE_BINARY_DIR}/ippcp-static-ia32-nonpic.pc" @ONLY)
        set(LIBDIR_FOR_PC_FILE "\${prefix}/${IPPCP_LIB_REL_PATH}")
        configure_file("${IPP_CRYPTO_DIR}/sources/cmake/pkg-config/ippcp-dynamic.pc.in" "${CMAKE_BINARY_DIR}/ippcp-dynamic-intel64.pc" @ONLY)
        set(LIBDIR_FOR_PC_FILE "\${prefix}/${IPPCP_LIB32_REL_PATH}")
        configure_file("${IPP_CRYPTO_DIR}/sources/cmake/pkg-config/ippcp-dynamic.pc.in" "${CMAKE_BINARY_DIR}/ippcp-dynamic-ia32.pc" @ONLY)
        
        # crypto_mb dynamic lib
        set(LIBDIR_FOR_PC_FILE "\${prefix}/${IPPCP_LIB_REL_PATH}")
        configure_file("${IPP_CRYPTO_DIR}/sources/cmake/pkg-config/crypto_mb-dynamic.pc.in" "${CMAKE_BINARY_DIR}/crypto_mb-dynamic-intel64.pc" @ONLY)
    endif(WIN32)
endif(APPLE)


install(FILES
    "${CMAKE_BINARY_DIR}/ippcp-static-intel64.pc"
    "${CMAKE_BINARY_DIR}/ippcp-dynamic-intel64.pc"
    "${CMAKE_BINARY_DIR}/crypto_mb-static-intel64.pc"
    "${CMAKE_BINARY_DIR}/crypto_mb-dynamic-intel64.pc"
    "${CMAKE_BINARY_DIR}/ippcp-static-intel64-nonpic.pc"
    DESTINATION "lib/pkgconfig"
    OPTIONAL)

install(FILES
    "${CMAKE_BINARY_DIR}/ippcp-static-ia32.pc"
    "${CMAKE_BINARY_DIR}/ippcp-dynamic-ia32.pc"
    "${CMAKE_BINARY_DIR}/ippcp-static-ia32-nonpic.pc"
    DESTINATION "lib32/pkgconfig"
    OPTIONAL)

# FIXME: temporary until infra migrates to a build structure generated by 'make install'
foreach( OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})
    string( TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG )
    
    if ("${ARCH}" STREQUAL "intel64")
        file(COPY  "${CMAKE_BINARY_DIR}/ippcp-static-intel64.pc"
                   "${CMAKE_BINARY_DIR}/ippcp-dynamic-intel64.pc"
                   "${CMAKE_BINARY_DIR}/crypto_mb-static-intel64.pc"
                   "${CMAKE_BINARY_DIR}/crypto_mb-dynamic-intel64.pc"
            DESTINATION "${CMAKE_OUTPUT_DIR}/${OUTPUTCONFIG}/pkgconfig")

        # Linux nonpic libs
        if(UNIX AND NOT APPLE)
            file(COPY  "${CMAKE_BINARY_DIR}/ippcp-static-intel64-nonpic.pc"
                DESTINATION "${CMAKE_OUTPUT_DIR}/${OUTPUTCONFIG}/pkgconfig")
        endif(UNIX AND NOT APPLE)
    else()
        file(COPY  "${CMAKE_BINARY_DIR}/ippcp-static-ia32.pc"
                   "${CMAKE_BINARY_DIR}/ippcp-dynamic-ia32.pc"
            DESTINATION "${CMAKE_OUTPUT_DIR}/${OUTPUTCONFIG}/pkgconfig")
        
        # Linux nonpic libs
        if(UNIX)
            file(COPY  "${CMAKE_BINARY_DIR}/ippcp-static-ia32-nonpic.pc"
                DESTINATION "${CMAKE_OUTPUT_DIR}/${OUTPUTCONFIG}/pkgconfig")
        endif(UNIX)
    endif("${ARCH}" STREQUAL "intel64") 

endforeach( OUTPUTCONFIG CMAKE_CONFIGURATION_TYPES )
