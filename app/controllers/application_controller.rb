class ApplicationController < ActionController::Base
  include Flashes
  include RescueErrors
end