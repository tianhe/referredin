require 'spec_helper'

describe User do
  context '#connect' do
    let!(:user) { FactoryGirl.create(:user) }

    it 'should connect user to existing profile and user' do
      subprofile = FactoryGirl.create(:subprofile)

      contacts = [{ identifier: subprofile.identifier, provider: subprofile.provider }]

      user.connect(contacts)

      user.contacts.should == [subprofile.profile]
    end

    it 'should create a new user and profile if the new profile doesnt match existing user' do
      provider = 'linkedin'
      uid = '1000000'
      contacts = [{ identifier: uid, provider: provider }]

      user.connect(contacts)

      user.contacts.should == [Subprofile.find_by_identifier(uid).profile]
    end
  end

  context '#find_for_linkedin_oauth(auth)' do
    it 'should return user if provider and uid already exists' do
    end

    it 'should create user if provider and uid doesnt exist and email doesnt exist' do
    end

    it 'should not create user if provider and uid doesnt exist but email already does' do
    end
  end
end
