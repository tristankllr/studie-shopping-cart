@echo off

echo Ueberpruefe, ob Python3 installiert ist...

where python3 >nul 2>&1
if %ERRORLEVEL% == 0 (
    set "PYTHON3_INSTALLED=true"
    for /f "delims=" %%i in ('python3 -c "import sys; print('.'.join(map(str, sys.version_info[:3])))"') do set "PYTHON3_VERSION=%%i"
    echo Python3 Version gefunden: %PYTHON3_VERSION%
) else (
    set "PYTHON3_INSTALLED=false"
    echo Python3 ist nicht installiert.
)

echo Ueberpruefe, ob Python installiert ist...

where python >nul 2>&1
if %ERRORLEVEL% == 0 (
    set "PYTHON_INSTALLED=true"
    for /f "delims=" %%i in ('python -c "import sys; print('.'.join(map(str, sys.version_info[:3])))"') do set "PYTHON_VERSION=%%i"
    echo Python Version gefunden: %PYTHON_VERSION%
) else (
    set "PYTHON_INSTALLED=false"
    echo Python ist nicht installiert.
)

echo Vergleiche Python-Versionen...

if %PYTHON3_INSTALLED% == true if %PYTHON_INSTALLED% == true (
    if "%PYTHON3_VERSION%" gtr "%PYTHON_VERSION%" (
        set "PYTHON_COMMAND=python3"
        echo Verwende Python3: %PYTHON3_VERSION%
    ) else (
        set "PYTHON_COMMAND=python"
        echo Verwende Python: %PYTHON_VERSION%
    )
) else if %PYTHON3_INSTALLED% == true (
    set "PYTHON_COMMAND=python3"
    echo Nur Python3 gefunden, verwende Python3: %PYTHON3_VERSION%
) else if %PYTHON_INSTALLED% == true (
    set "PYTHON_COMMAND=python"
    echo Nur Python gefunden, verwende Python: %PYTHON_VERSION%
) else (
    echo Python ist nicht installiert.
    exit /b 1
)

echo Erstelle die virtuelle Umgebung...

%PYTHON_COMMAND% -m venv venv

if %ERRORLEVEL% neq 0 (
    echo Fehler beim Erstellen der virtuellen Umgebung.
    exit /b 1
)

echo Aktiviere die virtuelle Umgebung...

call venv\Scripts\activate

if %ERRORLEVEL% neq 0 (
    echo Fehler beim Aktivieren der virtuellen Umgebung.
    exit /b 1
)

echo Setze PYTHONPATH...

set "PYTHONPATH=%cd%\src"
echo PYTHONPATH gesetzt auf: %PYTHONPATH%

echo Ueberpruefe, ob requirements.txt existiert...

if exist requirements.txt (
    echo requirements.txt gefunden, installiere Pakete...
    pip install -r requirements.txt
    if %ERRORLEVEL% neq 0 (
        echo Fehler beim Installieren der Pakete.
        exit /b 1
    )
    echo Pakete erfolgreich installiert.
) else (
    echo requirements.txt nicht gefunden.
)

echo Virtuelle Umgebung erstellt und Pakete installiert.
