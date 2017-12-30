require "cloud_text/version"
require "unicode_utils"
require "stopwords"
require "lingua/stemmer"

module CloudText

  def self.clean_text(input, options = {})
    @input = input
    @options = options

    # Remove punctuation and/or digits
    remove_digits = @options.fetch(:remove_digits, false)
    if remove_digits
      @input = input.gsub(/[^A-Za-z0-9^şŞıİçÇöÖüÜĞğ\s]|_|\d/, ' ')
    else
      @input = input.gsub(/[^A-Za-z0-9^şŞıİçÇöÖüÜĞğ\s]|_/, ' ')
    end
    # Reduce multiple whitespaces into single whitespace
    @input = @input.gsub(/\s+/, ' ')

    # Lowercase all tokens
    @language = @options.fetch(:language, "en")
    @input = UnicodeUtils.downcase(@input, @language.to_sym)

    # Filter stopwords
    @cutsom_stopwords = @options.fetch(:stopwords, [])
    if @language == "tr"
      stopword_filter = Stopwords::Filter.new tr_stopwords
    else
      stopword_filter = Stopwords::Snowball::Filter.new @language
    end

    # Here we intentionally do not downcase custom_stopwords 
    # since we want to filter only capitalized version of a word
    stopword_filter.stopwords << @cutsom_stopwords
    @input = stopword_filter.filter(@input.split)
    
    # Stemming
    stemming_enabled = @options.fetch(:stemming, false)
    if stemming_enabled
      stemmer = Lingua::Stemmer.new(language: @language)
      @input = @input.map do |word|
        stemmer.stem(word)
      end
    end

    # Counting the words, generate array for each element like => [word, frequency]
    @result = @input.each_with_object(Hash.new(0)) { |token, hash| hash[token] += 1 }.sort_by {|k,v| v}.reverse

    puts @result
  end

  private
  def self.tr_stopwords
    ['a','acaba','altı','altmış','ama','ancak','arada','artık','asla','aslında','aslında','ayrıca','az','bana','bazen','bazı','bazıları','belki','ben','benden','beni','benim','beri','beş','bile','bilhassa','bin','bir','biraz','birçoğu','birçok','biri','birisi','birkaç','birşey','biz','bizden','bize','bizi','bizim','böyle','böylece','bu','buna','bunda','bundan','bunlar','bunları','bunların','bunu','bunun','burada','bütün','çoğu','çoğunu','çok','çünkü','da','daha','dahi','dan','de','defa','değil','diğer','diğeri','diğerleri','diye','doksan','dokuz','dolayı','dolayısıyla','dört','e','edecek','eden','ederek','edilecek','ediliyor','edilmesi','ediyor','eğer','elbette','elli','en','etmesi','etti','ettiği','ettiğini','fakat','falan','filan','gene','gereği','gerek','gibi','göre','hala','halde','halen','hangi','hangisi','hani','hatta','hem','henüz','hep','hepsi','her','herhangi','herkes','herkese','herkesi','herkesin','hiç','hiçbir','hiçbiri','i','ı','için','içinde','iki','ile','ilgili','ise','işte','itibaren','itibariyle','kaç','kadar','karşın','kendi','kendilerine','kendine','kendini','kendisi','kendisine','kendisini','kez','ki','kim','kime','kimi','kimin','kimisi','kimse','kırk','madem','mi','mı','milyar','milyon','mu','mü','nasıl','ne','neden','nedenle','nerde','nerede','nereye','neyse','niçin','nin','nın','niye','nun','nün','o','öbür','olan','olarak','oldu','olduğu','olduğunu','olduklarını','olmadı','olmadığı','olmak','olması','olmayan','olmaz','olsa','olsun','olup','olur','olur','olursa','oluyor','on','ön','ona','önce','ondan','onlar','onlara','onlardan','onları','onların','onu','onun','orada','öte','ötürü','otuz','öyle','oysa','pek','rağmen','sana','sanki','sanki','şayet','şekilde','sekiz','seksen','sen','senden','seni','senin','şey','şeyden','şeye','şeyi','şeyler','şimdi','siz','siz','sizden','sizden','size','sizi','sizi','sizin','sizin','sonra','şöyle','şu','şuna','şunları','şunu','ta','tabii','tam','tamam','tamamen','tarafından','trilyon','tüm','tümü','u','ü','üç','un','ün','üzere','var','vardı','ve','veya','ya','yani','yapacak','yapılan','yapılması','yapıyor','yapmak','yaptı','yaptığı','yaptığını','yaptıkları','ye','yedi','yerine','yetmiş','yi','yı','yine','yirmi','yoksa','yu','yüz','zaten','zira']
  end
end
