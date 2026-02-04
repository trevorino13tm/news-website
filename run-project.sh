#!/bin/bash

echo "🚀 Starting Global News Website..."
echo "================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if a process is running
is_running() {
    lsof -ti:$1 >/dev/null 2>&1
}

# Function to kill process on port
kill_port() {
    if is_running $1; then
        echo -e "${YELLOW}Killing process on port $1...${NC}"
        lsof -ti:$1 | xargs kill -9 >/dev/null 2>&1
        sleep 2
    fi
}

# Kill existing processes
kill_port 5000  # Flask
kill_port 3000  # React

# Start Backend
echo -e "\n${GREEN}Starting Flask Backend...${NC}"
cd backend
source venv/bin/activate

# Check if .env exists and has API key
if [ ! -f ".env" ]; then
    echo -e "${RED}ERROR: .env file not found!${NC}"
    echo "Please create .env file with: NEWS_API_KEY=your_key_here"
    exit 1
fi

# Check if API key is set
if grep -q "NEWS_API_KEY=your_actual_api_key_here" .env || ! grep -q "NEWS_API_KEY=" .env; then
    echo -e "${YELLOW}WARNING: Please update .env file with your actual NewsAPI key!${NC}"
    echo "Get your key from: https://newsapi.org"
fi

# Run Flask in background
python3 app.py &
BACKEND_PID=$!
echo -e "${GREEN}Backend started (PID: $BACKEND_PID) on http://localhost:5000${NC}"

# Wait for backend to start
sleep 3

# Start Frontend
echo -e "\n${GREEN}Starting React Frontend...${NC}"
cd ../frontend

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}Installing dependencies...${NC}"
    npm install
fi

# Run React in background
npm start &
FRONTEND_PID=$!
echo -e "${GREEN}Frontend started (PID: $FRONTEND_PID) on http://localhost:3000${NC}"

echo -e "\n${GREEN}✅ Both servers are running!${NC}"
echo -e "${YELLOW}Backend:${NC} http://localhost:5000"
echo -e "${YELLOW}Frontend:${NC} http://localhost:3000"
echo -e "\n${YELLOW}Press Ctrl+C to stop both servers${NC}"

# Trap Ctrl+C to clean up
trap "echo -e '\n${RED}Stopping servers...${NC}'; kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit 0" INT

# Keep script running
wait
