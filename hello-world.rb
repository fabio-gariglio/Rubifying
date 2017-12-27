class Greeter

    def initialize(names)
        @names = names
    end

    def say_hi_to_all
        @names.each do |name|
            puts "Hello #{name}!"
        end
    end

end

c = Greeter.new ["Fabio", "Dave"]

c.say_hi_to_all