@echo off
setlocal enabledelayedexpansion

:: 1. Укажите путь к папке bin вашего PostgreSQL
set PG_BIN="C:\Users\Dima\AppData\Roaming\DBeaverData\drivers\clients\postgresql\win\17"

:: 2. Чтение .env файла
if not exist .env (
    echo [ERROR] .env file not found!
    pause
    exit /b
)

for /f "usebackq tokens=1,2 delims==" %%A in (".env") do (
    set "VAR_NAME=%%A"
    set "VAR_VAL=%%B"
    :: Убираем возможные кавычки
    set "VAR_VAL=!VAR_VAL:"=!"
    
    :: ЗАМЕНЯЕМ $$ НА $ (Экранирование Docker -> формат Windows)
    set "VAR_VAL=!VAR_VAL:$$=$!"
    
    set "!VAR_NAME!=!VAR_VAL!"
)

:: 3. Формирование имени файла
set BACKUP_NAME=dump_%DATE%.sql

echo [INFO] Connecting to %MASTER_PORT% as %POSTGRES_USER%...


:: 4. Запуск бэкапа
:: Используем переменные из .env: MASTER_PORT, POSTGRES_USER, POSTGRES_PASSWORD
set PGPASSWORD=%POSTGRES_PASSWORD%
%PG_BIN%\pg_dumpall.exe -h localhost -p %MASTER_PORT% -U %POSTGRES_USER% --clean --file="%BACKUP_NAME%"

if %ERRORLEVEL% equ 0 (
    echo [SUCCESS] Backup created: %BACKUP_NAME%
) else (
    echo [ERROR] Backup failed!
)

pause