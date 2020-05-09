require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:organizations).through(:organizations_users) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end

  describe 'column_specification' do
    it { should have_db_column(:email).of_type(:string).with_options(length: { minimum: 1, maximum: 100 }, presence: true, uniqueness: true) }
    it { should have_db_column(:encrypted_password).of_type(:string).with_options(length: { minimum: 6, maximum: 128 }) }
  end
end
