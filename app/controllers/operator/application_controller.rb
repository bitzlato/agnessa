class Operator::ApplicationController < ApplicationController
  layout 'fluid'

  helper_method :current_account

  private

  def current_account
    RequestStore.store[:current_account]
  end
end