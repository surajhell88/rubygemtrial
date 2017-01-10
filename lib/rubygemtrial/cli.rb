require 'thor'

module Rubygemtrial
  class PinkProton < Thor
    desc "hello", "This will greet you"
    def hello()
      puts "Hello World!"
    end
    desc "setup", "This will ask for token"
    def setup()
      puts "I will ask you the token later!"
    end
    desc "reset", "This will forget you"
    def reset()
      puts "Aww I am missing you already!"
    end
    desc "submit", "This will submit your work"
    def submit()
      puts "Way to go!"
    end
    desc "test", "This will test you"
    def test()
      puts "Bomb in the hole!"
    end
  end
end