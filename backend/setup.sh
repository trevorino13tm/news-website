#!/bin/bash

echo "🔧 Setting up Flask Backend..."

# Check if in backend directory
if [[ ! $(pwd) =~ "backend" ]]; then
    echo "⚠️  Please run this script from the backend directory"
    exit 1
fi

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

# Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip

# Install dependencies
echo "Installing dependencies..."
pip install Flask==2.3.3 Flask-CORS==4.0.0 python-dotenv==1.0.0 requests==2.31.0

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    echo "Creating .env file..."
    echo "NEWS_API_KEY=your_actual_api_key_here" > .env
    echo "FLASK_ENV=development" >> .env
    echo ""
    echo "⚠️  IMPORTANT: Please edit .env file and add your NewsAPI key!"
    echo "   Get your key from: https://newsapi.org"
    echo ""
fi

# Verify installation
echo "Verifying installation..."
python3 -c "import flask; print('✅ Flask version:', flask.__version__)"
python3 -c "import flask_cors; print('✅ Flask-CORS installed')"
python3 -c "import dotenv; print('✅ python-dotenv installed')"
python3 -c "import requests; print('✅ Requests version:', requests.__version__)"

echo ""
echo "✅ Setup complete!"
echo "📝 To run the server:"
echo "   source venv/bin/activate"
echo "   python3 app.py"
echo ""
