
macro(add_test_without_ctest target)

	add_dependencies(test ${target})
	add_custom_command(TARGET test POST_BUILD 
		COMMAND cmake -E echo
		COMMAND cmake -E echo run $<TARGET_FILE:${target}>:
		COMMAND $<TARGET_FILE:${target}>)

endmacro()


# Design decision: tests are enabled by default. If the required components are not found,
# tests are disabled and a warning is printed, but configuration is still valid.
if(OPTION_BUILD_TESTS)
	find_package(GMOCK)
	find_package(GTEST)
	if(NOT GMOCK_FOUND OR NOT GTEST_FOUND)
		message(WARNING "Tests are enabled but could no be added due to missing gmock or gtest")
	endif()
endif()

if(OPTION_BUILD_TESTS AND GMOCK_FOUND AND GTEST_FOUND)

	set(TESTS_FOLDER "Tests")

	include_directories(
		${GMOCK_INCLUDE_DIR}
		${GTEST_INCLUDE_DIR}
	)

	add_subdirectory("fiblib-test")
	# ...	

	add_custom_target(test)
	add_test_without_ctest(fiblib-test)
	# ...

endif()
