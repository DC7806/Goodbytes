require 'rails_helper'

RSpec.describe OrganizationsUser, type: :model do
  describe 'association' do
    it { should belong_to(:user) }
    it { should belong_to(:organization) }
  end

  describe 'validation' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:organization) }
  end
end
