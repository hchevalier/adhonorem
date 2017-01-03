class NormalBadge < AdHonorem::Badge
  attribute :slug,          'normal_badge'
  attribute :name,          'Normal badge'
  attribute :description,   'This is a normal badge'
  attribute :category,      'General'
  attribute :points,        10
  attribute :icon_locked,   Rails.root.join('public', 'badges', 'locked', 'normal.png')
  attribute :icon_unlocked, Rails.root.join('public', 'badges', 'unlocked', 'normal.png')
  attribute :legacy,        false

  def initialize
    super

    add_objective(:visit_paris, 'Visit Paris', 'Go to Paris')
  end

  def visit_paris(user, params)
    true
  end
end
