Mongoose = require 'mongoose'
MongooseTypes = require 'mongoose-types'

Email = Mongoose.SchemaTypes.Email
ObjectId = Mongoose.Schema.ObjectId
useTimestamps = MongooseTypes.useTimestamps

User = module.exports = new Mongoose.Schema({
  email: Email
})

# Use Timestamps
User.plugin(useTimestamps)

Mongoose.model('User', User)
