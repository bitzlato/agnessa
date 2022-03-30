class RenameInitStatusToPendinf < ActiveRecord::Migration[6.1]
  def change
    Verification.where(status: nil).update_all status: -1
    change_column :verifications, :status, :string, null: false, default: 'pending'
    change_column :verifications, :reason, :string
    Verification.where(status: '-1').update_all status: 'pending'
    Verification.where(status: '0').update_all status: 'refused'
    Verification.where(status: '1').update_all status: 'confirmed'

    Verification.where(reason: '0').update_all reason: 'unban'
    Verification.where(reason: '1').update_all reason: 'trusted_trader'
    Verification.where(reason: '2').update_all reason: 'restore'
    Verification.where(reason: '3').update_all reason: 'other'
  end
end
