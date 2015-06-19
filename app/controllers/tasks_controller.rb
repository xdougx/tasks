class TasksController < ApplicationController
  def home
  end

  def create
    respond_to do |format| 
      format.json { render status: :ok, json: params.as_json }
      format.html { redirect_to root_path }
    end
  end

end
