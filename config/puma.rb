root = "/home/deployer/campo-h5/current"
environment 'production'
#directory '/home/tiny/campo-h5'

workers 0
threads 0, 16

#rackup "#{root}/config.ru"

bind  "unix:///tmp/puma.sock"
pidfile "#{root}/tmp/pids/puma.pid"
state_path "#{root}/tmp/pids/puma.state"
daemonize true

preload_app!
