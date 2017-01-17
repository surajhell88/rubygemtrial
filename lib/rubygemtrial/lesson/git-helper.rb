require "rubygemtrial/netrc-interactor"

module Rubygemtrial
  class Submit
    class GitHelper
      attr_reader   :git, :dummyUsername
      attr_accessor :remote_name

      REPO_BELONGS_TO_US = [
        'sangamangreg'
      ]

      def initialize()
        puts 'githelper initialize'
        @git = setGit
        @dummyUsername = 'gitint'
      end

      def commitAndPush
        checkRemote
        addChanges
        commitChanges

        push
      end

      private

      def setGit
        begin
          Git.open(FileUtils.pwd)
        rescue ArgumentError => e
          if e.message.match(/path does not exist/)
            puts "It doesn't look like you're in a lesson directory."
            puts 'Please cd into an appropriate directory and try again.'

            exit 1
          else
            puts 'Sorry, something went wrong. Please try again.'
            exit 1
          end
        end
      end

      def checkRemote
        netrc = Rubygemtrial::NetrcInteractor.new()
        netrc.read(machine: 'ga-extra')
        username = dummyUsername || netrc.login
        if git.remote.url.match(/#{username}/i).nil? && git.remote.url.match(/#{REPO_BELONGS_TO_US.join('|').gsub('-','\-')}/i).nil?
          puts "It doesn't look like you're in a lesson directory."
          puts 'Please cd into an appropriate directory and try again.'

          exit 1
        else
          self.remote_name = git.remote.name
        end
      end

      def addChanges
        puts 'Adding changes...'
        git.add(all: true)
      end

      def commitChanges
        puts 'Committing changes...'
        begin
          git.commit('Done')
        rescue Git::GitExecuteError => e
          if e.message.match(/nothing to commit/)
            puts "It looks like you have no changes to commit."
            exit 1
          else
            puts 'Sorry, something went wrong. Please try again.'
            exit 1
          end
        end
      end

      def push()
        puts 'Pushing changes to GitHub...'
        push_remote = git.remote(self.remote_name)
        begin
          Timeout::timeout(15) do
            git.push(push_remote)
          end
        rescue Git::GitExecuteError => e
          puts 'Git Push Error'
          puts e.message
        rescue Timeout::Error
          puts "Can't reach GitHub right now. Please try again."
          exit 1
        end
      end
    end
  end
end
