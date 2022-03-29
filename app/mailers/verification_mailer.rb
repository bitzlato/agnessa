class VerificationMailer < ApplicationMailer
  def confirmed(verification_id)
    @verification = Verification.find(verification_id)
    mail to: @verification.email, subject: 'Вы успешно прошли верификацию'
  end

  def refused(verification_id)
    @verification = Verification.find(verification_id)
    mail to: @verification.email, subject: 'Вы не прошли верификацию'
  end
end
