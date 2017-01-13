require 'rubygemtrial/user'
require 'rubygemtrial/netrc-interactor'
require 'thor'

module Rubygemtrial
  class PinkProton < Thor
    desc "hello", "This will greet you"
    def hello()
      puts "Hello World!"
    end

    desc "setup", "This will ask for token"
    def setup(retries: 5)
      # Check if token already present
      login, password = Rubygemtrial::NetrcInteractor.new().read
      if login.nil? || password.nil?
        print 'Enter your github token here and press [ENTER]: '
        password = STDIN.gets.chomp
        if password.empty?
          puts "No token provided."
          exit
        end
      end
      # Check if token is valid
      Rubygemtrial::User.new().validate(password)
    end
    
    desc "reset", "This will forget you"
    def reset()
      # puts "Aww I am missing you already!"
      Rubygemtrial::User.new().confirmAndReset
    end
    
    desc "open", "This will fork new work"
    def open()
      puts "Get ready!"
    end
    
    desc "submit", "This will submit your work"
    def submit()
      puts "Way to go!"
    end
    
    desc "test", "This will test you"
    def test()
      puts "Bomb in the hole!"
    end

    desc 'version, -v, --version', 'Display the current version of the Learn gem'
    def version
      puts Rubygemtrial::VERSION
    end
  end
end