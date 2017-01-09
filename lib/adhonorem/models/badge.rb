module AdHonorem
  # AdHonorem core class, must be inherited from
  class Badge < ::StaticRecord::Base
    include AdHonorem::UserContextedConcern
    include AdHonorem::DefaultAttributesConcern
    include AdHonorem::ProgressionConcern
    include AdHonorem::ObjectiveConcern
    include AdHonorem::HookingConcern
    include AdHonorem::MetaConcern
    include AdHonorem::RewardConcern

    table       :badges
    path        Rails.root.join('app', 'models', 'badges', '**', '*.rb')
    primary_key :slug

    def initialize
      super

      @sub_badges = []
      @rewards    = []
      @objectives = {}
    end

    def legacy?
      legacy || false
    end

    def trigger(objective_slug, params = nil)
      return trigger_meta(objective_slug, params || {}) if meta?

      return :already_done if complete?(objective_slug) || complete?
      return :legacy_badge if legacy?

      params ||= {}
      proceed(objective_slug, params)
    end

    def get_objective(objective_slug)
      objective = objective_slug
      unless objective.is_a?(AdHonorem::Objective)
        objective = objectives[objective_slug]
        err = "Objective #{objective_slug} could not be found"
        raise ObjectiveNotFound, err unless objective
      end

      objective
    end

    private

    def related_achievement
      AdHonorem::Achievement.find_or_initialize_by(
        user: @user,
        badge_static_record_type: self.class.name
      )
    end

    def unlock
      raise AdHonorem::NotCompleted unless complete?
      achievement = related_achievement
      achievement.done!
    end

    columns slug:             :string,
            name:             :string,
            description:      :string,
            category:         :static_record,
            points:           :integer,
            icon_locked:      :string,
            icon_unlocked:    :string,
            legacy:           :boolean
  end
end
