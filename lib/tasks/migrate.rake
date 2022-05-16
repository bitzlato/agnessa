namespace :migrate do

  desc 'Refuse empty name, document, last_name'
  task empty_name: :environment do
    member = Member.first
    private_comment = 'Автоматически отклоненно. Пустые имя, фамилия, пасспортные данные.'
    public_comment = 'Фотография плохого качества'
    Verification.confirmed.where("document_number = '' OR last_name = '' OR name = ''").find_each do |verification|
      verification.reason = 'other' if verification.reason.nil?

      verification.refuse! member: member, public_comment: public_comment, private_comment: private_comment, labels: ['BAD_PHOTO'], send_email: false
    end
  end

  desc 'Empty reason to other'
  task empty_reason: :environment do
    Verification.confirmed.where(reason: nil).update_all(reason: 'other')
  end

end
