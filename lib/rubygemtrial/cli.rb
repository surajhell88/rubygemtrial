require 'rubygemtrial/user'
require 'rubygemtrial/netrc-interactor'
require "rubygemtrial/tests/runner"
require "rubygemtrial/lesson/submit"
require "rubygemtrial/lesson/open"
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
      user = Rubygemtrial::User.new()
      user.validate(password)
      user.setDefaultWorkspace
    end
    
    desc "reset", "This will forget you"
    def reset()
      Rubygemtrial::User.new().confirmAndReset
    end
    
    desc "open", "This will fork new work"
    def open()
      # Fork and Clone User's current lesson
      Rubygemtrial::Open.new().openALesson
    end
    
    desc "submit", "This will submit your work"
    def submit()
      Rubygemtrial::Submit.new().run
    end
    
    desc "test", "This will test you"
    def test()
      puts 'Testing...'
      Rubygemtrial::Test.new().run
    end

    desc 'version, -v, --version', 'Display the current version of the Learn gem'
    def version
      puts Rubygemtrial::VERSION
    end
  end
end