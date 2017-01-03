module AdHonorem
  # AdHonorem core class, must be inherited from
  class Badge < ::StaticRecord::Base
    table       :badges
    path        Rails.root.join('app', 'models', 'badges', '**', '*.rb')
    primary_key :slug

    attr_reader :objectives, :user

    # After all badges loading, @@hooks will look like
    # {
    #   master_a_weapon: {
    #     'ParameteredBadge' => [:checker_one, :checker_two],
    #     'LegacyBadge' => [:a_checker],
    #   },
    #   other_event: {
    #     'OtherBadgeResponder' => [:other_checker]
    #   }
    # }
    @@hooks = {}

    def initialize
      super

      @sub_badges = []
      @rewards    = []
      @objectives = {}
    end

    def set_context(user)
      @user = user
      self
    end

    def reload_context!
      check_context
      @user = AdHonorem.configuration.user_class.constantize.find(@user.id)
      self
    end

    def add_reward; end

    def add_objective(slug, name, description, amount_needed = 1)
      # prevent crash when Badges are initialized before migrations were applied
      return unless defined?(AdHonorem::Objective)
      @objectives[slug] = AdHonorem::Objective.new(slug, name, description, amount_needed)
    end

    def objectives_count
      objectives.keys.count
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

    def self.dispatch(user, event, params = nil)
      params ||= {}
      result = {}

      @@hooks[event] ||= {}
      @@hooks[event].each do |responder, registered_checkers|
        badge = find_by(klass: responder).set_context(user)
        registered_checkers.each do |checker|
          res = badge.trigger(checker, params)
          result[res] ||= []
          result[res] << "#{responder}##{checker}"
        end
      end

      result
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
        raise ObjectiveNotFound, "Objective #{objective_slug} could not be found" unless objective
      end

      objective
    end

    def meta?
      !@sub_badges.empty?
    end

    class << self
      protected

      def hook(event, params = nil)
        params ||= {}
        @@hooks[event] ||= {}
        @@hooks[event][name] ||= []
        @@hooks[event][name] += [params[:to] || []].flatten.uniq
      end
    end

    protected

    def add_sub_badge(badge_slug)
      @sub_badges << badge_slug
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

    def trigger_meta(objective_slug, params)
      @sub_badges.each do |sub_slug|
        sub_badge = AdHonorem::Badge.find(sub_slug).set_context(@user)
        next if sub_badge.complete? || !sub_badge.respond_to?(objective_slug)
        sub_badge.trigger(objective_slug, params)
      end
    end

    def complete_meta?
      check_context
      progress_meta(:global) == 100.0
    end

    def progress_meta(progress_type = :step)
      check_context

      case progress_type
      when :step
        @sub_badges.map { |sub_slug| AdHonorem::Badge.find(sub_slug).set_context(@user).progress(progress_type) }
      when :global
        res = @sub_badges.map do |sub_slug|
          AdHonorem::Badge.find(sub_slug).set_context(@user).progress(progress_type)
        end
        res.sum / @sub_badges.size
      end
    end

    def next_sub_badge
      @sub_badges.each do |sub_slug|
        sub = AdHonorem::Badge.find(sub_slug).set_context(@user)
        return sub unless sub.complete?
      end
      last_sub_badge
    end

    def last_sub_badge
      AdHonorem::Badge.find(@sub_badges.last).set_context(@user)
    end

    def reward
      # @rewards.each do |reward|
      # end
    end

    def check_context
      raise AdHonorem::NoContext, 'No context User has been set' unless @user
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
