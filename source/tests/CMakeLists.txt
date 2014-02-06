
# this must be explicitly set.. not quitly if available.

set(TEMPLATE_TESTS "test")

macro(add_test_without_ctest target)

	add_dependencies(${TEMPLATE_TESTS} ${target})
	add_custom_command(TARGET ${TEMPLATE_TESTS} POST_BUILD 
		COMMAND cmake -E echo
		COMMAND echo run $<TARGET_FILE:${target}>:
		COMMAND $<TARGET_FILE:${target}>)

endmacro()


if(OPTION_BUILD_TESTS)
	find_package(GMOCK REQUIRED)
	find_package(GTEST REQUIRED)
endif()

if(GMOCK_FOUND AND GTEST_FOUND)

	set(TESTS_FOLDER "Tests")

	include_directories(
		${GMOCK_INCLUDE_DIR}
		${GTEST_INCLUDE_DIR}
	)

	add_subdirectory("fiblib-test")
	# ...	

	add_custom_target(${TEMPLATE_TESTS})
	add_test_without_ctest(fiblib-test)
	# ...

endif()
