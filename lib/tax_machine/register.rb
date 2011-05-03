require 'tax_machine/calculator'
require 'tax_machine/float'
require 'tax_machine/item'
require 'tax_machine/basket'
require 'tax_machine/configuration'

module TaxMachine
  class Register
    attr_accessor :basket
    attr_accessor :configs
    
    def self.run(path_to_file)
      unless File.exist?(path_to_file)
        $stderr.puts "Bad path to input file: #{path_to_file}"
        exit(1)
      end
      
      config = [   
        TaxMachine::Configuration.new({
          :pattern => %r{^([0-9]+)\s(.+)\sat\s([0-9]+\.[0-9]{2})$},
          :rate => 0.10,
          :registers => {
            :count => 1,
            :description => 2,
            :price => 3
          },
          :exceptions => [
            {
              :qualifier => :food,
              :attribute => :description,
              :pattern => %r{chocolate}
            },
            {
              :qualifier => :books,
              :attribute => :description,
              :pattern => %r{book}
            },
            {
              :qualifier => :medical,
              :attribute => :description,
              :pattern => %r{pill}
            }
          ]
        }),
        TaxMachine::Configuration.new({
          :pattern => %r{^([0-9]+)\s(.*imported.*)\sat\s([0-9]+\.[0-9]{2})$},
          :rate => 0.05,
          :registers => {
            :count => 1,
            :description => 2,
            :price => 3
          },
          :options => {
            :imported => true
          },
          :exceptions => []
        })
      ]
      
      register = Register.new(config)
      File.foreach(path_to_file) do |line|
        register.add line
      end
      register.print
    end
    
    def initialize(configs)
      self.configs = configs
      self.reset
    end
    
    def reset
      self.basket = Basket.new
    end
    
    def add(input)
      @basket.items << self.parse(input)
    end
    
    def matchify(input)
      self.configs.map do |config|
        mr = config.pattern.match(input) 
        captures = Hash[*(config.registers.map do |k,v|
          { k => mr[v] }
        end).map{ |_| _.to_a}.flatten
        captures[:rate] = mr.exceptions.detect{ |ex| captures[ex[:attribute]] =~ ex[:pattern] } ? 0.0 : mr.rate
        captures
      end
    end
    
    def parse(input)
      array_of_capture_hashes = matchify(input)
      # data.group_by{|h| {:key1 => h[:key1], :key2 => h[:key2]}}.map{|k,g| k.merge({:rate => g.map{|hh| hh[:rate]}.inject(0){|s,i| s + i}})}
      
    end
    
    def find_match(input)
      match = self.configs.detect{ |c| input =~ c.pattern }
      self.configs.index(match)
    end
    
    # def matches(input)
    #   matches = self.configs.map do |config|
    #     input =~ config.pattern
    #     $~.captures
    #   end
    #   if matches.compact.empty?
    #     raise "A pattern could not be found to match #{input}"
    #   end
    #   matches
    # end
    
    def parse(input)
      index = find_match(input)
      rating = self.configs[index]
      captures = rating.pattern.match(input)
      array_of_captures = rating.registers.map do |k,v|
        { k => captures[v] }
      end
      captures = Hash[*array_of_captures.map{|_| _.to_a}.flatten]
      
      tax = if rating.exceptions.detect{|ex| captures[ex[:attribute]] =~ ex[:pattern] }
        0
      else
        TaxMachine::Calculator.taxify(captures[:price].to_f, rating.rate, captures[:count].to_i)
      end
      
      Item.new(captures[:description], captures[:price], rating.options.merge(:count => captures[:count], :tax => tax))
    end
    
    def print
      puts @basket.to_s
    end
  end
end