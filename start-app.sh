#!/bin/bash

# Mova App Management Script for Mac/Linux
# Usage: ./start-app.sh [install|run]

BACKEND_DIR="backend"
FRONTEND_DIR="frontend"
PROJECT_ROOT=$(pwd)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
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

# Cleanup function for Ctrl+C
cleanup() {
    echo
    print_info "Cleaning up processes..."
    
    # Kill Node.js processes
    pkill -f "npm run dev" 2>/dev/null
    pkill -f "node.*backend" 2>/dev/null
    pkill -f "node.*frontend" 2>/dev/null
    
    print_info "Cleanup completed"
    exit 0
}

# Set trap for Ctrl+C
trap cleanup SIGINT SIGTERM

install_command() {
    print_info "Starting installation process..."
    echo

    # Check Node.js
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed!"
        print_info "Opening Node.js download page..."
        if command -v open &> /dev/null; then
            open https://nodejs.org/
        elif command -v xdg-open &> /dev/null; then
            xdg-open https://nodejs.org/
        fi
        print_info "Please install Node.js and run this script again."
        exit 1
    fi

    node --version
    print_success "Node.js is installed"

    # Install backend dependencies
    print_info "Installing backend dependencies..."
    cd "$PROJECT_ROOT/$BACKEND_DIR"
    npm install --legacy-peer-deps
    if [ $? -ne 0 ]; then
        print_error "Failed to install backend dependencies"
        exit 1
    fi
    print_success "Backend dependencies installed"

    # Install frontend dependencies
    print_info "Installing frontend dependencies..."
    cd "$PROJECT_ROOT/$FRONTEND_DIR"
    npm install --legacy-peer-deps
    if [ $? -ne 0 ]; then
        print_error "Failed to install frontend dependencies"
        exit 1
    fi
    print_success "Frontend dependencies installed"

    # Start Docker containers
    cd "$PROJECT_ROOT"
    print_info "Starting Docker containers..."
    if command -v docker-compose &> /dev/null; then
        docker-compose up -d
        if [ $? -eq 0 ]; then
            print_success "Docker containers started"
        else
            print_warning "Failed to start Docker containers. Make sure Docker is installed and running."
        fi
    else
        print_warning "Docker Compose not found. Make sure Docker is installed."
    fi

    # Create .env file if it doesn't exist
    if [ ! -f "$BACKEND_DIR/.env" ]; then
        print_info "Creating .env file..."
        cat > "$BACKEND_DIR/.env" << EOF
PORT=3000
NODE_ENV=development
DB_HOST=localhost
DB_PORT=5433
DB_USERNAME=mova_user
DB_PASSWORD=mova_password
DB_NAME=mova_db
EMAIL_USER=your-email@gmail.com
EMAIL_PASS=your-app-password
EOF
        print_success "Created .env file"
        print_warning "Please edit backend/.env with your email credentials"
    fi

    echo
    print_success "Installation completed successfully!"
    print_info "Run './start-app.sh run' to start the application"
}

run_command() {
    print_info "Starting Mova application..."

    # Check if installation was done
    if [ ! -d "$BACKEND_DIR/node_modules" ]; then
        print_error "Backend not installed. Run './start-app.sh install' first."
        exit 1
    fi
    if [ ! -d "$FRONTEND_DIR/node_modules" ]; then
        print_error "Frontend not installed. Run './start-app.sh install' first."
        exit 1
    fi
    if [ ! -f "$BACKEND_DIR/.env" ]; then
        print_error ".env file not found. Run './start-app.sh install' first."
        exit 1
    fi

    # Start Docker containers
    print_info "Starting Docker containers..."
    if command -v docker-compose &> /dev/null; then
        docker-compose up -d >/dev/null 2>&1
    fi

    # Start backend in background
    print_info "Starting backend server..."
    cd "$PROJECT_ROOT/$BACKEND_DIR"
    npm run dev &
    BACKEND_PID=$!
    cd "$PROJECT_ROOT"

    # Wait a moment for backend to start
    sleep 3

    # Start frontend in background
    print_info "Starting frontend server..."
    cd "$PROJECT_ROOT/$FRONTEND_DIR"
    npm run dev &
    FRONTEND_PID=$!
    cd "$PROJECT_ROOT"

    echo
    print_success "Application started!"
    echo "Frontend: http://localhost:3001"
    echo "Backend:  http://localhost:3000"
    echo
    print_info "Press Ctrl+C to stop all processes"

    # Wait for processes to finish or Ctrl+C
    wait
}

show_help() {
    echo "Mova App Management Script"
    echo
    echo "Usage: $0 [command]"
    echo
    echo "Commands:"
    echo "  install   - Install dependencies and setup environment"
    echo "  run       - Start the application"
    echo "  help      - Show this help"
    echo
}

# Main script logic
case "${1:-help}" in
    install)
        install_command
        ;;
    run)
        run_command
        ;;
    *)
        show_help
        ;;
esac