include(GetGitRevisionDescription)


# Create file "revision" which contains the current git revision ID and
# deploy this file during installation and packaging.

macro(create_revision_file FILENAME)

    # Add a revision file containing the git-head tag for cpack and install
    get_git_head_revision(GIT_REFSPEC GIT_SHA1)

    # Generate a shorter, googlelike variation for rev
    string(SUBSTRING ${GIT_SHA1} 0 12 GIT_REV)
    file(WRITE ${FILENAME} ${GIT_REV})

    # Install
    install(FILES ${FILENAME} DESTINATION ".")

endmacro()
