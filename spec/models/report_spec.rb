require 'rails_helper'

describe Report, type: :model do
  before { @report = FactoryGirl.build(:report) }
  subject { @report }

  describe "#append" do
    before(:each) do
      @report.data = {
        "collector1" => {
          "output" => "Some random output\n",
          "error" => "",
        },
        "collector2" => {
          "output" => "",
          "error" => "This did not work\n",
        },
      }
    end

    it "appends the supplied data into the datastructure" do
      @report.append "collector2", "error", "It did totally go wrong"

      expect(@report.data["collector2"]["error"]).to eq("This did not work\nIt did totally go wrong\n")
    end

    it "enters new data into the datastructure" do
      @report.append "collector3", "error", "Something new"

      expect(@report.data["collector3"]["error"]).to eq("Something new\n")
    end
  end
end
