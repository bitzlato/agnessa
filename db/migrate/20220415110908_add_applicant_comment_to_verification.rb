class AddApplicantCommentToVerification < ActiveRecord::Migration[6.1]
  def change
    add_column :verifications, :applicant_comment, :text
  end
end
