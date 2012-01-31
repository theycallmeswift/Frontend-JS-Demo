# Defaults
env = module.exports = {
  app_name: 'frontend_js_demo',
  node_env: process.env.NODE_ENV || 'development',
  port: parseInt(process.env.PORT) || 3000,
}

# Mongo URL
env.mongo_url = process.env.MONGOHQ_URL || "mongodb://localhost/#{env.app_name}_development"

# Env flags
env.development = env.node_env == 'development'
env.production = !env.development
