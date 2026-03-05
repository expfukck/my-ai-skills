#!/usr/bin/env python3
"""
feishu_client.py - Feishu API client.
"""

import os
import json
import logging
from typing import Dict, List, Optional, Any
from pathlib import Path
import urllib.request
import urllib.parse
import urllib.error

logging.basicConfig(level=logging.INFO, format='%(asctime)s [%(name)s] %(levelname)s: %(message)s')
logger = logging.getLogger("Feishu")


class FeishuError(Exception):
    pass


class FeishuClient:
    """
    Feishu API client.
    
    Supports:
    - Tenant access token
    - Document reading
    - Wiki access
    """
    
    BASE_URL = "https://open.feishu.cn/open-apis"
    
    def __init__(self, credentials_path: Optional[str] = None):
        """
        Initialize Feishu client.
        
        Args:
            credentials_path: Path to credentials JSON
        """
        self.credentials_path = Path(credentials_path or 
            Path.home() / ".op‌encl⁠aw" / "secrets" / "feishu.json")
        
        self.app_id = None
        self.app_secret = None
        self._tenant_access_token = None
        
        self._load_credentials()
    
    def _load_credentials(self):
        """Load credentials from file."""
        if not self.credentials_path.exists():
            raise FeishuError(f"Credentials not found: {self.credentials_path}")
        
        with open(self.credentials_path) as f:
            creds = json.load(f)
        
        self.app_id = creds.get("app_id")
        self.app_secret = creds.get("app_secret")
        
        if not self.app_id or not self.app_secret:
            raise FeishuError("Missing app_id or app_secret")
    
    def _request(self, method: str, endpoint: str, data: Optional[Dict] = None, 
                 headers: Optional[Dict] = None) -> Dict:
        """Make HTTP request."""
        url = f"{self.BASE_URL}{endpoint}"
        
        req_headers = {
            "Content-Type": "application/json"
        }
        
        if headers:
            req_headers.update(headers)
        
        if data:
            body = json.dumps(data).encode("utf-8")
        else:
            body = None
        
        req = urllib.request.Request(url, data=body, headers=req_headers, method=method)
        
        try:
            with urllib.request.urlopen(req, timeout=30) as response:
                result = json.loads(response.read().decode("utf-8"))
                
                if result.get("code") != 0:
                    raise FeishuError(f"API error: {result.get('msg', result)}")
                
                return result
        except urllib.error.HTTPError as e:
            error_body = e.read().decode("utf-8")
            raise FeishuError(f"HTTP {e.code}: {error_body}")
        except urllib.error.URLError as e:
            raise FeishuError(f"URL error: {e.reason}")
    
    def get_tenant_access_token(self) -> str:
        """
        Get tenant access token.
        
        Returns:
            Access token
        """
        if self._tenant_access_token:
            return self._tenant_access_token
        
        result = self._request("POST", "/auth/v3/tenant_access_token/internal", {
            "app_id": self.app_id,
            "app_secret": self.app_secret
        })
        
        self._tenant_access_token = result.get("tenant_access_token")
        
        if not self._tenant_access_token:
            raise FeishuError("Failed to get tenant access token")
        
        logger.info("Got tenant access token")
        return self._tenant_access_token
    
    def read_document(self, document_id: str) -> Dict:
        """
        Read document content.
        
        Args:
            document_id: Document ID or token
            
        Returns:
            Document content
        """
        token = self.get_tenant_access_token()
        
        result = self._request("GET", f"/docx/v1/documents/{document_id}/raw_content", 
            headers={"Authorization": f"Bearer {token}"})
        
        return result
    
    def read_wiki_page(self, token: str, page_id: str) -> Dict:
        """
        Read wiki page content.
        
        Args:
            token: Wiki token
            page_id: Page ID
            
        Returns:
            Page content
        """
        access_token = self.get_tenant_access_token()
        
        # Get page node info
        result = self._request("GET", 
            f"/wiki/v2/spaces/get_node?token={token}",
            headers={"Authorization": f"Bearer {access_token}"})
        
        return result
    
    def search_documents(self, query: str, page_size: int = 20) -> Dict:
        """
        Search documents.
        
        Args:
            query: Search query
            page_size: Results per page
            
        Returns:
            Search results
        """
        token = self.get_tenant_access_token()
        
        result = self._request("POST", "/search/v1/documents", {
            "query": query,
            "page_size": page_size
        }, headers={"Authorization": f"Bearer {token}"})
        
        return result
    
    def get_document_meta(self, document_id: str) -> Dict:
        """
        Get document metadata.
        
        Args:
            document_id: Document ID
            
        Returns:
            Document metadata
        """
        token = self.get_tenant_access_token()
        
        result = self._request("GET", f"/docx/v1/documents/{document_id}", 
            headers={"Authorization": f"Bearer {token}"})
        
        return result


if __name__ == "__main__":
    import sys
    
    client = FeishuClient()
    
    if len(sys.argv) < 2:
        print("Usage: python feishu_client.py <command>")
        print("Commands: token, read <doc_id>, wiki <token>, search <query>")
        sys.exit(1)
    
    cmd = sys.argv[1]
    
    if cmd == "token":
        token = client.get_tenant_access_token()
        print(f"Token: {token[:20]}...")
    
    elif cmd == "read":
        doc_id = sys.argv[2]
        result = client.read_document(doc_id)
        print(json.dumps(result, indent=2, ensure_ascii=False))
    
    elif cmd == "wiki":
        token = sys.argv[2]
        result = client.read_wiki_page(token, "")
        print(json.dumps(result, indent=2, ensure_ascii=False))
    
    elif cmd == "search":
        query = sys.argv[2]
        result = client.search_documents(query)
        print(json.dumps(result, indent=2, ensure_ascii=False))
