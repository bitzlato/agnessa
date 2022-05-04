class EmptyReason
  def empty_reason(moderator: nil)
    Verification.confirmed.where(reason: nil).find_each do |verification|
      verification.update reason: 'other'
    end
  end
end
