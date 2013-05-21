logger = require './logger'
cli = require './cli'
config = require 'nconf'
ESArchive = require './esarchive'

###
The base application class.
###
class Application
  constructor: () ->
    @esarchive = new ESArchive()
    @esarchive.handle_cli_args()

  abort: (str) =>
    logger.info('aborting...')
    process.exit(1)

module.exports = Application
