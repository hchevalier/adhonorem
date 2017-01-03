class ParameteredBadge < AdHonorem::Badge
  attribute :slug,          'parametered_badge'
  attribute :name,          'Parametered badge'
  attribute :description,   'This is a parametered_badge badge'
  attribute :category,      'General'
  attribute :points,        10
  attribute :icon_locked,   Rails.root.join('public', 'badges', 'locked', 'parametered_badge.png')
  attribute :icon_unlocked, Rails.root.join('public', 'badges', 'unlocked', 'parametered_badge.png')
  attribute :legacy,        false

  hook :mastered_a_weapon, to: [:master_sword, :master_bow]

  def initialize
    super

    add_objective(:master_sword, 'Master sword', 'You shall learn the ancient secrets of chivalry')
    add_objective(:master_bow, 'Master bow', 'You shall learn the ancient secrets of archery')
  end

  def master_sword(user, params)
    weapon_checker('sword', params[:weapon_used])
  end

  def master_bow(user, params)
    weapon_checker('bow', params[:weapon_used])
  end

  private

  def weapon_checker(weapon_to_master, weapon_used)
    weapon_to_master == weapon_used
  end
end
