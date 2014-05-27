require 'rails/generators/migration'
require 'active_support/core_ext'

module Contextify
  module Generators
    class UserGenerator < Rails::Generators::NamedBase
      argument :role_cname, :type => :string, :default => "Role"
      class_option :orm, :type => :string, :default => "active_record"

      desc "Inject contextify method in the User class."

      def inject_user_content
        inject_into_file(model_path, :after => inject_contextify_method) do
          " contextify#{role_association}\n"
        end
      end

      def inject_contextify_method
        if options.orm == :active_record
          /class #{class_name.camelize}\n|class #{class_name.camelize} .*\n|class #{class_name.demodulize.camelize}\n|class #{class_name.demodulize.camelize} .*\n/
        end
      end

      def model_path
        File.join("app", "models", "#{file_path}.rb")
      end

      def role_association
        if role_cname != "Role"
          " :role_cname => '#{role_cname.camelize}'"
        else
          ""
        end
      end
    end
  end
end
