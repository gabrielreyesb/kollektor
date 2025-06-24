class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_due_snooze_reminders
  # before_action :set_sidebar_data, unless: :devise_controller?

  private

  def set_sidebar_data
    # ... existing code ...
  end

  def set_due_snooze_reminders
    if user_signed_in?
      snooze_minutes = Rails.configuration.snooze_reminder_minutes
      due_time = snooze_minutes.minutes.ago
      @due_snooze_reminders = current_user.series.where.not(snoozed_at: nil).where('snoozed_at <= ?', due_time)
    else
      @due_snooze_reminders = Series.none
    end
  end
end
