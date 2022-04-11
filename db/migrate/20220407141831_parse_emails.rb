class ParseEmails < ActiveRecord::Migration[6.1]
  def change
    Verification.all.find_each do |v|
      emails = v.external_json['emails']
      emails = Array(emails).map(&:downcase).compact.uniq
      next if emails.blank?

      v.update_columns email: emails.last
      v.applicant.update_columns emails: emails
    end
  end
end
