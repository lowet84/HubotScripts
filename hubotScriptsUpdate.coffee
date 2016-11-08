# Comment!
gitPull = require('git-pull')

module.exports = (robot) ->
  robot.respond /scripts/i, (res) ->
    res.send "Getting scripts from github"
    callback = (err, consoleOutput) ->
	    if (err)
        res.send "Error: " + err
	    else
		    res.send "Success! :)"
    gitPull('/app/scripts',callback)
    res.send "hub reload"
