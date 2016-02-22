class ResourceController < ApplicationController
  require 'json'
  skip_before_action :verify_authenticity_token

  def index
    @resources = Resource.all
    render json: {resources: @resources}
  end

  def create
    @new_resource = Resource.new(params.require(:resource).permit(:title, :description, :file) )
    if params[:user]
      @user = User.find(params[:user])
    end

    begin
      @new_resource.save
      @user.resources << @new_resource
    rescue ActiveRecord::RecordInvalid => e
      render json: {error: e.record.errors.details}#, status: 400
    end
    render nothing: true, status: 204
  end

  def show
     if Resource.exists? params[:id]
        @resource = Resource.find(params[:id])
        render json: { resource: @resource, children: @resource.children }
     else
        render json: {error: "resource not found"}
     end
  end
end
