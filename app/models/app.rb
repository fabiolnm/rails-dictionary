class App < ApplicationRecord
  before_validation :init_name
  validates :path, presence: true

  def translation_files
    @base_files ||= Dir.entries("#{path}/config/locales")
      .select { |entry| entry =~ /^[A-Za-z0-9_]+\.yml$/ }
      .map { |base| [base, languages_for(base)] }.to_h
  end

  def languages_for(base)
    Dir.entries("#{path}/config/locales")
      .map { |entry| entry.match /^#{base.gsub('.yml', '')}\.(.+)\.yml$/ }
      .compact.map {|captures| captures[1] }
  end

  def dictionary_for(base)
    load_yaml(base).tap do |dictionary|
      languages_for(base).each do |language|
        filename = "#{base.gsub('.yml', '')}.#{language}.yml"
        lang_dict = load_yaml filename

        detected_language = lang_dict.keys.first
        if detected_language != language
          raise "Wrong root at #{filename}: #{language} != #{detected_language}"
        end

        complete_keys dictionary.values[0], lang_dict.values[0], language
        dictionary.merge! lang_dict
      end
    end
  end

  def update_translation(base:, entry:, value:)
    dict = dictionary_for base

    keys = entry.split '.'
    lang = keys.shift
    last = keys.pop

    dict[lang] ||= {}
    values = dict[lang]

    keys.each do |k|
      values[k] ||= {}
      raise "#{keys} is not a hash in #{lang}" unless values[k].is_a? Hash
      values = values[k]
    end
    values[last] = value

    write base, dict, lang
  end

  private

  def init_name
    cfg = "#{path}/config/application.rb"
    res = `cat #{cfg} | grep "Rails::Application" -B 1`
    self.name = res.to_s.lines[0].match(/module (.*)/).captures[0]
  end

  def load_yaml(base)
    YAML.load File.open "#{path}/config/locales/#{base}"
  end

  def complete_keys(dictionary, lang_dict, lang)
    return if lang_dict.blank?

    lang_dict.each do |k,v|
      key = k.to_s

      if v.is_a? Hash
        dictionary[key] ||= {}
        unless dictionary[key].is_a? Hash
          raise "#{lang} #{k}=#{v} is not a hash in base locale"
        end
        complete_keys dictionary[key], v, lang
      else
        dictionary[key] ||= nil
      end
    end
  end

  def write(base, dict, lang)
    default = dict.keys.first
    lang_dict =
      lang == default ? dict[default] :
      normalize(dict[default], dict[lang])

    filename = lang_filename base, default, lang
    File.open "#{path}/config/locales/#{filename}", 'w' do |f|
      f.write({ lang => lang_dict }.to_yaml[4..-1])
    end
  end

  def normalize(base_dict, lang_dict)
    {}.tap do |res|
      base_dict.keys.each do |k, v|
        next unless lang_dict.has_key? k
        if v.is_a? Hash
          lang_dict[k] ||= {}
          unless lang_dict[k].is_a? Hash
            raise "#{k}=#{v} is not a hash in lang locale"
          end
          res[k] = normalize v, lang_dict[k]
        else
          res[k] = lang_dict[k]
        end
      end
    end
  end

  def lang_filename(base, default, lang)
    base.gsub '.yml', ['', (lang if lang != default), 'yml'].compact.join('.')
  end
end
