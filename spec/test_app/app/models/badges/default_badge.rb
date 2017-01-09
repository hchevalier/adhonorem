class DefaultBadge < AdHonorem::Badge
  attribute :slug,          'default_badge'
  attribute :name,          'Default badge'
  attribute :description,   'This is a default badge'
  attribute :icon_locked,   'normal.png'
  attribute :icon_unlocked, 'normal.png'

  def initialize
    super

    add_objective(:do_nothing, 'Do nothing', 'Do nothing')
  end

  def do_nothing(user, params)
    true
  end
end
