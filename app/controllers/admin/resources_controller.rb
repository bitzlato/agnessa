# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class Admin::ResourcesController < Admin::ApplicationController
  include PaginationSupport
  include RansackSupport
  include ShowAction

  layout 'fluid'

  helper_method :model_class

  private

  def model_class
    self.class.name.remove('Controller').singularize.gsub('Admin::','').constantize
  end
end
