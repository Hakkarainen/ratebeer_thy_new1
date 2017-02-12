require 'rails_helper'
include Helpers

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"
    expect(user.username).to eq("Pekka")
    #user.username.should == "Pekka" (deprecated)
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved if the password is too short " do
    user = User.create username:"Pekka", password: "s1", password_confirmation: "s1"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved if the password contains only letters" do
    user = User.create username:"Pekka", password: "salasana", password_confirmation: "salasana"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end
end

  describe "with a proper password" do
    let!(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      beer = FactoryGirl.create(:beer)
      user.ratings << FactoryGirl.create(:rating, beer:beer, user:user)
      user.ratings << FactoryGirl.create(:rating2, beer:beer, user:user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

    describe "favorite beer" do
      let(:user){FactoryGirl.create(:user) }

      it "has method for determining one" do
        expect(user).to respond_to(:favorite_beer)
      end

      it "without ratings does not have a favorite beer" do
        expect(user.favorite_beer).to eq(nil)
      end

      it "is the only rated if only one rating" do
        beer = create_beer_with_rating(user, 10)

        expect(user.favorite_beer.beer).to eq(beer.id)
      end

      it "is the one with highest rating if several rated" do
        create_beers_with_ratings(user, 10, 20, 15, 7, 9)
        best = create_beer_with_rating(user, 25)

        expect(user.favorite_beer).to eq(best)
      end
  end

def create_beers_with_ratings(user, *scores)
  scores.each do |score|
    create_beer_with_rating user, score
  end
end

def create_beer_with_rating(user, score)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, beer:beer, user:user)
end