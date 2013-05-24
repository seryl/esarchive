ElasticSearchClient = require('elasticsearchclient')
config = require 'nconf'
cli = require './cli'
fs = require 'fs'

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
        console.log error
        @config = {}
    else
      @config = {}

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
  node_info: (names...) =>
    if names == []
    else
      console.log names

  ###
  List all of the available elastic search configurations.
  ###
  list: (args...) =>
    for node in @node_names()
      console.log node
    @node_info(args...)

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
  cleanup: (args...) =>
    console.log args

module.exports = ESArchive
