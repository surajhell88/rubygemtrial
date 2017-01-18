require "rubygemtrial/netrc-interactor"
require 'octokit'

module Rubygemtrial
	class Github
		attr_accessor :client
		def initialize()
	      	netrc = Rubygemtrial::NetrcInteractor.new()
	      	netrc.read
	      	token = netrc.password
	      	if !token.nil?
				@client = Octokit::Client.new(:access_token => token)
	      	end
		end
	end
end