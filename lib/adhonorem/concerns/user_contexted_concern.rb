module AdHonorem
  module UserContextedConcern # :nodoc:
    extend ActiveSupport::Concern

    attr_reader :user

    def set_context(user)
      @user = user
      self
    end

    def reload_context!
      check_context
      @user = AdHonorem.configuration.user_class.constantize.find(@user.id)
      self
    end

    def check_context
      raise AdHonorem::NoContext, 'No context User has been set' unless @user
    end
  end
end
