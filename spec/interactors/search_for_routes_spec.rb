require 'rails_helper'

RSpec.describe SearchForRoutes do
  let(:source) { create(:city) }
  let(:destination) { create(:city) }
  let(:start_station) { create :station, city: source }
  let(:finish_station) { create :station, city: destination }
  let!(:route) do
    create(:route, start_station: start_station,
                   finish_station: finish_station)
  end

  let(:result) { described_class.call(start_city_id: source.id, finish_city_id: destination.id)}

  it "successfully works with good data" do
    expect(result.success?).to be_truthy
  end

  it "returns array" do
    expect(result.routes).not_to be_empty
  end

  it "returns decorated Route object" do
    expect(result.routes.all? { |route| route.respond_to?(:weekdays_str) }).to be_truthy
  end

  it "failes when pass wrong data" do
    expect( described_class.call(start_city_id: "dsd", finish_city_id: nil).failure? ).to be_truthy
  end
end
