class Admin::ReviewResultLabelsController < Admin::ApplicationController

  def index
    labels = paginate ReviewResultLabel.all.order('created_at DESC')
    render locals: {labels: labels}
  end

  def edit
  end

  def update
  end
end
