set :output, "/home/rails/shared/log/schedule.log"

job_type :rbenv_rake, %Q{export PATH=/opt/rbenv/shims:/opt/rbenv/bin:/usr/bin:$PATH; eval "$(rbenv init -)"; \
                         cd :path && RAILS_ENV=production bundle exec rake :task --silent :output }
job_type :rbenv_runner, %Q{export PATH=/opt/rbenv/shims:/opt/rbenv/bin:/usr/bin:$PATH; eval "$(rbenv init -)"; \
                         cd :path && RAILS_ENV=production bundle exec rails runner :task --silent :output }


every 1.hour do
    rbenv_runner "TodoFrequenciesJob.perform_later"
end