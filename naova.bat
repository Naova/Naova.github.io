@echo off
setlocal enabledelayedexpansion

set "NAOVA_DOC_PATH=%~dp0"

echo [INFO] Building documentation...
call :extract_python_exe

if "%python_exe%"=="" (
    echo [ERROR] Unable to find a valid Python executable.
    echo 	Possible reasons:
    echo 	1. Python is not installed.
    echo 	2. Python is not in the system PATH.
    exit /b 1
)

echo [INFO] Using Python: %python_exe%

rem Remove old build
if exist "%NAOVA_DOC_PATH%\docs\_build" (
    echo [INFO] Removing old build...
    rmdir /s /q "%NAOVA_DOC_PATH%\docs\_build"
)

rem Check if dependencies are already installed
pushd "%NAOVA_DOC_PATH%\docs"

echo [INFO] Checking dependencies...
"%python_exe%" -m pip list | findstr /i "sphinx" >nul
if errorlevel 1 (
    echo [INFO] Installing dependencies...
    "%python_exe%" -m pip install -q -r requirements.txt
    if errorlevel 1 (
        echo [ERROR] Failed to install dependencies
        popd
        exit /b 1
    )
) else (
    echo [INFO] Dependencies already installed
)

echo [INFO] Building Sphinx documentation...
"%python_exe%" -m sphinx -b html -d _build\doctrees . _build\html
if errorlevel 1 (
    echo [ERROR] Failed to build documentation
    popd
    exit /b 1
)

popd

echo [INFO] Documentation built successfully!
echo [INFO] Opening documentation...
start "" "%NAOVA_DOC_PATH%\docs\_build\html\index.html"

goto :end

:extract_python_exe
setlocal enabledelayedexpansion
set "python_exe="

rem Check if using Conda
if defined CONDA_PREFIX (
    if exist "!CONDA_PREFIX!\python.exe" (
        set "python_exe=!CONDA_PREFIX!\python.exe"
    )
)

rem Fallback to system Python
if "!python_exe!"=="" (
    for /f "delims=" %%i in ('where python 2^>nul') do (
        set "python_exe=%%i"
        goto :found_python
    )
    for /f "delims=" %%i in ('where python3 2^>nul') do (
        set "python_exe=%%i"
        goto :found_python
    )
)

:found_python
endlocal & set "python_exe=%python_exe%"
exit /b 0

:end
exit /b 0