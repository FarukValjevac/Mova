#!/bin/bash

# Mova App Management Script
# Usage: ./start-app.sh [install|run|stop|clean]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project directories
BACKEND_DIR="backend"
FRONTEND_DIR="frontend"
PROJECT_ROOT=$(pwd)

# PID files for process management
BACKEND_PID_FILE="$PROJECT_ROOT/.backend.pid"
FRONTEND_PID_FILE="$PROJECT_ROOT/.frontend.pid"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check and install system prerequisites
check_prerequisites() {
    print_status "Checking system prerequisites..."
    
    # Check if we have curl (needed for downloads)
    if ! command -v curl &> /dev/null; then
        print_status "Installing curl..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS usually has curl built-in, but just in case
            if ! command -v curl &> /dev/null; then
                print_error "curl is required but not found. Please install Xcode Command Line Tools:"
                print_status "Run: xcode-select --install"
                exit 1
            fi
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            if command -v apt-get &> /dev/null; then
                sudo apt-get update && sudo apt-get install -y curl
            elif command -v yum &> /dev/null; then
                sudo yum install -y curl
            fi
        fi
    fi
    
    # Check git (might be needed for some npm packages)
    if ! command -v git &> /dev/null; then
        print_status "Installing git..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # On macOS, installing Xcode Command Line Tools gives us git
            print_status "Installing Xcode Command Line Tools (includes git)..."
            xcode-select --install 2>/dev/null || true
            print_warning "If prompted, please install Xcode Command Line Tools and run this script again."
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            if command -v apt-get &> /dev/null; then
                sudo apt-get install -y git
            elif command -v yum &> /dev/null; then
                sudo yum install -y git
            fi
        fi
    fi
}

# Function to install Homebrew on macOS
install_homebrew() {
    if [[ "$OSTYPE" == "darwin"* ]] && ! command -v brew &> /dev/null; then
        print_status "Installing Homebrew (macOS package manager)..."
        print_warning "This may take a few minutes and will require your password..."
        
        # Install Homebrew
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for the current session
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            # Apple Silicon Mac
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f "/usr/local/bin/brew" ]]; then
            # Intel Mac
            eval "$(/usr/local/bin/brew shellenv)"
        fi
        
        # Verify installation
        if command -v brew &> /dev/null; then
            print_success "Homebrew installed successfully!"
        else
            print_error "Homebrew installation failed. Please install it manually:"
            print_status "Visit: https://brew.sh/"
            exit 1
        fi
    fi
}

# Function to check if Node.js is installed
check_node() {
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed!"
        print_status "Installing Node.js..."
        
        # Detect OS and install Node.js
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS - ensure Homebrew is installed first
            install_homebrew
            
            print_status "Installing Node.js via Homebrew..."
            brew install node
            
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            # Linux
            if command -v apt-get &> /dev/null; then
                # Ubuntu/Debian
                print_status "Installing Node.js on Ubuntu/Debian..."
                sudo apt-get update
                curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
                sudo apt-get install -y nodejs
            elif command -v yum &> /dev/null; then
                # CentOS/RHEL/Fedora
                print_status "Installing Node.js on CentOS/RHEL/Fedora..."
                curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash -
                sudo yum install -y nodejs npm
            elif command -v dnf &> /dev/null; then
                # Modern Fedora
                print_status "Installing Node.js on Fedora..."
                curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash -
                sudo dnf install -y nodejs npm
            elif command -v pacman &> /dev/null; then
                # Arch Linux
                print_status "Installing Node.js on Arch Linux..."
                sudo pacman -S nodejs npm
            else
                print_error "Package manager not found. Please install Node.js manually from https://nodejs.org/"
                exit 1
            fi
        else
            print_error "Unsupported OS: $OSTYPE"
            print_status "Please install Node.js manually from https://nodejs.org/"
            exit 1
        fi
        
        # Verify installation
        if command -v node &> /dev/null; then
            NODE_VERSION=$(node --version)
            NPM_VERSION=$(npm --version)
            print_success "Node.js installed successfully: $NODE_VERSION"
            print_success "npm installed successfully: $NPM_VERSION"
        else
            print_error "Node.js installation failed!"
            exit 1
        fi
    else
        NODE_VERSION=$(node --version)
        NPM_VERSION=$(npm --version)
        print_success "Node.js is already installed: $NODE_VERSION"
        print_success "npm is available: $NPM_VERSION"
    fi
}

# Function to install dependencies
install_deps() {
    print_status "Installing project dependencies..."
    
    # Install backend dependencies
    print_status "Installing backend dependencies..."
    cd "$PROJECT_ROOT/$BACKEND_DIR"
    npm install
    print_success "Backend dependencies installed!"
    
    # Install frontend dependencies
    print_status "Installing frontend dependencies..."
    cd "$PROJECT_ROOT/$FRONTEND_DIR"
    npm install
    print_success "Frontend dependencies installed!"
    
    cd "$PROJECT_ROOT"
}

