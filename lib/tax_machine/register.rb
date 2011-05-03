require 'tax_machine/calculator'
require 'tax_machine/item'
require 'tax_machine/basket'
require 'tax_machine/configuration'

module TaxMachine
  class Register
    attr_accessor :basket
    attr_accessor :configs
    
    def self.run_from_file(path_to_file)
      unless File.exist?(path_to_file)
        $stderr.puts "Bad path to input file: #{path_to_file}"
        exit(1)
      end
      
      File.open(path_to_file, r) do |f|
        self.run_from_string(f.readlines.join)
      end
    end
    
    def self.run_from_string(input)
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
      input.each do |line|
        register.add line.chomp
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
    
    def a_of_h_to_h(a_of_h)
      Hash[*a_of_h.map{|_| _.to_a}.flatten]
    end
    
    def matchify(input)
      self.configs.map do |config|
        mr = config.pattern.match(input) 
        if mr
          captures = self.a_of_h_to_h(config.registers.map{ |k,v| { k => mr[v] } })
          captures[:rate] = config.exceptions.detect{ |ex| 
            captures[ex[:attribute]] =~ ex[:pattern] 
          } ? 0.0 : config.rate
          captures[:imported] = !(input =~ /^.*imported.*$/).nil?
          captures
        else
          nil
        end
      end.compact
    end
    
    def parse(input)
      array_of_capture_hashes = matchify(input)
      data = array_of_capture_hashes.group_by do |h| 
        keys = h.clone.delete_if{|k,v| [:rate].include?(k) }
        keys
      end.map{|k,g| k.merge({:rate => g.map{|hh| hh[:rate]}.inject(0){|s,i| s + i}})}.first
      tax = TaxMachine::Calculator.taxify(data[:price].to_f, data[:rate].to_f, data[:count].to_i)
      Item.new(data[:description], data[:price], data.merge(:tax => tax))
    end
    
    def to_s
      @basket.to_s
    end
    
    def print
      puts self.to_s
    end
  end
end