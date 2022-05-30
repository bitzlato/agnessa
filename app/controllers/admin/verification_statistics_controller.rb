class Admin::VerificationStatisticsController < Admin::ApplicationController
  def show
    form = VerificationStatisticsForm.new(form_params)

    verifications = current_account.verifications
                                   .finished
                                   .select("date_trunc('#{form.date_group}', verifications.updated_at) as date, count(verifications.id) as verifications_amount,
                                            min(verifications.updated_at - verifications.created_at) as min_period,
                                            max(verifications.updated_at - verifications.created_at) as max_period,
                                            avg(verifications.updated_at - verifications.created_at) as avg_period")
    verifications = verifications.joins(:moderator) if form.subject_group == 'moderator_id'
    verifications = verifications.select(form.subject_group).group(form.subject_group).group(:date)
    verifications = verifications.where("verifications.created_at > ?", form.ago.seconds.ago.beginning_of_day) if form.ago.to_i > 0

    dates = verifications.map(&:date).uniq.sort.reverse
    subjects = verifications.map{|v| v.send(form.subject_group)}.uniq.sort_by
    dates_array = dates.inject({}){|res, el| res[el] = nil; res}
    result = {}
    verifications.each do |v|
      result[v.send(form.subject_group)] = dates_array.dup unless result[v.send(form.subject_group)].present?
      result[v.send(form.subject_group)][v.date] = {
        verifications_amount: v.verifications_amount,
        min_period: v.min_period,
        max_period: v.max_period,
        avg_period: v.avg_period
      }
    end

    render locals: {result: result, dates: dates, subjects: subjects, form: form}
  end

  private

  def form_params
    params.fetch(:f, {}).permit(:subject_group, :ago, :date_group)
  end
end