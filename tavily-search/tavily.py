#!/usr/bin/env python3
"""Tavily search integration."""

import os
import json
import urllib.request
import urllib.parse

def search(query: str, max_results: int = 5) -> list:
    """Search the web using Tavily API."""
    api_key = os.getenv("TAVILY_API_KEY")
    if not api_key:
        return [{"error": "TAVILY_API_KEY not set"}]
    
    url = "https://api.tavily.com/search"
    data = json.dumps({
        "api_key": api_key,
        "query": query,
        "max_results": max_results
    }).encode("utf-8")
    
    req = urllib.request.Request(url, data=data, 
        headers={"Content-Type": "application/json"})
    
    with urllib.request.urlopen(req, timeout=30) as response:
        result = json.loads(response.read().decode("utf-8"))
    
    return result.get("results", [])

if __name__ == "__main__":
    import sys
    query = sys.argv[1] if len(sys.argv) > 1 else "test"
    results = search(query)
    print(json.dumps(results, indent=2, ensure_ascii=False))