# Function to setup environment
setup_env() {
    print_status "Setting up environment configuration..."
    
    if [ ! -f "$BACKEND_DIR/.env" ]; then
        if [ -f "$BACKEND_DIR/.env.example" ]; then
            cp "$BACKEND_DIR/.env.example" "$BACKEND_DIR/.env"
            print_warning "Created .env file from .env.example"
            print_warning "Please edit backend/.env with your email credentials before running the app!"
        else
            print_error ".env.example file not found in backend directory"
        fi
    else
        print_success "Environment file already exists"
    fi
}

# Function to build the applications
build_apps() {
    print_status "Building applications..."
    
    # Build backend
    print_status "Building backend..."
    cd "$PROJECT_ROOT/$BACKEND_DIR"
    npm run build
    print_success "Backend built successfully!"
    
    # Build frontend
    print_status "Building frontend..."
    cd "$PROJECT_ROOT/$FRONTEND_DIR"
    npm run build
    print_success "Frontend built successfully!"
    
    cd "$PROJECT_ROOT"
}

# Function to cleanup processes on script exit
cleanup() {
    print_status "🛑 Shutting down servers..."
    if [ ! -z "$BACKEND_PID" ] && ps -p $BACKEND_PID > /dev/null 2>&1; then
        kill $BACKEND_PID
        print_success "Backend server stopped"
    fi
    if [ ! -z "$FRONTEND_PID" ] && ps -p $FRONTEND_PID > /dev/null 2>&1; then
        kill $FRONTEND_PID  
        print_success "Frontend server stopped"
    fi
    
    # Clean up PID files
    rm -f "$BACKEND_PID_FILE" "$FRONTEND_PID_FILE"
    
    print_success "👋 Mova servers have been stopped"
    exit 0
}

# Function to start the applications
start_apps() {
    print_status "Starting applications..."
    
    # Check if .env exists and has credentials
    if [ ! -f "$BACKEND_DIR/.env" ]; then
        print_error "Backend .env file not found! Run './start-app.sh install' first."
        exit 1
    fi
    
    # Check if dependencies are installed
    if [ ! -d "$BACKEND_DIR/node_modules" ]; then
        print_error "Backend dependencies not found! Run './start-app.sh install' first."
        exit 1
    fi
    
    if [ ! -d "$FRONTEND_DIR/node_modules" ]; then
        print_error "Frontend dependencies not found! Run './start-app.sh install' first."
        exit 1
    fi
    
    # Stop any existing processes first
    stop_apps > /dev/null 2>&1
    
    # Set up trap to handle Ctrl+C
    trap cleanup SIGINT SIGTERM
    
    print_status "Starting backend server on http://localhost:3000..."
    cd "$PROJECT_ROOT/$BACKEND_DIR"
    npm run dev > ../backend.log 2>&1 &
    BACKEND_PID=$!
    echo $BACKEND_PID > "$BACKEND_PID_FILE"
    cd "$PROJECT_ROOT"
    
    # Check if backend started successfully
    sleep 2
    if ! ps -p $BACKEND_PID > /dev/null 2>&1; then
        print_error "Failed to start backend server!"
        print_error "Check backend.log for details:"
        tail -10 backend.log
        exit 1
    fi
    print_success "Backend server started (PID: $BACKEND_PID)"
    
    print_status "Starting frontend server on http://localhost:3001..."
    cd "$PROJECT_ROOT/$FRONTEND_DIR"
    npm run dev > ../frontend.log 2>&1 &
    FRONTEND_PID=$!
    echo $FRONTEND_PID > "$FRONTEND_PID_FILE"
    cd "$PROJECT_ROOT"
    
    # Check if frontend started successfully
    sleep 3
    if ! ps -p $FRONTEND_PID > /dev/null 2>&1; then
        print_error "Failed to start frontend server!"
        print_error "Check frontend.log for details:"
        tail -10 frontend.log
        exit 1
    fi
    print_success "Frontend server started (PID: $FRONTEND_PID)"
    
    # Wait for servers to be fully ready
    print_status "Waiting for servers to be ready..."
    sleep 5
    
    print_success "🎉 Applications started successfully!"
    echo ""
    echo "🌐 Open your browser and visit:"
    echo "   Frontend: ${GREEN}http://localhost:3001${NC} (Main App)"
    echo "   Backend:  ${BLUE}http://localhost:3000${NC} (API)"
    echo ""
    print_status "📋 Logs are streamed to:"
    print_status "   Backend: backend.log"
    print_status "   Frontend: frontend.log"
    echo ""
    print_status "🛑 Press Ctrl+C to stop all servers"
    echo ""
    
    # Try to open the browser automatically (optional)
    if command -v open &> /dev/null; then
        # macOS
        print_status "🚀 Opening browser..."
        sleep 2
        open http://localhost:3001
    elif command -v xdg-open &> /dev/null; then
        # Linux
        print_status "🚀 Opening browser..."
        sleep 2
        xdg-open http://localhost:3001
    fi
    
    # Keep the script running until Ctrl+C
    print_status "💻 Servers are running... Press Ctrl+C to stop"
    while true; do
        # Check if processes are still running
        if ! ps -p $BACKEND_PID > /dev/null 2>&1; then
            print_error "Backend server stopped unexpectedly!"
            print_error "Check backend.log for details:"
            tail -10 backend.log
            cleanup
        fi
        if ! ps -p $FRONTEND_PID > /dev/null 2>&1; then
            print_error "Frontend server stopped unexpectedly!"
            print_error "Check frontend.log for details:"
            tail -10 frontend.log
            cleanup
        fi
        sleep 5
    done
}

