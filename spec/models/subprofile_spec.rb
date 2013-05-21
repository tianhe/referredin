require 'spec_helper'

describe Subprofile do
  let!(:subprofile) { FactoryGirl.create(:subprofile) }

  context '#find_profile' do
    it 'should return profile if subprofile is connected to a profile' do
      subprofile.find_profile.should == subprofile.profile
    end

    it 'should return profile if subprofile has the same first_name, last_name, and location' do
      f_subprofile = Subprofile.create(first_name: subprofile.first_name, last_name: subprofile.last_name, location: subprofile.location, provider: 'facebook')
      f_subprofile.profile = nil
      f_subprofile.find_profile.should == subprofile.profile
    end

    it 'should return nil if there is no match' do
      f_subprofile = Subprofile.create
      f_subprofile.profile = nil
      Profile.destroy_all
      f_subprofile.find_profile.should == nil
    end
  end

  context '#create_or_update_profile' do
    it 'should update an existing profile if the subprofile matches' do
      Profile.count.should == 1
      subprofile.update_attributes(country: 'az')
      Profile.count.should == 1
    end

    it 'should create a profile if the subprofile doesnt match to an existing one' do
      Profile.count.should == 1
      FactoryGirl.create(:subprofile, first_name: 'mark', provider: 'facebook')
      Profile.count.should == 2
    end
  end

end
