class App < ApplicationRecord
  before_validation :init_name
  validates :path, presence: true

  def translation_files
    @base_files ||= Dir.entries("#{path}/config/locales")
      .select { |entry| entry =~ /^[A-Za-z0-9]+\.yml$/ }
      .map { |base| [base, languages_for(base)] }.to_h
  end

  def languages_for(base)
    Dir.entries("#{path}/config/locales")
      .map { |entry| entry.match /^#{base.gsub('.yml', '')}\.(.+)\.yml$/ }
      .compact.map {|captures| captures[1] }
  end

  private

  def init_name
    cfg = "#{path}/config/application.rb"
    res = `cat #{cfg} | grep "Rails::Application" -B 1`
    self.name = res.to_s.lines[0].match(/module (.*)/).captures[0]
  end
end
