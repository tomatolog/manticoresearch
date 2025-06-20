#=============================================================================
# Copyright 2017-2025, Manticore Software LTD (https://manticoresearch.com)
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# This file need to get RE2 library sources
# First it try 'traditional' way - find RE2 lib.
# Then (if it is not found) it try to look into ${LIBS_BUNDLE} for file named 're2-master.zip'
# It is supposed, that file (if any) contains github's master archive of RE2 sources.
# If no file found, it will  try to fetch it from github, address
# https://github.com/manticoresoftware/re2/archive/master.zip

set ( RE2_REPO "https://github.com/tomatolog/re2" )
set ( RE2_BRANCH "2025-06-19" ) # specific tag for reproducable builds
set ( RE2_SRC_MD5 "2f3707d50294bea2c506e42ffa95c406" )

set ( RE2_GITHUB "${RE2_REPO}/archive/${RE2_BRANCH}.zip" )
set ( RE2_BUNDLE "${LIBS_BUNDLE}/re2-${RE2_BRANCH}.zip" )

cmake_minimum_required ( VERSION 3.17 FATAL_ERROR )
include ( update_bundle )

# if it is allowed to use system library - try to use it
if (NOT WITH_RE2_FORCE_STATIC)
	find_package ( re2 MODULE QUIET )
	return_if_target_found ( re2::re2 "as default (sys or other) lib" )
endif ()

# determine destination folder where we expect pre-built re2
find_package ( re2 QUIET CONFIG )
return_if_target_found ( re2::re2 "found ready (no need to build)" )

# prepare sources
select_nearest_url ( RE2_PLACE re2 ${RE2_BUNDLE} ${RE2_GITHUB} )
fetch_and_check ( re2 ${RE2_PLACE} ${RE2_SRC_MD5} RE2_SRC )

# build
get_build ( RE2_BUILD re2 )
external_build ( re2 RE2_SRC RE2_BUILD )

# now it should find
find_package ( re2 REQUIRED CONFIG )
return_if_target_found ( re2::re2 "was built" )
