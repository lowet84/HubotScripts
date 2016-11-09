# Comment!
gitPull = require('git-pull')
reload = require('hubot-reload-scripts')

module.exports = (robot) ->
  robot.respond /scripts/i, (res) ->
    res.send "Getting scripts from github"
    callback = (err, consoleOutput) ->
      if(err)
        res.send "Error: " + err
      else
        res.send "Success! :)"
        reloadAllScripts res,success,(err)->
          res.send err
    gitPull('/app/scripts',callback)

  success = (msg) ->
  # Cleanup old listeners and help
    for listener in oldListeners
      listener = {}
    oldListeners = null
    oldCommands = null
    msg.send "Reloaded all scripts"

  deleteScriptCache = (scriptsBaseDir) ->
    if Fs.existsSync(scriptsBaseDir)
      fileList = walkSync scriptsBaseDir

      for file in fileList.sort()
        robot.logger.debug "file: #{file}"
        if require.cache[require.resolve(file)]
          try
            cacheobj = require.resolve(file)
            console.log "Invalidate require cache for #{cacheobj}"
            delete require.cache[cacheobj]
          catch error
            console.log "Unable to invalidate #{cacheobj}: #{error.stack}"
    robot.logger.debug "Finished deleting script cache!"

  reloadAllScripts = (msg, success, error) ->
    robot = msg.robot
    robot.emit('reload_scripts')

    robot.logger.debug "Deleting script cache..."

    scriptsPath = Path.resolve ".", "scripts"
    deleteScriptCache scriptsPath
    robot.load scriptsPath

    scriptsPath = Path.resolve ".", "src", "scripts"
    deleteScriptCache scriptsPath
    robot.load scriptsPath

    robot.logger.debug "Loading hubot scripts..."

    hubotScripts = Path.resolve ".", "hubot-scripts.json"
    Fs.exists hubotScripts, (exists) ->
      if exists
        Fs.readFile hubotScripts, (err, data) ->
          if data.length > 0
            try
              scripts = JSON.parse data
              scriptsPath = Path.resolve "node_modules", "hubot-scripts", "src", "scripts"
              robot.loadHubotScripts scriptsPath, scripts
            catch err
              error "Error parsing JSON data from hubot-scripts.json: #{err}"
              return

    robot.logger.debug "Loading hubot external scripts..."

    robot.logger.debug "Deleting cache for apppulsemobile"
    deleteScriptCache Path.resolve ".","node_modules","hubot-apppulsemobile","src"

    externalScripts = Path.resolve ".", "external-scripts.json"
    Fs.exists externalScripts, (exists) ->
      if exists
        Fs.readFile externalScripts, (err, data) ->
          if data.length > 0
            try
              robot.logger.debug "DATA : #{data}"
              scripts = JSON.parse data

              if scripts instanceof Array
                for pkg in scripts
                  scriptPath = Path.resolve ".","node_modules",pkg,"src"
                  robot.logger.debug "Deleting cache for #{pkg}"
                  robot.logger.debug "Path : #{scripts}"
                  deleteScriptCache scriptPath
            catch err
              error "Error parsing JSON data from external-scripts.json: #{err}"
            robot.loadExternalScripts scripts
            return
    robot.logger.debug "step 5"

    success(msg)