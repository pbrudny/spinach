require 'fileutils'

module Spinach

  module Generators
    # A page generator generates a class corresponding with html page following page object pattern.
    class PageGenerator

      def initialize(page)
        self.page = page
      end

      def run
        create_page
        create_page_helpers
        create_base_page_class
      end

      def generate
        result = StringIO.new
        result.puts 'module Pages'
        result.puts "  class #{Spinach::Support.scoped_camelize name} < Base"
        result.puts '    def visit'
        result.puts "      page.visit('/')"
        result.puts '    end'
        result.puts ''
        result.puts '    def sample_content'
        result.puts "      'Hello World'"
        result.puts '    end'
        result.puts '  end'
        result.puts 'end'
        result.string
      end

      def create_page
        if File.exists?(filename_with_path)
          raise PageGeneratorException.new("File #{filename_with_path} already exists.")
        else
          FileUtils.mkdir_p path
          File.open(filename_with_path, 'w') do |file|
            file.write(generate)
            puts "Generating #{File.basename(filename_with_path)}"
          end
        end
      end

      def filename_with_path
        File.expand_path File.join(path, filename)
      end

      private

      def create_page_helpers
        Spinach::Generators::PageHelpersGenerator.new.run
      end

      def create_base_page_class
        Spinach::Generators::PageBaseGenerator.new.run
      end

      def name
        "#{Spinach::Support.underscore(page)}_page"
      end

      def filename
        "#{name}.rb"
      end

      def path
        "#{Spinach.config[:features_path]}/pages"
      end

      attr_accessor :page
    end
    class PageGeneratorException < Exception; end;
  end
end
