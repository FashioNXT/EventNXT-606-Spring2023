class WelcomeController < ApplicationController
  skip_before_action :validate_login
  def index
    if params.has_key? :register
      @register = true
    end
    render 'index'
  end
end
