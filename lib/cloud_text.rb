require "cloud_text/version"

module CloudText

  #LANGUAGE = [:en, :tr, :fr]

  def initialize(input, options)
    @input = input
    @options = options
  end

  def clean_text
    #language = @options.fetch(:language, "en")
    exclude_digits = @options.fetch(:exclude_digits, false)
    if exclude_digits
      remove_digits
    else
      remove_punctuation
    end
    puts @input
  end

  private

  def remove_punctuation
    @input = input.gsub(/\W|_/, ‘’)
  end

  def remove_digits
    @input = input.gsub(/\W|_|\d/, ‘’)
  end
end
