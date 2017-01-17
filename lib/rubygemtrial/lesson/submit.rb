require "rubygemtrial/lesson/git-helper"

module Rubygemtrial
  class Submit
    def run
      puts 'submit run'
      Rubygemtrial::Submit::GitHelper.new().commitAndPush
      createPullRequest
      # Just to give GitHub a second to register the repo changes
      sleep(1)
    end

    private

    def createPullRequest
      puts 'Creating Pull Request...'
    end
  end
end
