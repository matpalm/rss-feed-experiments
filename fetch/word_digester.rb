require 'yaml'

class WordDigester
  
  attr_accessor :url_to_words
  
  def initialize
    @url_to_words = {}
  end
  
  # collecting /building
  
  def collect_words_from_file file
    IO.read(file).each { |line| collect_words line }    
  end
  
  def collect_words record
    record =~ /(.*?)\|(.*?)\|(.*)/
    url = $1
    desc = $3
    @url_to_words[url] = {} if !@url_to_words.has_key? url
    extract_words @url_to_words[url], desc
  end
    
  # display for java input 
  
  def print_url_word_freq    
    @url_to_words.each { |url,freq|
      print url, "|";
      freq.each { |word,count|
        print word.to_s, ',', count, '}'
      }
      print "\n"
   }    
  end
  
  # word stats
  
  def number_words_per_url
    url_word_count = {}
    @url_to_words.each do |url,freq|
      count = 0
      freq.each { |k,v| count += v }
      url_word_count[url] = count
    end
    url_word_count
  end

  def all_word_freq
    all_word = {}
    @url_to_words.each { |url,freq| combine_hash all_word, freq }
    all_word
  end
  
  def words_for_url
    @url_to_words[url]
  end

  # hash modification methods
  
  def remove_single_character_words
    @url_to_words.each { |url,freq|
      freq.reject! { |word,count| word.size<2 }
    }
  end
  
  def convert_words_to_sym
    new_url_to_words = {}
    @url_to_words.each do |url,freq|
      new_freq = {}
      freq.each { |k,v| new_freq[k.to_sym] = v }
      new_url_to_words[url] = new_freq
    end
    @url_to_words = new_url_to_words
  end
  
  def remove_urls_with_less_words_than count
    url_to_word_count = number_words_per_url
    @url_to_words = @url_to_words.select { |url,freq| url_to_word_count[url] > count }
  end
    
  def words_that_only_appear_once_globally
    all_word_freq.
      select {|k,v| v==1}. # all words that appear only once in global set
      collect{|pair| pair.first} # just want word, not freq
  end
  
  def remove_entries_for_words removal_words
    @url_to_words.each { |url,freq|
      freq.reject! {|word,count| removal_words.include? word}      
    }    
  end
  
  # load / save
  
  def save filename
    file = File.open(filename,"w")
    YAML.dump(@url_to_words, file)
    file.close
  end

  def load filename
    file = File.open(filename,"r")
    @url_to_words = YAML.load(file)
    file.close        
  end

  private
  
  def extract_words freq, text 
    text.downcase.split(/\W/).select { |word| word.length > 0 }.each do |word|      
      if freq.has_key? word
        freq[word] = freq[word] + 1
      else
        freq[word] = 1
      end
    end
  end

  # add the elements from b to a
  def combine_hash a, b
    b.each do |k,v|
      current = a[k]
      current ||= 0
      a[k] = current + v
    end
  end
  
end
