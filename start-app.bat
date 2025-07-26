@echo off
setlocal enabledelayedexpansion

REM Mova App Management Script for Windows
REM Usage: start-app.bat [install|run]

set "BACKEND_DIR=backend"
set "FRONTEND_DIR=frontend"
set "PROJECT_ROOT=%CD%"

REM Check command argument
set "command=%~1"
if "%command%"=="" set "command=help"

if "%command%"=="install" (
    call :install_command
) else if "%command%"=="run" (
    call :run_command
) else (
    call :show_help
)
goto :end

:install_command
echo [INFO] Starting installation process...
echo.

REM Check Node.js
where node >nul 2>nul
if errorlevel 1 (
    echo [ERROR] Node.js is not installed!
    echo [INFO] Opening Node.js download page...
    start https://nodejs.org/
    echo [INFO] Please install Node.js and run this script again.
    pause
    exit /b 1
)

node --version
echo [SUCCESS] Node.js is installed

REM Install backend dependencies
echo [INFO] Installing backend dependencies...
cd /d "%PROJECT_ROOT%\%BACKEND_DIR%"
npm install --legacy-peer-deps
if errorlevel 1 (
    echo [ERROR] Failed to install backend dependencies
    exit /b 1
)
echo [SUCCESS] Backend dependencies installed

REM Install frontend dependencies
echo [INFO] Installing frontend dependencies...
cd /d "%PROJECT_ROOT%\%FRONTEND_DIR%"
npm install --legacy-peer-deps
if errorlevel 1 (
    echo [ERROR] Failed to install frontend dependencies
    exit /b 1
)
echo [SUCCESS] Frontend dependencies installed

REM Start Docker containers
cd /d "%PROJECT_ROOT%"
echo [INFO] Starting Docker containers...
docker-compose up -d
if errorlevel 1 (
    echo [WARNING] Failed to start Docker containers. Make sure Docker is installed and running.
) else (
    echo [SUCCESS] Docker containers started
)

REM Create .env file if it doesn't exist
if not exist "%BACKEND_DIR%\.env" (
    echo [INFO] Creating .env file...
    (
        echo PORT=3000
        echo NODE_ENV=development
        echo DB_HOST=localhost
        echo DB_PORT=5433
        echo DB_USERNAME=mova_user
        echo DB_PASSWORD=mova_password
        echo DB_NAME=mova_db
        echo EMAIL_USER=your-email@gmail.com
        echo EMAIL_PASS=your-app-password
    ) > "%BACKEND_DIR%\.env"
    echo [SUCCESS] Created .env file
    echo [WARNING] Please edit backend\.env with your email credentials
)

echo.
echo [SUCCESS] Installation completed successfully!
echo [INFO] Run 'start-app.bat run' to start the application
goto :end

:run_command
echo [INFO] Starting Mova application...

REM Check if installation was done
if not exist "%BACKEND_DIR%\node_modules" (
    echo [ERROR] Backend not installed. Run 'start-app.bat install' first.
    exit /b 1
)
if not exist "%FRONTEND_DIR%\node_modules" (
    echo [ERROR] Frontend not installed. Run 'start-app.bat install' first.
    exit /b 1
)
if not exist "%BACKEND_DIR%\.env" (
    echo [ERROR] .env file not found. Run 'start-app.bat install' first.
    exit /b 1
)

REM Start Docker containers
echo [INFO] Starting Docker containers...
docker-compose up -d >nul 2>nul

REM Start backend in background
echo [INFO] Starting backend server...
cd /d "%PROJECT_ROOT%\%BACKEND_DIR%"
start /b cmd /c "npm run dev"
cd /d "%PROJECT_ROOT%"

REM Wait a moment for backend to start
timeout /t 3 /nobreak >nul

REM Start frontend in background
echo [INFO] Starting frontend server...
cd /d "%PROJECT_ROOT%\%FRONTEND_DIR%"
start /b cmd /c "npm run dev"
cd /d "%PROJECT_ROOT%"

echo.
echo [SUCCESS] Application started!
echo Frontend: http://localhost:3001
echo Backend:  http://localhost:3000
echo.
echo [INFO] Press Ctrl+C to stop all processes

REM Wait for Ctrl+C and cleanup
:wait_loop
timeout /t 5 >nul
goto wait_loop

:show_help
echo Mova App Management Script
echo.
echo Usage: %0 [command]
echo.
echo Commands:
echo   install   - Install dependencies and setup environment
echo   run       - Start the application
echo   help      - Show this help
echo.
goto :end

:end
REM Cleanup on exit
echo.
echo [INFO] Cleaning up processes...
taskkill /f /im node.exe >nul 2>nul
taskkill /f /im "npm.cmd" >nul 2>nul
echo [INFO] Cleanup completed
endlocal