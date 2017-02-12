require 'rails_helper'
include Helpers

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:beer3) { FactoryGirl.create :beer, name:"Karjala", brewery:brewery }

  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
    end
  end

  describe "ratings done" do
    let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
    let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
    let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
    let!(:beer3) { FactoryGirl.create :beer, name:"Karjala", brewery:brewery }
    let!(:user) { FactoryGirl.create :user }

    before :each do
      FactoryGirl.create :rating, user:user, beer:beer1, score:10
      FactoryGirl.create :rating, user:user, beer:beer2, score:20
      FactoryGirl.create :rating, user:user, beer:beer3, score:30
      end
    it "lists the ratings and their total number" do
    visit ratings_path
    #save_and_open_page

    expect(page).to have_content "Number of ratings: #{Rating.count}"
    expect(Rating.count).to eq(3)
    expect(page).to have_content "iso 3 10"
    expect(page).to have_content "Karhu 20"
    expect(page).to have_content "Karjala 30"
    end

    it "only all own ratings are shown on raters page" do
      timo = FactoryGirl.create :user, username: "Timo"
      FactoryGirl.create :rating, user:timo, beer:beer3, score:40
      visit user_path(user)
      #save_and_open_page

      expect(page).to have_content "iso 3 10"
      expect(page).to have_content "Karhu 20"
      expect(page).to have_content "Karjala 30"
      expect(page).not_to have_content "Karjala 40"
    end

    it "if the rater deletes one of his ratings, it is removed from the database too" do
      sign_in(username:"Pekka", password:"Foobar1")
      visit user_path(user)
      #save_and_open_page

    expect{
      page.all('a', text:"delete")[1].click
    }.to change{Rating.count}.by(-1)
  end
  end