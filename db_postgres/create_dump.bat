@echo off
setlocal enabledelayedexpansion

:: 1. Автоматический поиск пути к последней версии клиента
set "BASE_PG_PATH=%APPDATA%\DBeaverData\drivers\clients\postgresql\win"

if exist "%BASE_PG_PATH%" (
    :: Ищем самую свежую папку (версию) по дате/имени
    for /f "delims=" %%i in ('dir "%BASE_PG_PATH%" /b /ad /o-n') do (
        set "PG_BIN=%BASE_PG_PATH%\%%i"
        goto :found
    )
)

:found
if "%PG_BIN%"=="" (
    echo [ERROR] PostgreSQL client not found in %BASE_PG_PATH%
    pause
    exit /b
)

echo [INFO] Using PG Bin: %PG_BIN%

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
%PG_BIN%\pg_dumpall.exe -h %DUMP_HOST% -p %MASTER_PORT% -U %POSTGRES_USER% --clean --file="%BACKUP_NAME%"

if %ERRORLEVEL% equ 0 (
    echo [SUCCESS] Backup created: %BACKUP_NAME%
) else (
    echo [ERROR] Backup failed!
)

pause
