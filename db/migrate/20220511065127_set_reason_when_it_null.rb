class SetReasonWhenItNull < ActiveRecord::Migration[6.1]
  def change
    return unless Rails.env.production?
    Verification.confirmed.where(reason: nil).find_each do |verification|
      verification.update_column('reason', 'other') if verification.reason.nil?
    end
  end
end
