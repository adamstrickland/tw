Given /^a TaxMachine$/ do
  $LOAD_PATH << '../../lib'
  require 'tax_machine/register'
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

  @register = TaxMachine::Register.new(config)
end

When /^I run the data:$/ do |string|
  input.each do |line|
    @register.add line.chomp
  end
end

Then /^I should see the output:$/ do |string|
  @register.to_s.should match string
end