# Function to stop the applications
stop_apps() {
    print_status "Stopping applications..."
    
    # Stop backend
    if [ -f "$BACKEND_PID_FILE" ]; then
        BACKEND_PID=$(cat "$BACKEND_PID_FILE")
        if ps -p $BACKEND_PID > /dev/null 2>&1; then
            kill $BACKEND_PID
            print_success "Backend server stopped"
        else
            print_warning "Backend server was not running"
        fi
        rm -f "$BACKEND_PID_FILE"
    else
        print_warning "Backend PID file not found"
    fi
    
    # Stop frontend
    if [ -f "$FRONTEND_PID_FILE" ]; then
        FRONTEND_PID=$(cat "$FRONTEND_PID_FILE")
        if ps -p $FRONTEND_PID > /dev/null 2>&1; then
            kill $FRONTEND_PID
            print_success "Frontend server stopped"
        else
            print_warning "Frontend server was not running"
        fi
        rm -f "$FRONTEND_PID_FILE"
    else
        print_warning "Frontend PID file not found"
    fi
    
    # Kill any remaining node processes related to the project
    pkill -f "ts-node.*src/main.ts" 2>/dev/null || true
    pkill -f "vite" 2>/dev/null || true
    
    print_success "All applications stopped"
}

# Function to clean everything
clean_all() {
    print_status "Cleaning project..."
    
    # Stop applications first
    stop_apps
    
    # Remove node_modules
    print_status "Removing node_modules..."
    rm -rf "$BACKEND_DIR/node_modules"
    rm -rf "$FRONTEND_DIR/node_modules"
    
    # Remove build directories
    print_status "Removing build directories..."
    rm -rf "$BACKEND_DIR/dist"
    rm -rf "$FRONTEND_DIR/dist"
    
    # Remove log files
    rm -f backend.log frontend.log
    
    # Remove PID files
    rm -f "$BACKEND_PID_FILE" "$FRONTEND_PID_FILE"
    
    print_success "Project cleaned successfully!"
}

# Function to show usage
show_usage() {
    echo "Mova App Management Script"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  install   - Install Node.js (if needed), dependencies, and setup environment"
    echo "  run       - Start both backend and frontend servers"
    echo "  stop      - Stop all running servers"
    echo "  clean     - Stop servers and clean all build files and dependencies"
    echo "  help      - Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 install   # First time setup"
    echo "  $0 run       # Start the application"
    echo "  $0 stop      # Stop the application"
    echo "  $0 clean     # Clean everything"
}

# Main script logic
case "${1:-help}" in
    install)
        print_status "🚀 Starting complete installation process..."
        print_status "This will install everything needed to run Mova webapp!"
        echo ""
        
        # Step 1: Check and install system prerequisites
        check_prerequisites
        
        # Step 2: Check and install Node.js
        check_node
        
        # Step 3: Install project dependencies
        install_deps
        
        # Step 4: Setup environment
        setup_env
        
        # Step 5: Build applications
        build_apps
        
        echo ""
        print_success "🎉 Installation completed successfully!"
        echo ""
        print_warning "📧 IMPORTANT: Configure your email credentials in backend/.env"
        print_status "   Edit backend/.env and add your Gmail credentials"
        echo ""
        print_status "🚀 Ready to run! Execute: '$0 run' to start the application"
        echo ""
        ;;
    run)
        start_apps
        ;;
    stop)
        stop_apps
        ;;
    clean)
        clean_all
        ;;
    help|--help|-h)
        show_usage
        ;;
    *)
        print_error "Unknown command: $1"
        show_usage
        exit 1
        ;;
esac