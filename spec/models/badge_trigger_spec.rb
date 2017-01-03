require 'spec_helper'
require 'rails_helper'
require_relative '../helpers/badge_instantiator'

RSpec.describe AdHonorem::Badge do
  before(:each) do
    instantiate_badges
  end

  context 'when triggering a badge step-checker' do
    it 'returns :triggered when a step-checker returns true but it\'s not fulfilled yet' do
      expect(@two_objectives_badge.trigger(:use_sword)).to eql(:triggered)
    end

    it 'returns :failed_check when a step-checker returns false' do
      expect(@conditionnal_badge.trigger(:whoami)).to eql(:failed_check)
    end

    it 'can succeed when conditions match' do
      darth_vader = User.create(name: 'Darth Vader')
      @conditionnal_badge.set_context(darth_vader)
      expect(@conditionnal_badge.trigger(:whoami)).to eql(:completed_badge)
    end

    it 'returns :completed_step when all conditions for an objective are fulfilled' do
      expect(@two_objectives_badge.trigger(:use_longbow)).to eql(:completed_step)
    end

    it 'returns :completed_badge when all conditions for all objectives are fulfilled' do
      expect(@normal_badge.trigger(:visit_paris)).to eql(:completed_badge)
    end

    it 'returns :already_done when a badge is alreay unlocked' do
      expect(@normal_badge.trigger(:visit_paris)).to eql(:completed_badge)
      expect(@normal_badge.trigger(:visit_paris)).to eql(:already_done)
    end

    it 'returns :legacy_badge when a badge is legacy' do
      expect(@legacy_badge.trigger(:try_me)).to eql(:legacy_badge)
    end

    it 'allows to trigger an objective several times in a row' do
      expect(@two_objectives_badge.trigger(:use_sword, {amount: 5})).to eql(:completed_step)
      expect(@two_objectives_badge.complete?(:use_sword)).to be true
    end

    it 'allows to pass any data to the checkers' do
      data = { weapon_used: 'bow' }
      expect(@parametered_badge.trigger(:master_sword, data: data)).to eql(:failed_check)
      expect(@parametered_badge.trigger(:master_bow, data: data)).to eql(:completed_step)
    end
  end
end
