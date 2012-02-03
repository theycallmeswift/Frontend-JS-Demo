## Dependencies ##

# Native
{EventEmitter} = require 'events'
path = require 'path'
qs = require 'querystring'
util = require 'util'

# External
express = require 'express'
require 'express-namespace'

# Initailize the Server
app = module.exports = express.createServer()

# Event emitter for the app
app.events = new EventEmitter()

## Configuration ##
app.paths = {
  public: path.join(__dirname, "public"),
}

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
      return res.json({ error: "Internal server error." })
    else if typeof e == "object"
      res.statusCode = e.statusCode || 500
      return res.json({ error: e.message })

## Routing ##

# API
app.namespace '/api/v1', () ->

  # Users
  app.namespace '/users', () ->
    app.get '/', (req, res) ->
      res.json([
        { email: "theycallmeswift@gmail.com", nickname: "TheyCallMeSwift", loggedIn: true },
        { email: "ian@meetjennings.com", nickname: "Sw1tch", loggedIn: true },
        { email: "abestanway@gmail.com", nickname: "Aba_Sababa", loggedIn: false}
      ])


## Errors ##
app.all('/404', (req, res, next) ->
  next({statusCode: 404, message: "Object not found."})
)

app.all('/500', (req, res, next) ->
  next({statusCode: 500, message: "Internal server error."})
)

app.all('*', (req, res, next) ->
  next({statusCode: 404, message: "Object not found."})
)

## Start the Server ##
port = process.env.port || 3000
app.listen(port)

app.on('listening', () ->
  util.log("listening on 0.0.0.0:#{port}")
)
