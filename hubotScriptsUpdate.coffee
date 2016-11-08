gitPull = require('git-pull')

module.exports = (robot) ->
  robot.respond /scripts/i, (res) ->
    res.send "Getting scripts from github"
