class Admin::OperatorStatisticsController < Admin::ApplicationController
  def show
    period = params[:period].to_i
    members = current_account.members
                             .joins(:verifications)
                             .select("members.id, count(verifications.id) as verifications_amount, user_id, min(verifications.updated_at - verifications.created_at) as min_period,
                                      max(verifications.updated_at - verifications.created_at) as max_period,
                                      avg(verifications.updated_at - verifications.created_at) as avg_period")
                             .group('members.id')
    members = members.where("verifications.created_at > ?", period.seconds.ago.beginning_of_day) if period > 0

    render locals: {members: members}
  end
end