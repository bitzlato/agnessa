class Admin::VerificationStatisticsController < Admin::ApplicationController
  def show
    form = VerificationStatisticsForm.new(form_params)
    result = current_account.verifications
                             .finished
                             .select("count(verifications.id) as verifications_amount, min(verifications.updated_at - verifications.created_at) as min_period,
                                      max(verifications.updated_at - verifications.created_at) as max_period,
                                      avg(verifications.updated_at - verifications.created_at) as avg_period")
    case form.group
    when 'operator'
      result = result.joins(:moderator).select(:moderator_id).group(:moderator_id)
    when 'reason'
      result = result.select(:reason).group(:reason)
    end

    result = result.where("verifications.created_at > ?", form.period.seconds.ago.beginning_of_day) if form.period.to_i > 0

    render locals: {result: result, form: form}
  end

  private

  def form_params
    params.permit(:form, [:period, :group])
  end
end