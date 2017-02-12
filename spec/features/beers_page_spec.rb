require 'rails_helper'

describe "New Beer" do
  before :each do
    FactoryGirl.create :brewery, name: "Kiljula oy"
    visit new_beer_path
    #save_and_open_page
  end

  it "has empty create-beer form" do

    expect(page).to have_content 'New Beer'
    expect(page).to have_content 'Name'
  end

it "beer is created if a valid name is specified" do
  fill_in('beer_name', with:'Koff')

  expect{
    click_button "Create Beer"
  }.to change{Beer.count}.from(0).to(1)
end

it "beer is not created if the name is not valid" do
  click_button "Create Beer"

  expect(Beer.count).to be(0)
  expect(page).to have_content 'prohibited this beer from being saved:'
  expect(page).to have_content "Name can't be blank"
  end
end