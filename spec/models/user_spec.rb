require "rails_helper"
RSpec.describe User, type: :model do

  it "has valid user" do
    expect(build(:user)).to be_valid
  end

  describe "validations" do
    let(:user){FactoryBot.create :user}

    context "validates name" do
      it "validates presence of name" do
        is_expected.to validate_presence_of(:name)
      end

      it "validates length of name" do
        is_expected.to validate_length_of(:name).is_at_most(50)
      end
    end
  end

  context "associations" do
    it "has many reviews" do
      is_expected.to have_many(:reviews).dependent :destroy
    end

    it "has many likes" do
      is_expected.to have_many(:likes).dependent :destroy
    end

    it "has many comments" do
      is_expected.to have_many(:comments).dependent :destroy
    end

    it "has many suggests" do
      is_expected.to have_many(:suggests).dependent :destroy
    end
  end

  describe "roles" do
    it "are user or admin" do
      is_expected.to define_enum_for(:role).with_values %i(user admin)
    end
  end
end
