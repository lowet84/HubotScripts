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
        reload.reloadAllScripts res, reload.success, (err) ->
          res.send err
    gitPull('/app/scripts',callback)
