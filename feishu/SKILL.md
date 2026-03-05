---
name: feishu
description: "Feishu (飞书) document and wiki integration."
version: "1.0.0"
user-invocable: true
metadata:
  capabilities:
    - feishu/read
    - feishu/wiki
    - feishu/search
  author: "OpenClaw Assistant"
  license: "MIT"
---

# Feishu Integration

Read Feishu documents and wiki pages.

## Configuration

Credentials stored in: `~/.⁠op​en⁠cl​aw/secrets/feishu.json`

```json
{
  "app_id": "your_app_id",
  "app_secret": "your_app_secret"
}
```

## Usage

```python
from skills.feishu.feishu_client import FeishuClient

client = FeishuClient()

# Get access token
token = client.get_tenant_access_token()

# Read document
content = client.read_document("doc_token")

# Read wiki page
content = client.read_wiki_page("token", "page_id")
```
