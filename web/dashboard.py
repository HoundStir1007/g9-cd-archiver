#!/usr/bin/env python3
"""
Tailscale Monitoring Dashboard
A web-based dashboard for monitoring Tailscale connections and system metrics.
"""

import os
import json
import logging
from datetime import datetime, timedelta
from pathlib import Path
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
from flask import Flask, render_template, jsonify
from flask_socketio import SocketIO
import psutil
import requests
from werkzeug.middleware.proxy_fix import ProxyFix

# Configuration
CONFIG = {
    'METRICS_PATH': r'C:\Logs\Tailscale\Metrics',
    'LOG_PATH': r'C:\Logs\Tailscale',
    'DASHBOARD_PORT': 5000,
    'REFRESH_INTERVAL': 5000,  # milliseconds
    'HISTORY_HOURS': 24,
    'LATENCY_THRESHOLD': 100,  # ms
}

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(os.path.join(CONFIG['LOG_PATH'], 'dashboard.log')),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

# Initialize Flask app
app = Flask(__name__)
app.wsgi_app = ProxyFix(app.wsgi_app, x_proto=1, x_host=1)
socketio = SocketIO(app, cors_allowed_origins="*")

def get_latest_metrics():
    """Get the most recent metrics from the metrics directory."""
    try:
        today = datetime.now().strftime('%Y-%m-%d')
        metrics_file = os.path.join(CONFIG['METRICS_PATH'], f'tailscale_metrics_{today}.json')
        
        if not os.path.exists(metrics_file):
            return None
            
        with open(metrics_file, 'r') as f:
            metrics = [json.loads(line) for line in f if line.strip()]
            
        if not metrics:
            return None
            
        return metrics[-1]  # Return most recent metric
    except Exception as e:
        logger.error(f"Error getting latest metrics: {e}")
        return None

def get_historical_metrics(hours=CONFIG['HISTORY_HOURS']):
    """Get historical metrics for the specified time period."""
    try:
        metrics = []
        start_time = datetime.now() - timedelta(hours=hours)
        
        # Get today's metrics
        today = datetime.now().strftime('%Y-%m-%d')
        today_file = os.path.join(CONFIG['METRICS_PATH'], f'tailscale_metrics_{today}.json')
        if os.path.exists(today_file):
            with open(today_file, 'r') as f:
                metrics.extend([json.loads(line) for line in f if line.strip()])
        
        # Get yesterday's metrics if needed
        if hours > 24:
            yesterday = (datetime.now() - timedelta(days=1)).strftime('%Y-%m-%d')
            yesterday_file = os.path.join(CONFIG['METRICS_PATH'], f'tailscale_metrics_{yesterday}.json')
            if os.path.exists(yesterday_file):
                with open(yesterday_file, 'r') as f:
                    metrics.extend([json.loads(line) for line in f if line.strip()])
        
        # Filter metrics by time
        metrics = [m for m in metrics if datetime.strptime(m['Timestamp'], '%Y-%m-%d %H:%M:%S') >= start_time]
        return metrics
    except Exception as e:
        logger.error(f"Error getting historical metrics: {e}")
        return []

def get_system_metrics():
    """Get current system metrics."""
    try:
        cpu_percent = psutil.cpu_percent(interval=1)
        memory = psutil.virtual_memory()
        disk = psutil.disk_usage('/')
        
        return {
            'cpu_percent': cpu_percent,
            'memory_percent': memory.percent,
            'memory_available': round(memory.available / (1024**3), 2),  # GB
            'disk_percent': disk.percent,
            'disk_free': round(disk.free / (1024**3), 2),  # GB
            'timestamp': datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        }
    except Exception as e:
        logger.error(f"Error getting system metrics: {e}")
        return None

@app.route('/')
def index():
    """Render the main dashboard page."""
    return render_template('index.html', 
                         refresh_interval=CONFIG['REFRESH_INTERVAL'],
                         latency_threshold=CONFIG['LATENCY_THRESHOLD'])

@app.route('/api/metrics/current')
def current_metrics():
    """API endpoint for current metrics."""
    tailscale_metrics = get_latest_metrics()
    system_metrics = get_system_metrics()
    
    if tailscale_metrics and system_metrics:
        return jsonify({
            'tailscale': tailscale_metrics,
            'system': system_metrics,
            'timestamp': datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        })
    return jsonify({'error': 'No metrics available'}), 404

@app.route('/api/metrics/history')
def historical_metrics():
    """API endpoint for historical metrics."""
    metrics = get_historical_metrics()
    if metrics:
        return jsonify(metrics)
    return jsonify({'error': 'No historical metrics available'}), 404

@app.route('/api/metrics/charts')
def metric_charts():
    """API endpoint for chart data."""
    metrics = get_historical_metrics()
    if not metrics:
        return jsonify({'error': 'No metrics available for charts'}), 404
    
    # Convert to DataFrame for easier manipulation
    df = pd.DataFrame(metrics)
    df['Timestamp'] = pd.to_datetime(df['Timestamp'])
    
    # Create latency chart
    latency_fig = px.line(df, x='Timestamp', y='Latency',
                         title='Tailscale Latency Over Time')
    latency_fig.add_hline(y=CONFIG['LATENCY_THRESHOLD'], 
                         line_dash="dash", 
                         line_color="red",
                         annotation_text="Threshold")
    
    # Create connection status chart
    status_fig = px.scatter(df, x='Timestamp', y='Connected',
                           title='Connection Status Over Time')
    
    # Create DERP usage chart
    derp_fig = px.scatter(df, x='Timestamp', y='UsingDERP',
                         title='DERP Usage Over Time')
    
    return jsonify({
        'latency': latency_fig.to_json(),
        'status': status_fig.to_json(),
        'derp': derp_fig.to_json()
    })

@socketio.on('connect')
def handle_connect():
    """Handle WebSocket connection."""
    logger.info('Client connected')

@socketio.on('disconnect')
def handle_disconnect():
    """Handle WebSocket disconnection."""
    logger.info('Client disconnected')

def update_clients():
    """Send updates to connected clients."""
    while True:
        try:
            metrics = {
                'tailscale': get_latest_metrics(),
                'system': get_system_metrics(),
                'timestamp': datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            }
            socketio.emit('metrics_update', metrics)
            socketio.sleep(CONFIG['REFRESH_INTERVAL'] / 1000)  # Convert to seconds
        except Exception as e:
            logger.error(f"Error updating clients: {e}")
            socketio.sleep(5)  # Wait before retrying

if __name__ == '__main__':
    # Start background task for client updates
    socketio.start_background_task(update_clients)
    
    # Start the server
    logger.info(f"Starting dashboard on port {CONFIG['DASHBOARD_PORT']}")
    socketio.run(app, host='0.0.0.0', port=CONFIG['DASHBOARD_PORT'], debug=False) 