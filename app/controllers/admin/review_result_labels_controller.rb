class Admin::ReviewResultLabelsController < Admin::ApplicationController

  def index
    labels = paginate ReviewResultLabel.all.order('archived_at DESC').order('created_at DESC')
    render locals: {labels: labels}
  end

  def edit
    render locals: {label: label}
  end

  def new
    label = ReviewResultLabel.new
    render locals: { label: label }
  end


  def create
    country = ReviewResultLabel.create! label_params
    redirect_back fallback_location: admin_review_result_labels_path, notice: 'Label was successfully created.'
  rescue ActiveRecord::RecordInvalid => e
    raise e unless e.record.is_a? ReviewResultLabel
    render :new, locals: { label: e.record }
  end

  def update
    label.update!(label_params)
    redirect_back fallback_location: admin_review_result_labels_path, notice: 'Label was successfully updated.'
  rescue ActiveRecord::RecordInvalid => e
    raise e unless e.record.is_a? Label
    render :edit, locals: { label: label }
  end

  def restore
    label.restore!
    redirect_back fallback_location: admin_review_result_labels_path, notice: 'Label was successfully restored.'
  end

  def archive
    label.archive!
    redirect_back fallback_location: admin_review_result_labels_path, notice: 'Label was successfully archived.'
  end

  private

  def label
    @label ||= ReviewResultLabel.find(params[:id])
  end

  def label_params
    params.require(:review_result_label).permit(:label_ru, :label, :public_comment)
  end
end
