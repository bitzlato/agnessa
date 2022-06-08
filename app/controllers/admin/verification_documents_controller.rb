class Admin::VerificationDocumentsController < Admin::ApplicationController
  def show
    document = VerificationDocument.find(params[:id])
    render locals: {document: document}
  end
end
