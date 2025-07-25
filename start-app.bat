@echo off
setlocal enabledelayedexpansion

REM Mova App Management Script for Windows
REM Usage: start-app.bat [install|run|stop|clean]

set "BACKEND_DIR=backend"
set "FRONTEND_DIR=frontend"
set "PROJECT_ROOT=%CD%"
set "BACKEND_PID_FILE=%PROJECT_ROOT%\.backend.pid"
set "FRONTEND_PID_FILE=%PROJECT_ROOT%\.frontend.pid"

REM Function to print colored output (Windows compatible)
goto :main

:print_status
echo [INFO] %~1
goto :eof

:print_success
echo [SUCCESS] %~1
goto :eof

:print_warning
echo [WARNING] %~1
goto :eof

:print_error
echo [ERROR] %~1
goto :eof

:check_node
where node >nul 2>nul
if errorlevel 1 (
    call :print_error "Node.js is not installed!"
    echo.
    call :print_status "🚀 INSTALLING NODE.JS FOR YOU..."
    call :print_status "This will automatically download and install Node.js"
    echo.
    call :print_warning "Please follow these steps:"
    call :print_status "1. Your browser will open to https://nodejs.org/"
    call :print_status "2. Download the LTS version for Windows"
    call :print_status "3. Run the installer (accept all defaults)"
    call :print_status "4. Restart this command prompt"
    call :print_status "5. Run this script again"
    echo.
    call :print_status "Opening Node.js download page..."
    start https://nodejs.org/
    echo.
    call :print_warning "After installing Node.js, press any key to continue or Ctrl+C to exit"
    pause >nul
    
    REM Check again after user claims to have installed
    where node >nul 2>nul
    if errorlevel 1 (
        call :print_error "Node.js still not found! Make sure to:"
        call :print_status "1. Install Node.js from https://nodejs.org/"
        call :print_status "2. Restart your command prompt"
        call :print_status "3. Run this script again"
        pause
        exit /b 1
    )
) 

REM Verify Node.js and npm are working
for /f "tokens=*" %%i in ('node --version 2^>nul') do set NODE_VERSION=%%i
for /f "tokens=*" %%j in ('npm --version 2^>nul') do set NPM_VERSION=%%j

if "!NODE_VERSION!"=="" (
    call :print_error "Node.js installation verification failed!"
    exit /b 1
)

if "!NPM_VERSION!"=="" (
    call :print_error "npm installation verification failed!"
    exit /b 1
)

call :print_success "Node.js is installed: !NODE_VERSION!"
call :print_success "npm is available: !NPM_VERSION!"
goto :eof

:install_deps
call :print_status "Installing project dependencies..."

REM Install backend dependencies
call :print_status "Installing backend dependencies..."
cd /d "%PROJECT_ROOT%\%BACKEND_DIR%"
call npm install
if errorlevel 1 (
    call :print_error "Failed to install backend dependencies"
    exit /b 1
)
call :print_success "Backend dependencies installed!"

REM Install frontend dependencies
call :print_status "Installing frontend dependencies..."
cd /d "%PROJECT_ROOT%\%FRONTEND_DIR%"
call npm install
if errorlevel 1 (
    call :print_error "Failed to install frontend dependencies"
    exit /b 1
)
call :print_success "Frontend dependencies installed!"

cd /d "%PROJECT_ROOT%"
goto :eof

:setup_env
call :print_status "Setting up environment configuration..."

if not exist "%BACKEND_DIR%\.env" (
    if exist "%BACKEND_DIR%\.env.example" (
        copy "%BACKEND_DIR%\.env.example" "%BACKEND_DIR%\.env" >nul
        call :print_warning "Created .env file from .env.example"
        call :print_warning "Please edit backend\.env with your email credentials before running the app!"
    ) else (
        call :print_error ".env.example file not found in backend directory"
    )
) else (
    call :print_success "Environment file already exists"
)
goto :eof

:build_apps
call :print_status "Building applications..."

REM Build backend
call :print_status "Building backend..."
cd /d "%PROJECT_ROOT%\%BACKEND_DIR%"
call npm run build
if errorlevel 1 (
    call :print_error "Failed to build backend"
    exit /b 1
)
call :print_success "Backend built successfully!"

REM Build frontend
call :print_status "Building frontend..."
cd /d "%PROJECT_ROOT%\%FRONTEND_DIR%"
call npm run build
if errorlevel 1 (
    call :print_error "Failed to build frontend"
    exit /b 1
)
call :print_success "Frontend built successfully!"

cd /d "%PROJECT_ROOT%"
goto :eof

:start_apps
call :print_status "Starting applications..."

REM Check if .env exists
if not exist "%BACKEND_DIR%\.env" (
    call :print_error "Backend .env file not found! Run 'start-app.bat install' first."
    exit /b 1
)

REM Check if dependencies are installed
if not exist "%BACKEND_DIR%\node_modules" (
    call :print_error "Backend dependencies not found! Run 'start-app.bat install' first."
    exit /b 1
)

if not exist "%FRONTEND_DIR%\node_modules" (
    call :print_error "Frontend dependencies not found! Run 'start-app.bat install' first."
    exit /b 1
)

REM Stop any existing processes first
call :stop_apps >nul 2>nul

call :print_status "Starting backend server on http://localhost:3000..."
cd /d "%PROJECT_ROOT%\%BACKEND_DIR%"
start /b cmd /c "npm run dev > ..\backend.log 2>&1"
cd /d "%PROJECT_ROOT%"

