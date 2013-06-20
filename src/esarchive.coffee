fs = require 'fs'
url = require 'url'

config = require 'nconf'
logger = require './logger'

async = require 'async'
ElasticSearchClient = require 'elasticsearchclient'
chrono = require 'chrono-node'
request = require 'request'

###
The ESArchive utility itself.
###
class ESArchive
  constructor: () ->
    @commands = []
    @config = {}
    @setup_config()

  ###
  Reads the configuration for the current esarchive instance.
  ###
  setup_config: () =>
    exists = fs.existsSync config.get('config')
    if exists
      data = fs.readFileSync config.get('config')
      try
        @config = JSON.parse(data.toString('utf8'))
      catch error
        logger.error error
        @config = {}
    else
      logger.error "Config file `#{config.get('config')}` does not exist."
      process.exit(1)

  ###
  Returns the list of all nodes.
  ###
  nodes: () =>
    @config['nodes'] ||= []

  ###
  Returns all of the node names.
  ###
  node_names: () =>
    (node.name for node in @nodes())

  ###
  Returns the information for a specific node.
  ###
  info: (names...) =>
    if names.length == 0
      { nodes: @nodes() }
    else
      { nodes: @nodes().filter (x) -> x.name in names }

  ###
  Backup one or all of the current ES clients to S3, based on rotation time.
  @param {Array} args The list of machines to backup, empty assumes all.
  ###
  backup: (args...) =>
    console.log args

  ###
  Restore a range of time for a specific ES client on the given ES instance.
  @param {Array} args The list of machines to restore, empty assumes all.
  ###
  restore: (args...) =>
    console.log args

  ###
  Removes logs and indexes older than the configured rotation time.
  @param {Array} args The list of machines to cleanup, empty assumes all.
  ###
  cleanup: (args..., fn) =>
    async.each @nodes(), @cleanup_node, fn

  ###
  Gets the log rotation period for the given node.
  @param {Object} node The node configuration object to reference
  ###
  log_rotation: (node) =>
    chrono.parseDate("#{node['rotate'] || @config['rotate']} at 00:00")

  ###
  Takes an index and parses the date to use for comparison to rotation.
  @param {String} index The index name and date
  ###
  parse_index_date: (index) =>    
    new Date(index.split('-').pop().split('.'))

  ###
  Generates a url for the given node.
  @param {Object} node The node configuration object to reference
  @param {String} target The target url to generate
  ###
  node_url: (node, target) =>
    address = @config['address'] || node['address'] || "localhost"
    url.resolve("http://#{address}:#{node.http_port}", target)

  ###
  Removes indexes for a given node that are out of the rotation period.
  @param {Object} node The node configuration object to reference
  ###
  cleanup_node: (node) =>
    request.get @node_url(node, "_status"), json: true,
    timeout: 5000, (error, response, body) =>
      async.filter Object.keys(body.indices),
      (index, fn) =>
        fn(@log_rotation(node) > @parse_index_date(index))
      , (indices) =>
        if indices.length > 0
          async.each indices, async.apply(@remove_index, node), (err) =>
            logger.error err

  ###
  Removes a given index for a single node.
  @param {Object} node The node to cleanup the index for
  @param {String} index The index to remove
  @param {Object} fn The callback function
  ###
  remove_index: (node, index, fn) =>
    request.del "#{@node_url(node, index)}/", (error, response, body) =>
      logger.info "Removed index `#{index}` from `#{node.name}`."

module.exports = ESArchive
