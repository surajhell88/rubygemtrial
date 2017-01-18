require "rubygemtrial/lesson/git-helper"
require 'octokit'

module Rubygemtrial
  class Submit
    def run
      puts 'submit run'
      Rubygemtrial::Submit::GitHelper.new().commitAndPush
      # Just to give GitHub a second to register the repo changes
      sleep(1)
    end
  end
end
