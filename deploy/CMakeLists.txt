
# 
# Target 'pack'
# 

add_custom_target(pack)
set_target_properties(pack PROPERTIES EXCLUDE_FROM_DEFAULT_BUILD 1)


# Install additional runtime dependencies
include(${PROJECT_SOURCE_DIR}/cmake/RuntimeDependencies.cmake)


# 
# Packages
# 

include(packages/pack-template.cmake)