REM Wait for backend to start
timeout /t 3 /nobreak >nul
call :print_success "Backend server started"

call :print_status "Starting frontend server on http://localhost:3001..."
cd /d "%PROJECT_ROOT%\%FRONTEND_DIR%"
start /b cmd /c "npm run dev > ..\frontend.log 2>&1"
cd /d "%PROJECT_ROOT%"

REM Wait for frontend to start
timeout /t 5 /nobreak >nul
call :print_success "Frontend server started"

call :print_success "🎉 Applications started successfully!"
echo.
echo 🌐 Open your browser and visit:
echo    Frontend: http://localhost:3001 (Main App)
echo    Backend:  http://localhost:3000 (API)
echo.
call :print_status "📋 Logs are streamed to:"
call :print_status "   Backend: backend.log"
call :print_status "   Frontend: frontend.log"
echo.
call :print_status "🛑 Press Ctrl+C to stop all servers"
echo.

REM Try to open the browser automatically
call :print_status "🚀 Opening browser..."
timeout /t 2 /nobreak >nul
start http://localhost:3001

call :print_status "💻 Servers are running... Press Ctrl+C to stop"
echo.
call :print_warning "Note: On Windows, Ctrl+C will stop this script."
call :print_warning "To fully stop all Node.js processes, also run: start-app.bat stop"

REM Keep the script running until Ctrl+C
:wait_loop
timeout /t 5 >nul
REM Check if we should continue (this will be interrupted by Ctrl+C)
goto wait_loop

:stop_apps
call :print_status "Stopping applications..."

REM Kill Node processes (this will stop both backend and frontend)
taskkill /f /im node.exe >nul 2>nul
if not errorlevel 1 (
    call :print_success "Node.js processes stopped"
) else (
    call :print_warning "No Node.js processes were running"
)

REM Clean up PID files
if exist "%BACKEND_PID_FILE%" del "%BACKEND_PID_FILE%" >nul
if exist "%FRONTEND_PID_FILE%" del "%FRONTEND_PID_FILE%" >nul

call :print_success "All applications stopped"
goto :eof

:clean_all
call :print_status "Cleaning project..."

REM Stop applications first
call :stop_apps

REM Remove node_modules
call :print_status "Removing node_modules..."
if exist "%BACKEND_DIR%\node_modules" rmdir /s /q "%BACKEND_DIR%\node_modules"
if exist "%FRONTEND_DIR%\node_modules" rmdir /s /q "%FRONTEND_DIR%\node_modules"

REM Remove build directories
call :print_status "Removing build directories..."
if exist "%BACKEND_DIR%\dist" rmdir /s /q "%BACKEND_DIR%\dist"
if exist "%FRONTEND_DIR%\dist" rmdir /s /q "%FRONTEND_DIR%\dist"

REM Remove log files
if exist "backend.log" del "backend.log" >nul
if exist "frontend.log" del "frontend.log" >nul

REM Remove PID files
if exist "%BACKEND_PID_FILE%" del "%BACKEND_PID_FILE%" >nul
if exist "%FRONTEND_PID_FILE%" del "%FRONTEND_PID_FILE%" >nul

call :print_success "Project cleaned successfully!"
goto :eof

:show_usage
echo Mova App Management Script for Windows
echo.
echo Usage: %0 [command]
echo.
echo Commands:
echo   install   - Install dependencies and setup environment
echo   run       - Start both backend and frontend servers
echo   stop      - Stop all running servers
echo   clean     - Stop servers and clean all build files and dependencies
echo   help      - Show this help message
echo.
echo Examples:
echo   %0 install   # First time setup
echo   %0 run       # Start the application
echo   %0 stop      # Stop the application
echo   %0 clean     # Clean everything
echo.
echo Note: Node.js must be installed manually on Windows.
echo Visit https://nodejs.org/ to download and install Node.js
goto :eof

:main
set "command=%~1"
if "%command%"=="" set "command=help"

if "%command%"=="install" (
    call :print_status "🚀 Starting complete installation process..."
    call :print_status "This will install everything needed to run Mova webapp!"
    echo.
    
    REM Step 1: Check and install Node.js
    call :print_status "Step 1: Checking Node.js installation..."
    call :check_node
    if errorlevel 1 exit /b 1
    
    REM Step 2: Install project dependencies
    call :print_status "Step 2: Installing project dependencies..."
    call :install_deps
    if errorlevel 1 exit /b 1
    
    REM Step 3: Setup environment
    call :print_status "Step 3: Setting up environment..."
    call :setup_env
    
    REM Step 4: Build applications
    call :print_status "Step 4: Building applications..."
    call :build_apps
    if errorlevel 1 exit /b 1
    
    echo.
    call :print_success "🎉 Installation completed successfully!"
    echo.
    call :print_warning "📧 IMPORTANT: Configure your email credentials in backend\.env"
    call :print_status "   Edit backend\.env and add your Gmail credentials"
    echo.
    call :print_status "🚀 Ready to run! Execute: '%0 run' to start the application"
    echo.
) else if "%command%"=="run" (
    call :start_apps
) else if "%command%"=="stop" (
    call :stop_apps
) else if "%command%"=="clean" (
    call :clean_all
) else if "%command%"=="help" (
    call :show_usage
) else (
    call :print_error "Unknown command: %command%"
    call :show_usage
    exit /b 1
)

endlocal