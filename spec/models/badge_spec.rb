require 'spec_helper'
require 'rails_helper'
require_relative '../helpers/badge_instantiator'

RSpec.describe AdHonorem::Badge do
  it 'inherits StaticRecord::Base' do
    expect(AdHonorem::Badge.where(name: 'Normal badge').first).to be_a(NormalBadge)
  end

  context 'without user context' do
    it 'requires a context User to be set' do
      badge = AdHonorem::Badge.find('normal_badge')
      expect { badge.progress }.to raise_error(AdHonorem::NoContext)
      expect { badge.complete? }.to raise_error(AdHonorem::NoContext)
      expect { badge.trigger(:visit_paris) }.to raise_error(AdHonorem::NoContext)
    end
  end

  context 'with user context' do
    before(:each) do
      instantiate_badges
    end

    it 'works with user set' do
      expect { @normal_badge.progress }.not_to raise_error
    end

    it 'allows to check badge completion' do
      expect(@normal_badge.complete?).to be false
    end

    it 'allows to check specific objective completion' do
      @two_objectives_badge.trigger(:use_longbow)
      expect(@two_objectives_badge.complete?(:use_longbow)).to be true
    end

    it 'allows to check specific objective completion' do
      @two_objectives_badge.trigger(:use_longbow)
      expect(@two_objectives_badge.complete?(:use_longbow)).to be true
    end
  end

  context 'when dispatching an event' do
    it 'triggers checkers that hooked to dispatched event' do
      user = User.create(name: 'Dispatch')
      data = { weapon_used: 'bow' }
      badge = AdHonorem::Badge.find('parametered_badge').set_context(user)

      res = AdHonorem::Badge.dispatch(user, :mastered_a_weapon, data: data)
      expect(badge.complete?(:master_bow)).to be true
      expect(badge.complete?(:master_sword)).to be false
      expect(badge.complete?).to be false
      expect(res[:completed_step].include?('ParameteredBadge#master_bow'))
      expect(res[:failed_check].include?('ParameteredBadge#master_sword'))

      res = AdHonorem::Badge.dispatch(user, :mastered_a_weapon, data: data.merge(weapon_used: 'sword'))
      expect(badge.complete?(:master_sword)).to be true
      expect(badge.complete?).to be true
      expect(res[:completed_badge].include?('ParameteredBadge#master_sword'))
      expect(res[:already_done].include?('ParameteredBadge#master_bow'))
    end
  end
end
