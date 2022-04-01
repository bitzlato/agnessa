class User::ApplicationController < ApplicationController
  include UserAuthSupport

  layout 'user'
end