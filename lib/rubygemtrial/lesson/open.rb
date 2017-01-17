require "rubygemtrial/api"
require "rubygemtrial/netrc-interactor"
require 'json'
require 'octokit'
require 'git'

module Rubygemtrial
	class Open
		attr_reader :currentLesson, :token, :cloneUrl, :lessonName, :rootDir

		HOME_DIR = File.expand_path("~")

	    def initialize()
	      	netrc = Rubygemtrial::NetrcInteractor.new()
	      	netrc.read
	      	tok = netrc.password
	      	if !tok.nil?
	      		@token = tok
	      	end
	      	if File.exists?("#{HOME_DIR}/.ga-config")
	      		@rootDir = YAML.load(File.read("#{HOME_DIR}/.ga-config"))[:workspace]
	      	end
	    end

		def openALesson
			# get currently active lesson
			getCurrentLesson
			if !File.exists?("#{rootDir}/#{lessonName}")
				# fork lesson repo via github api
				forkCurrentLesson
				# clone forked lesson into machine
				cloneCurrentLesson
			end
			# install dependencies
			# cd into it and invoke bash
			cdToLesson
		end

		def getCurrentLesson
			# https://api.myjson.com/bins/ymhxf
			puts "Getting current lesson..."
			begin
				Timeout::timeout(15) do
					response = Rubygemtrial::API.new().get('/bins/ymhxf')
					if response.status == 200
						lesson = JSON.parse(response.body)
						@currentLesson = 'sangamangreg/' + lesson.fetch('github_repo')
						@lessonName = lesson.fetch('github_repo')
					else
		             	puts "Something went wrong. Please try again."
		              	exit 1
					end
				end
			rescue Timeout::Error
				puts "Please check your internet connection."
				exit
			end
		end

		def forkCurrentLesson
			puts "Forking lesson..."
			octoClient = Octokit::Client.new(:access_token => token)
			begin
				Timeout::timeout(15) do
					forkedRepo = octoClient.fork(currentLesson)
					@cloneUrl = forkedRepo.git_url
				end
			rescue Octokit::Error => err
				puts "Error while forking!"
				puts err
				exit
			rescue Timeout::Error
				puts "Please check your internet connection."
				exit
			end
		end

		def cloneCurrentLesson
			puts "Cloning lesson..."
			begin
	          	Timeout::timeout(15) do
	            	Git.clone(cloneUrl, lessonName, path: rootDir)
	          	end
	        rescue Git::GitExecuteError => err
	            puts "Error while cloning!"
	            puts err
	            exit
	        rescue Timeout::Error
	            puts "Cannot clone this lesson right now. Please try again."
	            exit
	        end
		end

		def cdToLesson
			puts "Opening lesson..."
			Dir.chdir("#{rootDir}/#{lessonName}")
			puts "Done."
			exec("#{ENV['SHELL']} -l")
		end
	end
end