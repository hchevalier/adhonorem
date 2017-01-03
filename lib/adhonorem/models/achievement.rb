module AdHonorem
  # Allows to get finished badges per user
  class Achievement < ActiveRecord::Base
    self.table_name = :adhonorem_achievements
    has_static_record :badge, class_name: 'AdHonorem::Badge'
    belongs_to :user, class_name: AdHonorem.configuration.user_class

    enum state: [:started, :done]
  end
end
