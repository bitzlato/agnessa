class ErrorsController < ApplicationController
  layout 'simple'

  def not_found
    render status: 404
  end
end
