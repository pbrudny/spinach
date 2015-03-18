require_relative '../../test_helper'
require_relative '../../../lib/spinach/generators'

module Spinach::Generators
  describe PageHelpersGenerator do
    subject { PageHelpersGenerator.new }

    describe '#run' do
    end

    describe '#filename_with_path' do
      it 'prepends filename with the path' do
        subject.filename_with_path.
          must_include 'features/support/page_helpers.rb'
      end
    end

    describe '#generate' do
      it 'generates helper methods' do
        result = subject.generate
        result.must_match(/page = instance_variable_get/)
        result.must_match(/Spinach::FeatureSteps\.send/)
      end
    end

    describe '#create_helper' do
      it 'stores the generated page into a file' do
        in_current_dir do
          subject.create_helper
          File.directory?('features/support/').must_equal true
          File.exists?('features/support/page_helpers.rb').must_equal true
          File.read('features/support/page_helpers.rb').strip.must_equal(subject.generate.strip)
          FileUtils.rm_rf('features/support')
        end
      end

      describe 'when helper already exists' do
        it 'it does nothing and does not raise any exception' do
          file = 'features/support/page_helpers.rb'
          in_current_dir do
            FileUtils.mkdir_p 'features/support'
            File.open(file, 'w') { |f| f.write('Fake content') }
            Proc.new{subject.create_helper}.must_be_silent
            FileUtils.rm_rf('features/support')
          end
        end
      end
    end
  end
end
