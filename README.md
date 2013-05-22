[![build status](https://secure.travis-ci.org/seryl/esarchive.png)](http://travis-ci.org/seryl/esarchive)
esarchive
=========

An elasticsearch archival utility with backup/restore/cleanup.

configuration
-------------

The configuration is a straightforward json file:

```json
{
  "aws": {
    "access_key": "YOUR_AWS_ACCESS_KEY",
    "access_secret": "YOUR_AWS_ACCESS_SECRET"
  },
  "rotate": "36 days ago",
  "nodes": [
    {
      "name": "system1",
      "http_port": 9200,
      "tcp_port": 9300,
      "index_path": "/data/elasticsearch/system1/nodes/0/indices"
    },
    {
      "name": "system2",
      "http_port": 9201,
      "tcp_port": 9301,
      "index_path": "/data/elasticsearch/system2/nodes/0/indices",
      "rotate": "7 days ago"
    }
  ]
}
```

There are three main components:

* aws
* rotate
* nodes

### aws

The AWS object is just a hash of your AWS access_key and access_secret.

### rotate

The default rotation period for triggering an archival & cleanup.
This can be declared at the top level and also individually for a node.

__Note__: Unfortunately `chrono` only correctly handles `days ago` at the moment, so everything must be declared based on that.

### nodes

Nodes must specify the following:

* name
* http_port
* tcp_port
* index_path
* rotation _(optional)_
