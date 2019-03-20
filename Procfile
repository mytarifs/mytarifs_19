web: bundle exec unicorn -p 30000 -c ./config/unicorn.rb
worker:  bundle exec sidekiq -e production -C config/sidekiq.yml
mailer:  ruby bin/mailman_server.rb

