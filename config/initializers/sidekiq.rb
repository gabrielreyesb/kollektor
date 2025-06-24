require 'sidekiq'
require 'sidekiq-cron'

Sidekiq.configure_server do |config|
  schedule = {
    'snooze_reminder_job' => {
      'class' => 'SnoozeReminderJob',
      'cron' => '*/1 * * * *' # every minute
    }
  }
  Sidekiq::Cron::Job.load_from_hash(schedule)
end 