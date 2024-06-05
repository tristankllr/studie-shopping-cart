$python3Exists = Get-Command python3 -ErrorAction SilentlyContinue
$pythonExists = Get-Command python -ErrorAction SilentlyContinue

if ($python3Exists) {
    $PYTHON_COMMAND = "python3"
} elseif ($pythonExists) {
    $PYTHON_COMMAND = "python"
} else {
    Write-Host "Python ist nicht installiert."
    exit 1
}

if ($python3Exists -and $pythonExists) {
    $PYTHON3_VERSION = & python3 -c "import sys; print('.'.join(map(str, sys.version_info[:3])))" 2>$null
    $PYTHON2_VERSION = & python -c "import sys; print('.'.join(map(str, sys.version_info[:3])))" 2>$null
    
    if ([Version]$PYTHON3_VERSION -gt [Version]$PYTHON2_VERSION) {
        $PYTHON_COMMAND = "python3"
    } else {
        $PYTHON_COMMAND = "python"
    }
}

Write-Host "Verwende den python command: $PYTHON_COMMAND"

& $PYTHON_COMMAND -m venv venv

& .\venv\Scripts\Activate.ps1

$env:PYTHONPATH = "$(Get-Location)\src"

$VENV_PYTHON_VERSION = & python --version
Write-Host "Python Version in der virtuellen Umgebung: $VENV_PYTHON_VERSION"

if (Test-Path "requirements.txt") {
    try {
        & pip install -r requirements.txt --trusted-host pypi.org --trusted-host files.pythonhosted.org
    } catch {
        Write-Host "Fehler bei der Installation der Pakete: $_"
    }
} else {
    Write-Host "requirements.txt nicht gefunden"
}

Write-Host "Virtuelle Umgebung erstellt und Pakete installiert"
