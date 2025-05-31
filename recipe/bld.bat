@echo on

mkdir build
cd build

:: Configure
cmake -G "NMake Makefiles" ^
    %CMAKE_ARGS% ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DECL_WIN64=1 ^
    %SRC_DIR%
    ..
if errorlevel 1 exit 1

:: Build
nmake
if errorlevel 1 exit 1


:: Install
nmake install
if errorlevel 1 exit 1

:: Test
:: Needs to be run after installation, see https://gitlab.com/embeddable-common-lisp/ecl/-/issues/342
nmake test
