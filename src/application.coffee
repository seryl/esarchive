logger = require './logger'
config = require 'nconf'
ESArchiveCLI = require './esarchive_cli'

###
The base application class.
###
class Application
  constructor: () ->
    @esarchive = new ESArchiveCLI()

  abort: (str) =>
    logger.info('aborting...')
    process.exit(1)

module.exports = Application
