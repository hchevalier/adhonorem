module AdHonorem
  # Handle event and hook system
  module HookingConcern
    extend ActiveSupport::Concern

    module ClassMethods # :nodoc:
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

      def dispatch(user, event, params = nil)
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

      protected

      def hook(event, params = nil)
        params ||= {}
        @@hooks[event] ||= {}
        @@hooks[event][name] ||= []
        @@hooks[event][name] += [params[:to] || []].flatten.uniq
      end
    end
  end
end
