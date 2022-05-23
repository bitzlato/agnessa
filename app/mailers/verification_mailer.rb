class VerificationMailer < ApplicationMailer
  def confirmed(verification_id)
    return if ENV.true?('AGNESSA_BLOCK_VERIFICATION_EMAILS')

    @verification = Verification.find(verification_id)
    @applicant = @verification.applicant
    @account = @applicant.account
    mail to: @verification.email, from: @account.email_from, subject: "##{@verification.id} Вы успешно прошли верификацию"
  end

  def refused(verification_id)
    return if ENV.true?('AGNESSA_BLOCK_VERIFICATION_EMAILS')

    @verification = Verification.find(verification_id)
    @applicant = @verification.applicant
    @account = @applicant.account
    mail to: @verification.email, from: @account.email_from, subject: "##{@verification.id} Вы не прошли верификацию"
  end
end
