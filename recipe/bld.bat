@echo on

mkdir build
cd build

:: Build
nmake
if errorlevel 1 exit 1

:: Install
nmake install
if errorlevel 1 exit 1

:: Test
:: Needs to be run after installation, see https://gitlab.com/embeddable-common-lisp/ecl/-/issues/342
nmake test
