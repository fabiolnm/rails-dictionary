class AppsController < ApplicationController
  before_action :set_app, only: [:show, :edit, :update, :destroy]

  def index
    @apps = App.order :name
  end

  def new
    @app = App.new
  end

  def show
  end

  def edit
  end

  def create
    @app = App.create app_params

    if @app.valid?
      redirect_to @app, notice: 'App was successfully created.'
    else
      render :new
    end
  end

  def update
    if @app.update app_params
      redirect_to @app, notice: 'App was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @app.destroy
    redirect_to apps_url, notice: 'App was successfully destroyed.'
  end

  private

  def set_app
    @app = App.find params[:id]
  end

  def app_params
    params.require(:app).permit :path
  end
end
