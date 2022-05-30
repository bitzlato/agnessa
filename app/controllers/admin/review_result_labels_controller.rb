class Admin::ReviewResultLabelsController < Admin::ApplicationController

  def index
    labels = paginate ReviewResultLabel.all.order('created_at DESC')
    render locals: {labels: labels}
  end

  def edit
    render locals: {label: label}
  end

  def update
    label.update!(label_params)
    redirect_back fallback_location: admin_review_result_labels_path, notice: 'Label was successfully updated.'
  rescue ActiveRecord::RecordInvalid => e
    raise e unless e.record.is_a? Label
    render :edit, locals: {label: label}
  end

  private

  def label
    @label ||= ReviewResultLabel.find(params[:id])
  end

  def label_params
    params.require(:review_result_label).permit(:label_ru, :label, :public_comment)
  end
end
