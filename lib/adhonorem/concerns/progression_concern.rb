module AdHonorem
  # Contains methods related to badge progression
  module ProgressionConcern
    extend ActiveSupport::Concern

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
  end
end
