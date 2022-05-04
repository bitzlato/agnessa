class RefuseEmptyVerification
  def refuse_empty(moderator: nil)
    member = Member.find(3) if member.nil?

    Verification.confirmed.where("document_number = '' OR last_name = '' OR name = ''").find_each do |verification|
      verification.reason = 'other' if verification.reason.nil?

      comment = 'Автоматически отклоненно. Пустые имя, фамилия, пасспортные данные.'
      verification.refuse! member: member, public_comment: comment, private_comment: comment, labels: ['BAD_PHOTO'], send_email: false
    end
  end
end
