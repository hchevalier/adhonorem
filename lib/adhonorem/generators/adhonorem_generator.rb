module Adhonorem
  class MigrationsGenerator < Rails::Generators::Base # :nodoc:
    source_root File.expand_path('../templates', __FILE__)

    def copy_files
      time = Time.zone.now.strftime('%Y%m%d%H%M')
      template 'progress_migration.rb', "db/migrate/#{time}00_create_adhonorem_progress.rb"
      template 'achievement_migration.rb', "db/migrate/#{time}01_create_adhonorem_achievement.rb"
    end
  end

  class InitializerGenerator < Rails::Generators::Base # :nodoc:
    source_root File.expand_path('../templates', __FILE__)

    def copy_files
      @model_name = ask('How is your user model called? [User]')
      @model_name = 'User' if @model_name.blank?
      template 'initializer.rb', 'config/initializers/adhonorem.rb', @model_name
    end
  end
end
