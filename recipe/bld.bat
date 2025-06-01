@echo on

cd msvc

:: Build
nmake /f Makefile ECL_WIN64=1
if errorlevel 1 exit 1

:: Install
nmake /f Makefile install
if errorlevel 1 exit 1

:: Test
:: Needs to be run after installation, see https://gitlab.com/embeddable-common-lisp/ecl/-/issues/342
:: The following fails due to missing ansi-tests, so run tests directly
:: nmake /f Makefile test
cd tests
nmake /f Makefile check
if errorlevel 1 exit 1
