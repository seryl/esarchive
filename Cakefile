{exec} = require 'child_process'

node_bins = "#{__dirname}/node_modules/.bin"

option '-r', '--reporter [REPORTER]', 'set the mocha reporter for `test`'

task 'build', 'Build project from src/*.coffee to lib/*.js', ->
  exec 'coffee --compile --output lib/ src/', (err, stdout, stderr) ->
    throw err if err
    if stdout or stderr
      console.log stdout + stderr

task 'watch', 'Starts a watcher for the src/*.coffee files', ->
  exec 'coffee -w src/ -o lib/', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

task 'doc', 'Generates documenation for the project', ->
  exec "./node_modules/.bin/codo --cautious"

task "test", "run tests", (options)->
  options.reporter or= "spec"
  exec "clear; NODE_ENV=test
    #{node_bins}/mocha
    --compilers coffee:coffee-script
    --reporter #{options.reporter}
    --require coffee-script
    --require test/lib/test_helper.coffee
    --timeout 4000
    --slow 100
    --colors
  ", (err, output) ->
    throw err if err
    console.log output