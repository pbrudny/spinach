require_relative '../../test_helper'
require_relative '../../../lib/spinach/generators'

module Spinach::Generators
  describe PageGenerator do
    subject { PageGenerator.new(page) }

    let(:page) { 'SignUp'}

    describe '#run' do
    end

    describe '#filename_with_path' do
      it 'prepends filename with the path' do
        subject.filename_with_path.
          must_include 'features/pages/sign_up_page.rb'
      end
    end

    describe '#generate' do
      it 'generates sample methods' do
        result = subject.generate

        result.must_match(/def visit/)
        result.must_match(/page.visit/)
        result.must_match(/def sample_content/)
      end

      it 'scopes the generated class to prevent conflicts' do
        result = subject.generate
        result.must_match(/class Spinach::Features::SignUpPage < Base/)
      end
    end

    describe '#create_page' do
      it 'stores the generated page into a file' do
        in_current_dir do
          subject.create_page
          File.directory?('features/pages/').must_equal true
          File.exists?('features/pages/sign_up_page.rb').must_equal true
          File.read('features/pages/sign_up_page.rb').strip.must_equal(subject.generate.strip)
          FileUtils.rm_rf('features/pages')
        end
      end

      it 'raises an error if the file already exists and does nothing' do
        file = 'features/pages/sign_up_page.rb'
        in_current_dir do
          FileUtils.mkdir_p 'features/pages'
          File.open(file, 'w') { |f| f.write('Fake content') }
          Proc.new{subject.create_page}.must_raise(Spinach::Generators::PageGeneratorException)
          FileUtils.rm_rf('features/pages')
        end
      end
    end
  end
end
