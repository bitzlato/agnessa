class Admin::DocumentTypesController < Admin::ApplicationController
  before_action :authorize_admin

  def index
    document_types = paginate current_account.document_types.order('archived_at desc')
    render locals: { document_types: document_types }
  end

  def restore
    document_type.restore!
    redirect_back fallback_location: admin_document_types_path, notice: 'Document Type was successfully restored.'
  end

  def archive
    document_type.archive!
    redirect_back fallback_location: admin_document_types_path, notice: 'Document Type was successfully archived.'
  end

  private

  def document_type
    @document_type ||= current_account.document_types.find(params[:id])
  end
end
