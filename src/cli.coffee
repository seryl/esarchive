optimist = require 'optimist'
logger = require './logger'
config = require 'nconf'
require('pkginfo')(module, 'name')

###
The command line interface class.
###
class CLI
  constructor: () ->
    usage_string = """
    Usage: #{exports.name}

           #{exports.name} list
           #{exports.name} backup  [<instance> | ...]
           #{exports.name} restore [<instance> | ...]
           #{exports.name} cleanup [<instance> | ...]
    """
    @argv = optimist
      .usage(usage_string)

      # configuration
      .alias('c', 'config')
      .describe('c', 'The configuration file to use')
      .default('c', "/etc/esarchive.json")

      # logging
      .alias('l', 'loglevel')
      .describe('l', 'Set the log level (debug, info, warn, error, fatal)')
      .default('l', 'warn')

      # help
      .alias('h', 'help')
      .describe('h', 'Shows this message')
      .default('h', false)

      # append the argv from the cli
      .argv

    @configure()

    if config.get('help').toString() is "true"
      optimist.showHelp()
      process.exit(0)

  # Configures the nconf mapping where the priority matches the order
  configure: () =>
    @set_overrides()
    @set_env()
    @set_argv()
    @set_file()
    @set_defaults()

  # Sets up forceful override values
  set_overrides: () =>
    config.overrides({
      })

  # Sets up the configuration for cli arguments
  set_argv: () =>
    config.add('optimist_args', {type: 'literal', store: @argv})

  # Sets up the environment configuration
  set_env: () =>
    config.env({
      whitelist: []
      })

  # Sets up the file configuration
  set_file: () =>
    config.file({ file: @argv['config'] })


  # Sets up the default configuration
  set_defaults: () =>
    config.defaults({
      })

module.exports = new CLI()
