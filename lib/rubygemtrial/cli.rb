require 'thor'

module Rubygemtrial
  class PinkProton < Thor
    desc "hello", "This will greet you"
    def hello()
      puts "Hello World!"
    end
  end
end