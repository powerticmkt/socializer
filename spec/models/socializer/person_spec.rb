require 'spec_helper'

module Socializer
  describe Person do

    # Define a person for common testd instead of build one for each
    let(:person) { FactoryGirl.build(:socializer_person) }

    it 'has a valid factory' do
      expect(person).to be_valid
    end

    it '.create_with_omniauth' do
      expect(Socializer::Person).to respond_to(:create_with_omniauth)
    end

    it '#authentications' do
      expect(person).to respond_to(:authentications)
    end

    it '#services' do
      expect(person).to respond_to(:services)
    end

    it '#circles' do
      expect(person).to respond_to(:circles)
    end

    it '#comments' do
      expect(person).to respond_to(:comments)
    end

    it '#notes' do
      expect(person).to respond_to(:notes)
    end

    it '#groups' do
      expect(person).to respond_to(:groups)
    end

    it '#memberships' do
      expect(person).to respond_to(:memberships)
    end

    it '#contacts' do
      expect(person).to respond_to(:contacts)
    end

    it '#contact_of' do
      expect(person).to respond_to(:contact_of)
    end

    it '#likes' do
      expect(person).to respond_to(:likes)
    end

    it '#likes?' do
      expect(person).to respond_to(:likes?)
    end

    it '#pending_memberships_invites' do
      expect(person).to respond_to(:pending_memberships_invites)
    end

    it '#avatar_url' do
      expect(person).to respond_to(:avatar_url)
    end

    it '#accept avatar_provider' do
      %w( TWITTER FACEBOOK LINKEDIN GRAVATAR ).each do |p|
        expect(build(:socializer_person, avatar_provider: p)).to have(0).error_on(:avatar_provider)
      end
    end

    it '#reject avatar_provider' do
      %w( IDENTITY TEST DUMMY OTHER ).each do |p|
        expect(build(:socializer_person, avatar_provider: p)).to have(1).error_on(:avatar_provider)
      end
    end

  end
end
