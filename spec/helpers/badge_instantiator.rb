def instantiate_badges
  name = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
  @user = User.create(name: name)

  @normal_badge = AdHonorem::Badge.find('normal_badge').set_context(@user)

  @two_objectives_badge = AdHonorem::Badge.find('two_objectives_badge').set_context(@user)

  @conditionnal_badge = AdHonorem::Badge.find('conditionnal_badge').set_context(@user)

  @legacy_badge = AdHonorem::Badge.find('legacy_badge').set_context(@user)

  @parametered_badge = AdHonorem::Badge.find('parametered_badge').set_context(@user)
end
