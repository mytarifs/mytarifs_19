class ErrorsController < ApplicationController
  def error404
    render status: :not_found
  end

  def error422
    render status: 422
  end

  def error500
#    redirect_to :action => error404
    render status: 404
  end
end