@ECHO OFF
setlocal

set SPHINXBUILD=sphinx-build
set SOURCEDIR=source
set BUILDDIR=build

if "%1" == "" goto help

%SPHINXBUILD% -M %1 %SOURCEDIR% %BUILDDIR%
goto end

:help
echo.Build documentation using Sphinx
echo.
echo.Usage:
echo.  make.bat html
echo.

:end
endlocal
