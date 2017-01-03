module AdHonorem
  # Contains AdHonorem settings
  class Configuration
    attr_accessor :user_class

    def initialize
      @user_class = 'User'
    end
  end
end
