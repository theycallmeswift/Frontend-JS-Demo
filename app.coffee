## Dependencies ##

# Native
{EventEmitter} = require 'events'
path = require 'path'
qs = require 'querystring'
util = require 'util'

# External
express = require 'express'
require 'express-namespace'
_ = require 'underscore'

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

## Persistance Layer ##
users = []
messages = []

## Helpers ##
validEmail = (email) ->
  re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
  return re.test(email)

## Routing ##

# API
app.namespace '/api/v1', () ->

  # Messages
  app.namespace '/messages', () ->

    # Index
    app.get '/', (req, res) ->
      res.json(messages)

    # Create
    app.post '/', (req, res, next) ->
      if !req.body.userId and !users[req.body.userId]
        return next({ statusCode: 400, message: "Invalid user id." })

      unless req.body.message
        return next({ statusCode: 400, message: "Invalid message body." })

      message = req.body

      # Set the time
      date = new Date()
      message.time = "" + date.getHours() + ":" + date.getMinutes();

      # Set the id
      message.id = messages.length

      messages.push(message)

      res.statusCode = 201
      res.json(message)

  # Users
  app.namespace '/users', () ->

    # Index
    app.get '/', (req, res) ->
      res.json(users)

    # Create
    app.post '/', (req, res, next) ->
      unless req.body.email and validEmail(req.body.email)
        return next({ statusCode: 400, message: "Invalid email address." })

      unless req.body.nickname
        return next({ statusCode: 400, message: "Invalid nickname." })

      user = _.find users, (user) -> user.email.toLowerCase() == req.body.email.toLowerCase()

      unless user
        user = req.body
        user.id = users.length
        users.push(user)

      user.nickname = req.body.nickname
      user.loggedIn = true

      res.statusCode = 201
      res.json(user)

    # Edit
    app.put '/:id', (req, res, next) ->
      console.log "updating user"
      user = users[req.params.id]
      return next({ statusCode: 404, message: "Not found." }) unless user

      user.email = req.body.email if req.body.email
      user.nickname = req.body.nickname if req.body.nickname
      user.loggedIn = req.body.loggedIn || false

      res.json(user)

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
