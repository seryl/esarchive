[![build status](https://secure.travis-ci.org/seryl/esarchive.png)](http://travis-ci.org/seryl/esarchive)
esarchive
=========

An elasticsearch archival utility with backup/restore/cleanup.

Configuration
-------------

```json
{
  "rotate": "36 days ago",
  "nodes": [
    {
      "name": "stgsystem",
      "http_port": 10100,
      "tcp_port": 10110
    }
  ]
}
```
