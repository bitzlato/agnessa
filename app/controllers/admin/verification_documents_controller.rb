class Admin::VerificationDocumentsController < Admin::ApplicationController
  def show
    document = VerificationDocument.find(params[:id])
    threshold = form_params[:threshold].presence || current_account.document_similarity_threshold
    data = document.similar_documents(threshold.to_i).group_by{|x| x.verification}
    render locals: {document: document, data: data, threshold: threshold}
  end

  private

  def form_params
    params.fetch(:form, {}).permit(:threshold)
  end
end
