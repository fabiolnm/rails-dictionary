class TranslationsController < ApplicationController
  before_action :set_app

  def edit
    @dictionary = @app.dictionary_for params[:base]
    @languages = @dictionary.keys
  end

  def update
    @app.update_translation base: params[:base],
      entry: params[:entry], value: params[:value]
  end

  private

  def set_app
    @app = App.find params[:app_id]
  end
end
