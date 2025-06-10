#!/usr/bin/env python3
"""Quick test to fix YouTube search API issue"""

try:
    from youtubesearchpython import VideosSearch
    print("✅ YouTube search library imported successfully")
    
    # Test a simple search
    print("🔍 Testing YouTube search...")
    search = VideosSearch("Voodoo Glow Skulls Creep Tonight", limit=3)
    results = search.result()
    
    print(f"✅ Search successful! Found {len(results.get('result', []))} results")
    
    for i, video in enumerate(results.get('result', [])[:2], 1):
        print(f"   {i}. {video.get('title', 'No title')}")
        print(f"      Channel: {video.get('channel', {}).get('name', 'Unknown')}")
        print(f"      Views: {video.get('viewCount', {}).get('short', '0')}")
        print()
    
except Exception as e:
    print(f"❌ Error: {e}")
    print(f"Error type: {type(e)}")
    
    # Try alternative search method
    try:
        print("\n🔄 Trying alternative search method...")
        from youtubesearchpython import VideosSearch
        search = VideosSearch("test", limit=1)
        # Force the search without proxies parameter
        search._sync_search_handler.client = search._sync_search_handler.client
        results = search.result()
        print("✅ Alternative method worked!")
    except Exception as e2:
        print(f"❌ Alternative method also failed: {e2}") 