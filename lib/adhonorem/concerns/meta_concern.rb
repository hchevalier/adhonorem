module AdHonorem
  # Concerning meta badges
  module MetaConcern
    extend ActiveSupport::Concern

    def meta?
      !@sub_badges.empty?
    end

    protected

    def add_sub_badge(badge_slug)
      @sub_badges << badge_slug
    end

    private

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

      res = @sub_badges.map do |sub_slug|
        sub_badge = AdHonorem::Badge.find(sub_slug)
        sub_badge.set_context(@user).progress(progress_type)
      end

      case progress_type
      when :step
        res
      when :global
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
  end
end
