require 'fileutils'

module Spinach

  module Generators
    class PageHelpersGenerator
      def run
        create_helper
      end

      def generate
        result = StringIO.new
        result.puts 'module Pages'
        result.puts "  $:.unshift(Rails.root.join(#{Spinach.config[:features_path]}, 'pages'))"
        result.puts "  require 'base'"
        result.puts "  Dir['#{Spinach.config[:features_path]}/pages/*_page.rb'].each do |file|"
        result.puts "    method_name = File.basename(file).split('.').first"
        result.puts '    require method_name'
        result.puts '    define_method method_name do'
        result.puts '       page = instance_variable_get("@#{method_name}")'
        result.puts '       return page if page'
        result.puts '       instance_variable_set("@#{method_name}", "Pages::#{method_name.camelize}".constantize.new)'
        result.puts '    end'
        result.puts '  end'
        result.puts 'end'
        result.puts 'Spinach::FeatureSteps.send(:include, Pages)'
        result.string
      end

      def create_helper
        unless File.exists?(filename_with_path)
          FileUtils.mkdir_p path
          File.open(filename_with_path, 'w') do |file|
            file.write(generate)
            puts "Generating #{File.basename(filename_with_path)}"
          end
        end
      end

      def filename_with_path
        File.expand_path File.join(path, 'page_helpers.rb')
      end

      private

      def path
        "#{Spinach.config[:features_path]}/support/"
      end
    end

  end
end
