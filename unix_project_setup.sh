#!/bin/bash

if command -v python3 &>/dev/null; then
    PYTHON_COMMAND=python3
elif command -v python &>/dev/null; then
    PYTHON_COMMAND=python
else
    echo "Python ist nicht installiert."
    exit 1
fi

if command -v python3 &>/dev/null && command -v python &>/dev/null; then
    PYTHON3_VERSION=$($PYTHON_COMMAND -c "import sys; print('.'.join(map(str, sys.version_info[:3])))")
    PYTHON2_VERSION=$(python -c "import sys; print('.'.join(map(str, sys.version_info[:3])))")
    
    if [[ "$(printf '%s\n' "$PYTHON3_VERSION" "$PYTHON2_VERSION" | sort -V | tail -n1)" == "$PYTHON3_VERSION" ]]; then
        PYTHON_COMMAND=python3
    else
        PYTHON_COMMAND=python
    fi
fi

$PYTHON_COMMAND -m venv venv

source venv/bin/activate

export PYTHONPATH=$(pwd)/src

if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
else
    echo "requirements.txt nicht gefunden"
fi

echo "Virtuelle Umgebung erstellt und Pakete installiert"

echo "Verwende den command $PYTHON_COMMAND um in dieser Studie python auszuführen"
