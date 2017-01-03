module AdHonorem
  # Store users' progress in database for each badge triggered at least once
  class Progress < ActiveRecord::Base
    self.table_name = :adhonorem_progresses
    has_static_record :badge, class_name: 'AdHonorem::Badge'
    belongs_to :user, class_name: AdHonorem.configuration.user_class

    PROGRESS_TYPES = {
      numeric: :capped_numeric_progress,
      percentage: :percentage_progress,
      stringified: :stringified_progress
    }.freeze

    def advance(amount = 1)
      return if done?
      self.numeric_progress += amount
      save
    end

    def objective
      badge.objectives[objective_slug.to_sym]
    end

    def done?
      numeric_progress >= objective.amount_needed
    end

    def progress(progress_type = :numeric)
      raise AdHonorem::NotSuchProgressType unless PROGRESS_TYPES.keys.include?(progress_type)
      send(PROGRESS_TYPES[progress_type])
    end

    private

    def percentage_progress
      return 100.0 if objective.amount_needed.zero?
      capped_numeric_progress.to_f / objective.amount_needed * 100.0
    end

    def stringified_progress
      "#{capped_numeric_progress}/#{objective.amount_needed}"
    end

    def capped_numeric_progress
      [self.numeric_progress, objective.amount_needed].min
    end
  end
end
