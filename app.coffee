## Dependencies ##

# Native
{EventEmitter} = require 'events'
fs = require 'fs'
path = require 'path'
qs = require 'querystring'
util = require 'util'

# External
ejs = require 'ejs'
express = require 'express'

# Internal
env = require('./config/env')

## Initialization ##

# Initailize the Server
app = module.exports = express.createServer()

# Paths
app.paths = {
  controllers: path.join(__dirname, "controllers"),
  lib: path.join(__dirname, "lib"),
  models: path.join(__dirname, "models"),
  public: path.join(__dirname, "public"),
  views: path.join(__dirname, "views")
}

# Event emitter for the app
app.events = new EventEmitter()

# Database & Models
app.db = require(app.paths.models)(env.mongo_url)

## Configuration ##

# Development
app.configure 'development', () ->
  app.use(express.static(app.paths.public))
  app.use(express.profiler())

# Production
app.configure 'production', () ->
  app.use(express.static(app.paths.public, { maxAge: 1000 * 5 * 60 }))

# General
app.configure () ->
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(express.logger())
  app.use(app.router)

  # Error Handling
  app.use (e, req, res, next) ->
    if typeof e == "number"
      res.statusCode = e
      return res.render("errors/#{e}", { layout: 'error' })

    e = Error(e) if typeof e == "string"
    util.debug(e.stack)

    res.statusCode = 500
    res.render("errors/500", { layout: 'error', error: e })

  # Views
  app.register('.html', ejs)
  app.set('views', app.paths.views)
  app.set('view engine', 'html')

## Error Views
app.all('/404', (req, res, next) ->
  next(404)
)

app.all('/500', (req, res, next) ->
  next(500)
)

app.all('*', (req, res, next) ->
  next(404)
)

## Start the Server
app.listen(env.port)

app.on('listening', () ->
  util.log("listening on 0.0.0.0:#{env.port}")
)
