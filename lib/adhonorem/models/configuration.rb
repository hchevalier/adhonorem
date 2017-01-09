module AdHonorem
  # Contains AdHonorem settings
  class Configuration
    attr_accessor :user_class,
                  :default_points,
                  :locked_icon_path,
                  :unlocked_icon_path,
                  :default_category

    def initialize
      @user_class = 'User'
      @default_points = 5
      @locked_icon_path = Rails.root.join('public', 'badges', 'locked')
      @unlocked_icon_path = Rails.root.join('public', 'badges', 'unlocked')
      @default_category = 'general'
    end
  end
end
