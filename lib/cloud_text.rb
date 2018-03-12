require "cloud_text/version"
require "unicode_utils"
require "stopwords"
require "lingua/stemmer"

module CloudText

  def self.clean_text(input, options = {})
    @input = input
    @options = options

    # Get feature on/off switches
    remove_digits = @options.fetch(:remove_digits, false)
    stemming_enabled = @options.fetch(:stemming, false)

    # Get variables
    @language = @options.fetch(:language, "en")
    @custom_stopwords = @options.fetch(:stopwords, [])

    @input = process_text(@input, stemming_enabled, remove_digits, @language, @custom_stopwords)
    count_words(@input)
  end

  private

  def self.process_text(input, stemming_enabled, remove_digits, language, custom_stopwords)
    input = remove_punctuation(input, remove_digits)
    input = reduce_whitespaces(input)
    input = lowercase_words(input, language)
    input = filter_stopwords(input, language, custom_stopwords) # Get custom_stopwords from user and filter words
    input = stemming(input, language) if stemming_enabled
  end

  def self.remove_punctuation(input, remove_digits)
    regex = remove_digits ? /[^A-Za-z0-9^şŞıİçÇöÖüÜĞğ\s]|_|\d/ : /[^A-Za-z0-9^şŞıİçÇöÖüÜĞğ\s]|_/
    input.gsub(regex, ' ')
  end

  # Reduce multiple whitespaces into single whitespace
  def self.reduce_whitespaces(input)
    input.gsub(/\s+/, ' ')
  end

  def self.lowercase_words(input, language)
    UnicodeUtils.downcase(input, language.to_sym)
  end

  # Remove stopwords for given language and also given custom stopwords
  def self.filter_stopwords(input, language, custom_stopwords = nil)
    stopword_filter = language == "tr" ? Stopwords::Filter.new(tr_stopwords) : stopword_filter = Stopwords::Snowball::Filter.new(language)

    # Here we intentionally do not downcase custom_stopwords
    # since we want to filter only capitalized version of a word
    stopword_filter.stopwords << custom_stopwords if custom_stopwords
    stopword_filter.filter(input.split)
  end

  def self.stemming(input, language)
    stemmer = Lingua::Stemmer.new(language: language)
    input.map do |word|
      stemmer.stem(word)
    end
  end

  # Counting the words, generate array for each element like => [word, frequency]
  def self.count_words(input)
    input.each_with_object(Hash.new(0)) { |token, hash| hash[token] += 1 }.sort_by(&:last).reverse
  end

  def self.tr_stopwords
    File.readlines('tr_stopwords_dict').each(&:chomp!)
  end
end
