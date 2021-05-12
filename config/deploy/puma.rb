require 'mina/bundler'
require 'mina/rails'

namespace :puma do
  set :web_server, :puma
  set :puma_role,       -> { fetch(:user) }
  set :puma_env,        -> { fetch(:rails_env, 'production') }
  set :puma_config,     -> { "#{fetch(:shared_path)}/config/puma.rb" }
  set :puma_socket,     -> { "#{fetch(:shared_path)}/tmp/sockets/books.sock" }
  set :puma_state,      -> { "#{fetch(:shared_path)}/tmp/sockets/puma.state" }
  set :puma_pid,        -> { "#{fetch(:shared_path)}/tmp/pids/puma.pid" }
  set :puma_cmd,        -> { "#{fetch(:bundle_prefix)} puma" }
  set :pumactl_cmd,     -> { "#{fetch(:bundle_prefix)} pumactl" }
  set :pumactl_socket,  -> { "#{fetch(:shared_path)}/tmp/sockets/pumactl.sock" }

  desc "Start Puma"
  task :start => :remote_environment do
    command %{
      if [ -e '#{fetch(:pumactl_socket)}' ]; then
        echo '---> Puma is already running!'
      else
        if [ -e '#{fetch(:puma_config)}' ]; then
          cd #{fetch(:current_path)} && #{fetch(:puma_cmd)} -q -d -e #{fetch(:puma_env)} -C #{fetch(:puma_config)}
        else
          echo '---> No puma config file'
        fi
      fi
    }
  end

  desc "Stop Puma"
  task :stop => :remote_environment do
    in_path "#{fetch(:current_path)}" do
      comment "---> Stopping puma..."
      pumactl_command 'stop'
      command %{ rm -rf "#{fetch(:pumactl_socket)}" }
    end
  end

  desc "Restart Puma"
  task :restart => :remote_environment do
    in_path "#{fetch(:current_path)}" do
      comment "---> Restarting puma..."
      pumactl_command 'restart'
    end
  end

  def pumactl_command(command)
    cmd =  %{
      if [ -e "#{fetch(:pumactl_socket)}" ]; then
        if [ -e "#{fetch(:puma_config)}" ]; then
          cd #{fetch(:current_path)} && #{fetch(:pumactl_cmd)} -F #{fetch(:puma_config)} #{command}
        else
          cd #{fetch(:current_path)} && #{fetch(:pumactl_cmd)} -S #{fetch(:puma_state)} -C "unix://#{fetch(:pumactl_socket)}" --pidfile #{fetch(:puma_pid)} #{command}
        fi
      else
        echo 'Puma is not running!';
      fi
    }
    command cmd
  end
end
