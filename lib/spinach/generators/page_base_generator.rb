require 'fileutils'

module Spinach

  module Generators
    class PageBaseGenerator
      def run
        unless File.exists?(filename_with_path)
          FileUtils.mkdir_p path
          File.open(filename_with_path, 'w') do |file|
            file.write(generate)
            puts "Generating #{File.basename(filename_with_path)}"
          end
        end
      end

      def generate
        result = StringIO.new
        result.puts 'module Pages'
        result.puts '  class Base'
        result.puts '    include Capybara::DSL'
        result.puts '    #include FactoryGirl::Syntax::Methods'
        result.puts '  end'
        result.puts 'end'
        result.string
      end

      def filename_with_path
        File.expand_path File.join(path, 'base.rb')
      end

      private

      def path
        "#{Spinach.config[:features_path]}/pages/"
      end
    end

  end
end
