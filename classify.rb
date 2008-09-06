require 'parser'
require 'the_register_rules'
require 'the_register_or_lamborghini_rules'

require 'classifier/m_algo'
require 'classifier/word_occ'
require 'classifier/naive_bayes'
require 'classifier/multinominal_bayes'
require 'classifier/markov_chain'

require 'cross_validator'
require 'yaml'

class Classify
    def initialize crossvalidators, input_file
        @crossvalidators = crossvalidators
        @input_file = input_file
    end

    def pass_over_file method
        idx = 0
        Parser.new.articles_from_file(@input_file) do |article|
            article[:classification] = article[:url]
            @crossvalidators.each do |crossvalidator|
                crossvalidator.send method, idx, article
            end
            idx += 1
        end
    end

    def display_results
        @crossvalidators.each do |crossvalidator|
            classifier = crossvalidator.classifier
            display_name = classifier.respond_to?(:display_name) ? classifier.display_name : classifier.class.to_s
            puts "result #{display_name} #{crossvalidator.pass_rate}"
        end
    end
    
    def run
        pass_over_file :training_pass
        pass_over_file :testing_pass
        display_results
    end
end

raise "classify.rb <slice> <num_slices> <article file>" if ARGV.length!=3
slice, num_slices, input = ARGV

classifiers = [
        WordOccClassifier.new,
        NaiveBayesClassifier.new,
        #MultinominalBayesClassifier.new,
        MarkovChainClassifier.new(:include_start_end => true)
    ]

crossvalidators = classifiers.collect { |classifier| CrossValidator.new(classifier, slice.to_i, num_slices.to_i) }

classify = Classify.new  crossvalidators, input
classify.run



