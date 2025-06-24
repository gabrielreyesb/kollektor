class SnoozeReminderJob < ApplicationJob
  queue_as :default

  def perform
    snooze_minutes = Rails.configuration.snooze_reminder_minutes
    due_time = snooze_minutes.minutes.ago
    Series.where.not(snoozed_at: nil).where('snoozed_at <= ?', due_time).find_each do |series|
      Notification.create!(
        user: series.user,
        series: series,
        message: "It's time to check if a new season of '#{series.name}' is available!",
        read: false
      )
      # Optionally, clear snoozed_at or mark as reminded
    end
  end
end 