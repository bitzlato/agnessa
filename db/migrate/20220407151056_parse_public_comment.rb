class ParsePublicComment < ActiveRecord::Migration[6.1]
  def change
    Verification.all.find_each do |v|
      comment = v.external_json['comment']
      next if comment.blank?

      v.update_columns public_comment: comment
    end
  end
end
