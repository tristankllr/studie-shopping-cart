$python3Exists = Get-Command python3 -ErrorAction SilentlyContinue
$pythonExists = Get-Command python -ErrorAction SilentlyContinue

Write-Host "Ueberpruefe, ob Python installiert ist..."

if ($python3Exists) {
    $PYTHON_COMMAND = "python3"
    Write-Host "Python gefunden $PYTHON_COMMAND"
} elseif ($pythonExists) {
    $PYTHON_COMMAND = "python"
    Write-Host "Python gefunden $PYTHON_COMMAND"
} else {
    Write-Host "Python ist nicht installiert."
    exit 1
}

if ($python3Exists -and $pythonExists) {
    $PYTHON3_VERSION = & python3 -c "import sys; print('.'.join(map(str, sys.version_info[:3])))" 2>$null
    $PYTHON_VERSION = & python -c "import sys; print('.'.join(map(str, sys.version_info[:3])))" 2>$null
    
    if ([Version]$PYTHON3_VERSION -gt [Version]$PYTHON_VERSION) {
        $PYTHON_COMMAND = "python3"
    } else {
        $PYTHON_COMMAND = "python"
    }
}

Write-Host "Erstelle die virtuelle Umgebung..."

& $PYTHON_COMMAND -m venv venv

Write-Host "Aktiviere die virtuelle Umgebung..."

& .\venv\Scripts\Activate.ps1

Write-Host "Setze PYTHONPATH..."

$env:PYTHONPATH = "$(Get-Location)\src"

Write-Host "PYTHONPATH gesetzt auf: $PYTHONPATH"

Write-Host "Ueberpruefe, ob requirements.txt existiert..."

if (Test-Path "requirements.txt") {
    try {
        & pip install -r requirements.txt --trusted-host pypi.org --trusted-host files.pythonhosted.org
        Write-Host "requirements.txt gefunden und Pakete installiert..."
    } catch {
        Write-Host "Fehler bei der Installation der Pakete: $_"
    }
} else {
    Write-Host "requirements.txt nicht gefunden"
}

Write-Host "Virtuelle Umgebung erstellt und Pakete installiert"
