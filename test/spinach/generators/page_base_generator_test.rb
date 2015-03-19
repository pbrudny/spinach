require_relative '../../test_helper'
require_relative '../../../lib/spinach/generators'

module Spinach::Generators
  describe PageBaseGenerator do
    subject { PageBaseGenerator.new }

    describe '#filename_with_path' do
      it 'prepends filename with the path' do
        subject.filename_with_path.
          must_include 'features/pages/base.rb'
      end
    end

    describe '#generate' do
      it 'generates helper methods' do
        result = subject.generate
        result.must_match(/class Base/)
        result.must_match(/include Capybara::DSL/)
        result.must_match(/#include FactoryGirl::Syntax::Methods/)
      end
    end

    describe '#run' do
      it 'stores the generated page into a file' do
        in_current_dir do
          subject.run
          File.directory?('features/pages/').must_equal true
          File.exists?('features/pages/base.rb').must_equal true
          File.read('features/pages/base.rb').strip.must_equal(subject.generate.strip)
          FileUtils.rm_rf('features/pages')
        end
      end

      describe 'when helper already exists' do
        it 'it does nothing and does not raise any exception' do
          file = 'features/pages/base.rb'
          in_current_dir do
            FileUtils.mkdir_p 'features/pages'
            File.open(file, 'w') { |f| f.write('Fake content') }
            Proc.new{subject.run}.must_be_silent
            FileUtils.rm_rf('features/pages')
          end
        end
      end
    end
  end
end
