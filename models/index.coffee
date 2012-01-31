## Dependencies ##

# Native
path = require 'path'
util = require 'util'

# External
Mongoose = require 'mongoose'
mongooseTypes = require 'mongoose-types'
walk     = require 'walk'

# Enable URL, Email, and Timestamps
mongooseTypes.loadTypes(Mongoose)

# Load the models
walker = walk.walk(__dirname)

walker.on 'file', (root, fileStats, next) ->
  if fileStats.name.match /_model.coffee$/i
    require path.join(__dirname, fileStats.name)
    util.log "Loaded model: #{fileStats.name}"
  next()

walker.on "end", ->
  util.log "Finished loading models."

module.exports = (url) ->
  util.log "Connecting to #{url}"
  Mongoose.connect url, (err) -> throw err if err
