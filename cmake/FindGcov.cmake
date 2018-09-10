
# FindGcov results:
# GCOV_FOUND
# GCOV_EXECUTABLE

include(FindPackageHandleStandardArgs)

# work around CMP0053, see http://public.kitware.com/pipermail/cmake/2014-November/059117.html
set(PROGRAMFILES_x86_ENV "PROGRAMFILES(x86)")

find_program(GCOV_EXECUTABLE
    NAMES
        gcov
    PATHS
        "${GCOV_DIR}"
        "$ENV{GCOV_DIR}"
        "$ENV{PROGRAMFILES}/gcov"
        "$ENV{${PROGRAMFILES_x86_ENV}}/gcov"
)

find_package_handle_standard_args(Gcov
	FOUND_VAR
        Gcov_FOUND
    REQUIRED_VARS
        GCOV_EXECUTABLE
)

mark_as_advanced(GCOV_EXECUTABLE)
