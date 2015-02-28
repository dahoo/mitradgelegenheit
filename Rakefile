# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

namespace :ci do
  desc 'Setup service for CI'
  task setup: %w(db:drop db:create db:schema:load) do
  end

  desc 'Run specs for CI'
  task spec: %w(^spec) do
  end
end
