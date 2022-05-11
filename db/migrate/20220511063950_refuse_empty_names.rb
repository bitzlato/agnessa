class RefuseEmptyNames < ActiveRecord::Migration[6.1]
  def change
    member = Member.find(3) if member.nil?
    private_comment = 'Автоматически отклоненно. Пустые имя, фамилия, пасспортные данные.'
    public_comment = 'Фотография плохого качества'

    Verification.confirmed.where("document_number = '' OR last_name = '' OR name = ''").find_each do |verification|
      verification.reason = 'other' if verification.reason.nil?

      verification.refuse! member: member, public_comment: public_comment, private_comment: private_comment, labels: ['BAD_PHOTO'], send_email: false
    end
  end
end