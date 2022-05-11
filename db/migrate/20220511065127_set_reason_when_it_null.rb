class SetReasonWhenItNull < ActiveRecord::Migration[6.1]
  def change
    Verification.confirmed.where(reason: nil).find_each do |verification|
      verification.update reason: 'other' if verification.reason.nil?
    end
  end
end
