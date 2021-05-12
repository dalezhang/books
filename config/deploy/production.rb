puts '------> Use production '
puts '------> Use branch master'

set :port, '22'
set :user, 'app'
set :branch, 'master'
set :domain, '139.196.229.63'
set :rails_env, 'development'
set :keep_releases, 1
set :deploy_to, '/home/app/rails/books'
