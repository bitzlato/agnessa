class VerificationMailer < ApplicationMailer
  def confirmed(verification_id)
    @verification = Verification.find(verification_id)
    @applicant = @verification.applicant
    @account = @applicant.account
    mail to: @verification.email, from: @account.email_from, subject: 'Вы успешно прошли верификацию'
  end

  def refused(verification_id)
    @verification = Verification.find(verification_id)
    @applicant = @verification.applicant
    @account = @applicant.account
    mail to: @verification.email, from: @account.email_from, subject: 'Вы не прошли верификацию'
  end
end
