FactoryGirl.define do
  factory :route_log do
    association :start_station, factory: :station
    association :finish_station, factory: :station
    departure_date_time {  FFaker::Time.between(1.week.ago, Date.yesterday).to_datetime }
    arrival_date_time { FFaker::Time.between(departure_date_time, departure_date_time + 1.day).to_datetime }
    carrier
    currency
    total_cost { rand(0..1000)}
  end
end
