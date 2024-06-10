#!/bin/bash

echo "Ueberpruefe, ob Python installiert ist..."

if command -v python3 &>/dev/null; then
    PYTHON_COMMAND=python3
    echo "Python gefunden $PYTHON_COMMAND"
elif command -v python &>/dev/null; then
    PYTHON_COMMAND=python
    echo "Python gefunden $PYTHON_COMMAND"
else
    echo "Python ist nicht installiert."
    exit 1
fi

if command -v python3 &>/dev/null && command -v python &>/dev/null; then
    PYTHON3_VERSION=$($PYTHON_COMMAND -c "import sys; print('.'.join(map(str, sys.version_info[:3])))")
    PYTHON_VERSION=$(python -c "import sys; print('.'.join(map(str, sys.version_info[:3])))")
    
    if [[ "$(printf '%s\n' "$PYTHON3_VERSION" "$PYTHON_VERSION" | sort -V | tail -n1)" == "$PYTHON3_VERSION" ]]; then
        PYTHON_COMMAND=python3
    else
        PYTHON_COMMAND=python
    fi
fi

echo "Erstelle die virtuelle Umgebung..."

$PYTHON_COMMAND -m venv venv

echo "Aktiviere die virtuelle Umgebung..."

source venv/bin/activate

echo "Setze PYTHONPATH..."

export PYTHONPATH=$(pwd)/src

echo "PYTHONPATH gesetzt auf: $PYTHONPATH"

echo "Ueberpruefe, ob requirements.txt existiert..."

if [ -f "requirements.txt" ]; then
    echo "requirements.txt gefunden, installiere Pakete..."
    pip install -r requirements.txt
else
    echo "requirements.txt nicht gefunden"
fi

echo "Virtuelle Umgebung erstellt und Pakete installiert"
