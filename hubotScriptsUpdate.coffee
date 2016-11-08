# Comment!
gitPull = require('git-pull')

module.exports = (robot) ->
  robot.respond /scripts/i, (res) ->
    res.send "Getting scripts from github"
    callback = (err, consoleOutput) ->
	    if (err)
        res.send "Error: " + err
	    else
		    res.send "Success!1 :)"
    gitPull('/app/scripts',callback)
    robot.emit 'bot reload'
