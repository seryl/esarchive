ElasticSearchClient = require('elasticsearchclient')
config = require 'nconf'
cli = require './cli'

###
The ESArchive utility itself.
###
class ESArchive
  constructor: () ->
    @commands = []
    @config = {}

  ###
  Takes CLI arguments and runs them agains the 
  ###
  handle_cli_args: () =>
    @commands = cli.argv['_']
    cmd = @commands.shift()
    if @[cmd] == undefined or @[cmd] == null
      console.log "The command `#{cmd}` does not exist."
    else
      @[cmd].apply(null, @commands)

  ###
  Reads the configuration for 
  ###
  read_config: () =>
    @config 

  ###
  List all of the available elastic search configurations.
  ###
  list: (args...) =>
    console.log args

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
