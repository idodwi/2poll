if (CMAKE_CXX_COMPILER_ID MATCHES GNU)
	set(GENERAL_FLAGS "-pthread")

	if (ARMv8)
		set(GENERAL_FLAGS "${GENERAL_FLAGS} -mfix-cortex-a53-835769 -mfix-cortex-a53-843419")
	endif()

	if (DEV_WITH_TSAN)
		set(GENERAL_FLAGS "${GENERAL_FLAGS} -fno-omit-frame-pointer -fsanitize=thread")
	endif()

	if (DEV_WITH_UBSAN)
		set(GENERAL_FLAGS "${GENERAL_FLAGS} -fno-omit-frame-pointer -fsanitize=undefined")
	endif()

	if (DEV_WITH_ASAN)
		set(GENERAL_FLAGS "${GENERAL_FLAGS} -fno-omit-frame-pointer -fsanitize=address")
	endif()

	set(WARNING_FLAGS "-Wall -Wextra -Wcast-qual -Wlogical-op -Wundef -Wformat=2 -Wpointer-arith -Werror")

	if (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 7.5.0)
		set(WARNING_FLAGS "${WARNING_FLAGS} -Wstrict-overflow=2")
	endif()

	if (DISABLE_WARNINGS)
		set(WARNING_FLAGS "-w")
	endif()

	if (DEV_WITH_TSAN OR DEV_WITH_UBSAN OR DEV_WITH_ASAN)
		set(OPTIMIZATION_FLAGS "-Og -g")
	else()
		set(OPTIMIZATION_FLAGS "-Ofast -s")
	endif()

	if (WITH_LTO)
		set(OPTIMIZATION_FLAGS "${OPTIMIZATION_FLAGS} -flto -fuse-linker-plugin")
	endif()

	if (CMAKE_CXX_COMPILER_VERSION VERSION_LESS 9)
		set(OPTIMIZATION_FLAGS "${OPTIMIZATION_FLAGS} -fno-associative-math")
	endif()

	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${GENERAL_FLAGS} ${WARNING_FLAGS} ${OPTIMIZATION_FLAGS}")
	set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} ${GENERAL_FLAGS} ${WARNING_FLAGS} ${OPTIMIZATION_FLAGS}")

	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${GENERAL_FLAGS} ${WARNING_FLAGS} ${OPTIMIZATION_FLAGS}")
	set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} ${GENERAL_FLAGS} ${WARNING_FLAGS} ${OPTIMIZATION_FLAGS}")

	if (WIN32)
		set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static")
	else()
		if (STATIC_BINARY)
			set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static")
		else()
			set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static-libgcc -static-libstdc++")
		endif()
	endif()
elseif (CMAKE_CXX_COMPILER_ID MATCHES MSVC)
	set(GENERAL_FLAGS "/MP /EHa")
	set(WARNING_FLAGS "/Wall /WX /sdl")
	set(SECURITY_FLAGS "/GS /guard:cf")
	set(OPTIMIZATION_FLAGS "/O2 /Oi /Ob2 /Ot /DNDEBUG /GL")

	if (DISABLE_WARNINGS)
		set(WARNING_FLAGS "/W0")
	endif()

	set(CMAKE_C_FLAGS_DEBUG "${GENERAL_FLAGS} ${WARNING_FLAGS} ${SECURITY_FLAGS} /Od /Ob0 /Zi /MTd")
	set(CMAKE_CXX_FLAGS_DEBUG "${GENERAL_FLAGS} ${WARNING_FLAGS} ${SECURITY_FLAGS} /Od /Ob0 /Zi /MTd")

	if (DEV_WITH_ASAN)
		set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} /fsanitize=address")
		set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /fsanitize=address")
	endif()

	set(CMAKE_C_FLAGS_RELEASE "${GENERAL_FLAGS} ${WARNING_FLAGS} ${SECURITY_FLAGS} ${OPTIMIZATION_FLAGS} /MT")
	set(CMAKE_CXX_FLAGS_RELEASE "${GENERAL_FLAGS} ${WARNING_FLAGS} ${SECURITY_FLAGS} ${OPTIMIZATION_FLAGS} /MT")

	set(CMAKE_C_FLAGS_RELWITHDEBINFO "${GENERAL_FLAGS} ${WARNING_FLAGS} ${SECURITY_FLAGS} /Ob1 /Ot /Zi /MT")
	set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${GENERAL_FLAGS} ${WARNING_FLAGS} ${SECURITY_FLAGS} /Ob1 /Ot /Zi /MT")

	set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} /LTCG")
elseif (CMAKE_CXX_COMPILER_ID MATCHES Clang)
	if (WIN32)
		set(GENERAL_FLAGS "")
		set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static")
	else()
		set(GENERAL_FLAGS "-pthread")
	endif()

	if (ARMv8)
		set(GENERAL_FLAGS "${GENERAL_FLAGS} -mfix-cortex-a53-835769")
	endif()

	set(WARNING_FLAGS "-Wall -Wextra -Wno-undefined-internal -Wunreachable-code-aggressive -Wmissing-prototypes -Wmissing-variable-declarations -Werror")

	if (DISABLE_WARNINGS)
		set(WARNING_FLAGS "-w")
	endif()

	if (DEV_WITH_MSAN)
		set(OPTIMIZATION_FLAGS "-Og -g")
	else()
		set(OPTIMIZATION_FLAGS "-Ofast -funroll-loops -fmerge-all-constants")
	endif()

	if (WITH_LTO)
		set(OPTIMIZATION_FLAGS "${OPTIMIZATION_FLAGS} -flto")
	endif()

	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${GENERAL_FLAGS} ${WARNING_FLAGS} ${OPTIMIZATION_FLAGS}")
	set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} ${GENERAL_FLAGS} ${WARNING_FLAGS} ${OPTIMIZATION_FLAGS}")

	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${GENERAL_FLAGS} ${WARNING_FLAGS} ${OPTIMIZATION_FLAGS}")
	set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} ${GENERAL_FLAGS} ${WARNING_FLAGS} ${OPTIMIZATION_FLAGS}")
endif()
