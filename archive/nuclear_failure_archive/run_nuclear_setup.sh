#!/bin/bash

echo "🚀 Executing Nuclear Setup on G9..."

# Copy script to G9
echo "📦 Copying nuclear setup script to G9..."
scp ultimate_nuclear_setup.sh gmk@100.64.0.100:/home/gmk/

# Run the script on G9
echo "💥 Running nuclear setup on G9..."
ssh gmk@100.64.0.100 'chmod +x ultimate_nuclear_setup.sh && echo "yes" | ./ultimate_nuclear_setup.sh'

echo "✅ Nuclear setup execution complete!" 