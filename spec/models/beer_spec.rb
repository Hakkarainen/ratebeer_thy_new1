require 'rails_helper'

RSpec.describe Beer, type: :model do

  #oluen luonti ei onnistu (eli creatella ei synny validia oliota), jos sille ei anneta nimeä
    it "is not saved without a name" do
      beer = Beer.create name:"Karjala"

      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end
  #oluen luonti ei onnistu, jos sille ei määritellä tyyliä
    it "is not saved without a style" do
      beer = Beer.create style:"lager"

      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end

  #oluen luonti onnistuu ja olut tallettuu kantaan jos oluella on nimi ja tyyli asetettuna
    describe "with a proper name and style" do
      let(:beer){ Beer.create name:"Karjala", style:"Lager"}

      it "is saved" do
        expect(beer).to be_valid
        expect(Beer.count).to eq(1)
      end
    end

  end
