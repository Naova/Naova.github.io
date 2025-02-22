set "ISAACLAB_PATH=%~dp0"
rem build the documentation
echo [INFO] Building documentation...
call :extract_python_exe
pushd %ISAACLAB_PATH%\docs
call !python_exe! -m pip install -r requirements.txt >nul
call !python_exe! -m sphinx -b html -d _build\doctrees . _build\html
echo [INFO] To open documentation on default browser, run:
echo xdg-open "%ISAACLAB_PATH%\docs\_build\html\index.html"
popd >nul
shift
goto :end