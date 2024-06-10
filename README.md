# Shopping Cart  
A simple E-commerce website using Flask.

## Dependencies

1. Navigate with Terminal or Powershell into ```cd ./studie-shopping-cart```.
2. Create and activate venv, install requirements and set Python path to ```./studie-shopping-cart/src```:
   1. Use scripts (recommended):
      * Windows:
        1. Execute in Powershell script (error handling: check executionpolicy or alternatively execute bat script in cmd): ```.\windows_projekt_setup.ps1```.
        2. Check if venc is activated (in front of path). If not, execute (check executionpolicy): ```.\venv\Scripts\Activate.ps1```.
      * Linux or MacOS:
        1. Execute in terminal script: ```./unix_project_setup.sh```.
        2. Check if venc is activated (in front of path). If not, execute: ```source ./venv/bin/activate```.
   2. Manually:
      1. Check correct python command.
      2. Create venv: ```python3 -m venv ./venv```.
      3. Activate venv:
         * Windows: ```.\venv\Scripts\activate```
         * Linux or MacOS: ```source ./venv/bin/activate```
      4. Install Python packages: ```python -m pip install -r requirements.txt```
3. Check if Python packages installed: ```pip list```.

## Run tests

1. Navigate into ```cd ./studie-shopping-cart```
2. Run tests in file: ```python -m unittest src.app.tests.{file_name}```

## Run Application

1. Navigate into ```cd ./studie-shopping-cart```
2. Run main: ````python -m src.app.__main__````

## Sample User ##
Sample credentials present in existing database:

- Username: ```test@test.de```
- Password: ```test```

# SQLite Migration Alembic
1. Migrationsskript erstellen: ``alembic revision --autogenerate -m "Initial migration"``
2. Migrationen anwenden: ``alembic upgrade head``

