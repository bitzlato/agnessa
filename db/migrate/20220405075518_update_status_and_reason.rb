class UpdateStatusAndReason < ActiveRecord::Migration[6.1]
  def change
    Verification.where("raw_changebot->>'status' = ?", 'refused').update_all status: 'refused'
    Verification.where("raw_changebot->>'status' = ?", 'confirmed').update_all status: 'confirmed'
    Verification.where("raw_changebot->>'status' = ?", 'new').update_all status: 'pending'

    Verification.where("raw_changebot->>'cause' = ?", 'unlocking').update_all reason: 'unban'
    Verification.where("raw_changebot->>'cause' = ?", 'restoring').update_all reason: 'restore'
    Verification.where("raw_changebot->>'cause' = ?", 'other').update_all reason: 'other'
    Verification.where("raw_changebot->>'cause' = ?", 'trusted_trader').update_all reason: 'trusted_trader'
  end
end
