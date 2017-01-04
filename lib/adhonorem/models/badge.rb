module AdHonorem
  # AdHonorem core class, must be inherited from
  class Badge < ::StaticRecord::Base
    include AdHonorem::UserContextedConcern
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

    def progress(progress_type = :step)
      check_context
      return progress_meta(progress_type) if meta?

      case progress_type
      when :step
        objectives.keys.map do |slug|
          name = objectives[slug].name
          "#{name} : #{get_progression_for(slug).progress(:stringified)}"
        end
      when :global
        objectives.keys.map { |slug| get_progression_for(slug).progress(:percentage) }.sum / objectives_count
      end
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

    def complete?(objective = nil)
      # Meta badges don't handle per-objective completion
      return complete_meta? if meta?
      check_context
      selection = objectives.keys
      selection.select! { |slug| slug == objective } if objective
      selection.each do |slug|
        objective = objectives[slug]
        return false unless get_progression_for(objective).done?
      end
      true
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

    def proceed(objective_slug, params)
      objective = get_objective(objective_slug)
      progression = get_progression_for(objective)
      return :failed_check unless send(objective.slug, user, params[:data] || {})

      progression.advance(params[:amount] || 1)
      if complete?
        unlock
        reward
        return :completed_badge
      end

      progression.done? ? :completed_step : :triggered
    end

    def get_progression_for(objective)
      objective = get_objective(objective)

      AdHonorem::Progress.find_or_initialize_by(
        user: @user,
        badge_static_record_type: self.class.name,
        objective_slug: objective.slug.to_s
      )
    end

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
            category:         :string,
            points:           :integer,
            icon_locked:      :string,
            icon_unlocked:    :string,
            legacy:           :boolean
  end
end
