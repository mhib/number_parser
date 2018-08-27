require "./providers/english_provider"

module NumberParser
  VERSION = "0.1.0"

  @@providers = {"en" => EnglishProvider.new}

  def self.parse(string, lang = "en", ignore = [] of String, bias = :none)
    string = string.dup
    ignore = ignore.map(&.downcase).to_set
    provider = @@providers[lang]
    if provider == nil
      raise "Language #{lang} not found. Language options include #{@@providers.keys}"
    end
    provider.parse(string, ignore: ignore, bias: bias)
  end

  def self.providers
    @@providers
  end
end
