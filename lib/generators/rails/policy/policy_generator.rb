module Rails
  module Generators
    class PolicyGenerator < NamedBase
      source_root File.expand_path('templates', __dir__)

      def create_policy_file
        template 'policy.rb', File.join('app/policies', class_path, "#{file_name}_policy.rb")
      end

      hook_for :test_framework
    end
  end
end
