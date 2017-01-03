require 'spec_helper'
require 'rails_helper'

RSpec.describe AdHonorem::Badge do
  before(:each) do
    name = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
    @user = User.create(name: name)
    @meta_badge = AdHonorem::Badge.find('meta_badge').set_context(@user)
    @sub_one = AdHonorem::Badge.find('sub_badge_one').set_context(@user)
    @sub_two = AdHonorem::Badge.find('sub_badge_two').set_context(@user)
  end

  it 'returns next locked badge' do
    expect(@meta_badge.send(:next_sub_badge).class).to eql(SubBadgeOne)
    @user.update(level: 10)
    @meta_badge.trigger(:level_up)
    expect(@meta_badge.send(:next_sub_badge).class).to eql(SubBadgeTwo)
  end

  it 'delegates objective checks to all locked badge' do
    @user.update(level: 10)
    @meta_badge.trigger(:level_up)
    expect(@sub_one.complete?).to be true
    expect(@sub_two.complete?).to be false
    expect(@meta_badge.complete?).to be false

    @user.update(level: 15)
    @meta_badge.trigger(:level_up)
    expect(@sub_two.complete?).to be false
    expect(@meta_badge.complete?).to be false

    @user.update(level: 20)
    @meta_badge.trigger(:level_up)
    expect(@sub_two.complete?).to be true
    expect(@meta_badge.complete?).to be true
  end

  it 'works with event hooking' do
    @user.update(level: 10)
    expect(@sub_one.complete?).to be false
    res = AdHonorem::Badge.dispatch(@user, :level_up)
    expect(@sub_one.complete?).to be true
  end
end
