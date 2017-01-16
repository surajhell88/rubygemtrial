require 'rubygemtrial/tests/strategy'

module Rubygemtrial
  module Strategies
    class PythonUnittest < Rubygemtrial::Strategy

      def detect
        files.any? {|f| f.match(/.*.py$/) }
      end

      def files
        @files ||= Dir.entries('.')
      end

      def run
        system("nosetests")
      end

    end
  end
end
