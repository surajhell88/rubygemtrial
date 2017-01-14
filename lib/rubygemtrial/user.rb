require "rubygemtrial/api"
require "rubygemtrial/netrc-interactor"
require 'json'
require 'octokit'
require 'git'
require 'yaml'

module Rubygemtrial
	class User
		attr_reader :netrc, :currentLesson, :token, :cloneUrl, :lessonName, :rootDir

		DEFAULT_EDITOR = 'atom'
		HOME_DIR = File.expand_path("~")

	    def initialize()
	      	@netrc = Rubygemtrial::NetrcInteractor.new()
	      	netrc.read
	      	tok = netrc.password
	      	if !tok.nil?
	      		@token = tok
	      	end
	      	if File.exists?("#{HOME_DIR}/.ga-config")
	      		@rootDir = YAML.load(File.read("#{HOME_DIR}/.ga-config"))[:workspace]
	      	end
	    end

		def validate(token)
			puts "Authenticating..."
			begin
				Timeout::timeout(15) do
					response = Rubygemtrial::API.new().get('/bins/c4vbn')
					if response.status == 200
						# Save valid user details in netrc
						user = JSON.parse(response.body)
						login, password = netrc.read
						if login.nil? || password.nil?
							save(user, token)
						else
							username = user.fetch('username')
							welcome(username)
						end
					else
						case response.status
			            when 401
			              puts "It seems your OAuth token is incorrect. Please retry with correct token."
			              exit 1
			            else
			              puts "Something went wrong. Please try again."
			              exit 1
			            end
					end
				end
			rescue Timeout::Error
				puts "Please check your internet connection."
				exit
			end
		end

		def save(userDetails, token)
			username = userDetails.fetch('username')
			github_uid = userDetails.fetch('github_uid')
			netrc.write(new_login: 'greyatom', new_password: token)
			netrc.write(machine: 'ga-extra', new_login: username, new_password: github_uid)
			welcome(username)
		end

		def setDefaultWorkspace
			workspaceDir = File.expand_path('~/Workspace/code')
			configPath = File.expand_path('~/.ga-config')

			FileUtils.mkdir_p(workspaceDir)
			FileUtils.touch(configPath)

			data = YAML.dump({ workspace: workspaceDir, editor: DEFAULT_EDITOR })

			File.write(configPath, data)
		end

	    def confirmAndReset
	      	if confirmReset?
	        	netrc.delete!(machine: 'ga-config')
	        	netrc.delete!(machine: 'ga-extra')
	        	puts "Sorry to see you go!"
        	else
        		puts "Thanks for being there with us!"
	      	end

	      	exit
	    end

	    def confirmReset?
	      	puts "This will remove your existing login configuration and reset.\n"
	      	print "Are you sure you want to do this? [yN]: "

	      	response = STDIN.gets.chomp.downcase

	      	!!(response == 'yes' || response == 'y')
	    end

		def welcome(username)
			puts "Welcome, #{username}!"
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