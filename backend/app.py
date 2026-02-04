from flask import Flask, jsonify, request
from flask_cors import CORS
import requests
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)
CORS(app)  # Enable CORS for React frontend

NEWS_API_KEY = os.getenv('NEWS_API_KEY')
BASE_URL = 'https://newsapi.org/v2'

@app.route('/')
def home():
    return jsonify({
        "message": "News API Server is running",
        "endpoints": {
            "/api/headlines": "Get top headlines",
            "/api/search?q=query": "Search news",
            "/api/category/<category>": "Get news by category"
        }
    })

@app.route('/api/headlines', methods=['GET'])
def get_headlines():
    """Get top headlines from multiple countries"""
    try:
        country = request.args.get('country', 'us')
        
        response = requests.get(
            f'{BASE_URL}/top-headlines',
            params={
                'country': country,
                'apiKey': NEWS_API_KEY,
                'pageSize': 30
            }
        )
        
        data = response.json()
        
        if data['status'] == 'ok':
            return jsonify({
                'status': 'success',
                'totalResults': data['totalResults'],
                'articles': data['articles']
            })
        else:
            return jsonify({
                'status': 'error',
                'message': data.get('message', 'Unknown error')
            }), 400
            
    except Exception as e:
        return jsonify({
            'status': 'error',
            'message': str(e)
        }), 500

@app.route('/api/search', methods=['GET'])
def search_news():
    """Search for news articles"""
    try:
        query = request.args.get('q', '')
        if not query:
            return jsonify({
                'status': 'error',
                'message': 'Search query is required'
            }), 400
        
        response = requests.get(
            f'{BASE_URL}/everything',
            params={
                'q': query,
                'apiKey': NEWS_API_KEY,
                'pageSize': 30,
                'sortBy': 'relevancy',
                'language': 'en'
            }
        )
        
        data = response.json()
        
        if data['status'] == 'ok':
            return jsonify({
                'status': 'success',
                'totalResults': data['totalResults'],
                'articles': data['articles']
            })
        else:
            return jsonify({
                'status': 'error',
                'message': data.get('message', 'Unknown error')
            }), 400
            
    except Exception as e:
        return jsonify({
            'status': 'error',
            'message': str(e)
        }), 500

@app.route('/api/category/<category>', methods=['GET'])
def get_category(category):
    """Get news by category"""
    try:
        valid_categories = ['business', 'entertainment', 'general', 'health', 'science', 'sports', 'technology']
        
        if category not in valid_categories:
            return jsonify({
                'status': 'error',
                'message': f'Invalid category. Valid categories: {", ".join(valid_categories)}'
            }), 400
        
        country = request.args.get('country', 'us')
        
        response = requests.get(
            f'{BASE_URL}/top-headlines',
            params={
                'country': country,
                'category': category,
                'apiKey': NEWS_API_KEY,
                'pageSize': 30
            }
        )
        
        data = response.json()
        
        if data['status'] == 'ok':
            return jsonify({
                'status': 'success',
                'totalResults': data['totalResults'],
                'articles': data['articles']
            })
        else:
            return jsonify({
                'status': 'error',
                'message': data.get('message', 'Unknown error')
            }), 400
            
    except Exception as e:
        return jsonify({
            'status': 'error',
            'message': str(e)
        }), 500

if __name__ == '__main__':
    app.run(debug=True, port=5000)