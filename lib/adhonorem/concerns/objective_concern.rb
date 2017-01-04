module AdHonorem
  # Contains objective-related methods
  module ObjectiveConcern
    extend ActiveSupport::Concern

    attr_reader :objectives

    def add_objective(slug, name, description, amount_needed = 1)
      # prevent crash when Badges are initialized before migrations were applied
      return unless defined?(AdHonorem::Objective)
      @objectives[slug] = AdHonorem::Objective.new(slug, name, description, amount_needed)
    end

    def objectives_count
      objectives.keys.count
    end
  end
end
