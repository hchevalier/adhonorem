module AdHonorem
  module DefaultAttributesConcern # :nodoc:
    extend ActiveSupport::Concern

    module ClassMethods # :nodoc:
      def default_legacy
        false
      end

      def default_points
        AdHonorem.configuration.default_points
      end

      def override_icon_locked(icon_locked)
        return icon_locked if icon_locked.to_s.include?('/')

        path = AdHonorem.configuration.locked_icon_path
        case path.class.name
        when 'String'
          path + icon_locked
        when 'Pathname'
          path.itself + icon_locked
        else
          icon_locked
        end
      end

      def override_icon_unlocked(icon_unlocked)
        return icon_unlocked if icon_unlocked.to_s.include?('/')

        path = AdHonorem.configuration.unlocked_icon_path
        case path.class.name
        when 'String'
          path + icon_unlocked
        when 'Pathname'
          path.itself + icon_unlocked
        else
          icon_unlocked
        end
      end
    end
  end
end
