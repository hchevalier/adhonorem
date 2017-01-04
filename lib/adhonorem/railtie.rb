class Railtie < Rails::Railtie # :nodoc:
  initializer 'adhonorem.load_static_record_dependent_files' do |_app|
    ActiveSupport.on_load :static_record do
      require 'adhonorem/models/objective'
      require 'adhonorem/models/achievement'
      require 'adhonorem/models/progress'

      require 'adhonorem/concerns/user_contexted_concern'
      require 'adhonorem/concerns/objective_concern'
      require 'adhonorem/concerns/hooking_concern'
      require 'adhonorem/concerns/meta_concern'
      require 'adhonorem/concerns/reward_concern'
      require 'adhonorem/models/badge'

      ActiveSupport.run_load_hooks(:adhonorem, AdHonorem::Badge)
    end
  end
end
