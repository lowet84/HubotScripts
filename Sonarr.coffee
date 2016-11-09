# Description:
#   Hubot utilities for sonarr
#
# Commands:
#   sonarr missing - Displays missing episodes
#
# Author:
#   lowet84

module.exports = (robot) ->

  robot.respond /sonarr setapi (.*)/i, (msg) ->
    apikey = msg.match[1]
    msg.send "Setting apikey: " + apikey
