class TranslationsController < ApplicationController
  before_action :set_app

  def edit
    @dictionary = @app.dictionary_for params[:base]
    @languages = @dictionary.keys
  end

  def update
  end

  private

  def set_app
    @app = App.find params[:app_id]
  end
end
