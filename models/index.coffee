## Dependencies ##

# Native
util = require 'util'

# External
Mongoose = require 'mongoose'

# Internal
# require "./#{model}" for model in ['commit', 'contributor', 'repository']

module.exports = (url) ->
  util.log "Connecting to #{url}"
  Mongoose.connect url, (err) -> throw err if err
