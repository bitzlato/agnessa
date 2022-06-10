class Admin::VerificationDocumentsController < Admin::ApplicationController
  def show
    document = VerificationDocument.find(params[:id])
    threshold = form_params[:threshold].presence || VerificationDocument::NEIGHBOR_THRESHOLD
    data = document.similar_documents(threshold).group_by{|x| x.verification}
    render locals: {document: document, data: data, threshold: threshold}
  end

  private

  def form_params
    params.fetch(:form, {}).permit(:threshold)
  end
end
