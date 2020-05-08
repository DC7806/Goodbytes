require 'rails_helper'

RSpec.describe UserOrganizationRef, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:organization) }
  end
end
