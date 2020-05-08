require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'association' do
    it { should have_many(:user).through(:user_organization_refs) }
  end

  describe 'validation' do
    it { should validate_presence_of(:payment) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:user) }
  end

  describe 'column_specification' do
    it { should have_db_column(:payment).of_type(:integer).with_options(length: { minimum: 0 }, presence: true, uniqueness: true) }
    it { should have_db_column(:name).of_type(:string).with_options(length: { minimum: 1, maximum: 100 }) }
  end
end
