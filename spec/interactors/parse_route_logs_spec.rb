require 'rails_helper'

RSpec.describe ParseRouteLogs do
  let!(:create_regular_routes) do
    reg_last_week_m_k
    reg_2_last_week_m_k
  end

  let!(:create_irregular_routes) do
    irreg_pre_last_week_m_k
  end

  let(:reg_last_week_m_k) do
    create(:route_log, start_station: moscow_station,
                      finish_station: kiev_station,
                      total_cost: cost,
                      carrier: carrier,
                      currency: currency,
                      departure_date_time: last_week_day,
                      arrival_date_time: last_week_day + 1.day)
  end

  let(:reg_2_last_week_m_k) do
    create(:route_log, start_station: moscow_station,
                        finish_station: kiev_station,
                        total_cost: cost,
                        carrier: carrier,
                        currency: currency,
                        departure_date_time: last_week_day - 1.week,
                        arrival_date_time: last_week_day - 6.days)
  end

  let(:irreg_pre_last_week_m_k) do
    create(:route_log, start_station: moscow_station,
                       finish_station: kiev_station,
                       total_cost: cost,
                       carrier: carrier,
                       currency: currency,
                       departure_date_time: pre_last_week_day)
  end

  let(:currency) { create(:currency) }
  let(:last_week_day) { FFaker::Time.between(1.week.ago, DateTime.now).to_datetime }
  let(:pre_last_week_day) { FFaker::Time.between(15.days.ago, last_week_day - 7.day).to_datetime }
  let(:moscow) { create(:city, name: "Moscow") }
  let(:moscow_station) { create(:station, city: moscow) }
  let(:kiev) { create(:city, name: "Kiev") }
  let(:kiev_station) { create(:station, city: kiev) }
  let(:carrier) { create(:carrier)}
  let(:cost) { 500 }

  let!(:result) { described_class.call }

  it "should successfully exit" do
    expect(result.success?).to be_truthy
  end

  it "should create only regular route" do
    expect(Route.count).to eq 1
  end
end
