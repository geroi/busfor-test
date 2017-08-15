FactoryGirl.define do
  factory :route do
    association :start_station, factory: :station
    association :finish_station, factory: :station
    carrier
    departure_hours { (0..23).to_a.shuffle[0] }
    departure_minutes { (0..59).to_a.shuffle[0] }
    arrival_hours { (0..23).to_a.shuffle[0] }
    arrival_minutes { (0..59).to_a.shuffle[0] }
    everyday


    trait :mon do
      monday true
    end

    trait :tue do
      tuesday true
    end

    trait :wed do
      wednesday true
    end

    trait :thu do
      thursday true
    end

    trait :fri do
      friday true
    end

    trait :sat do
      saturday true
    end

    trait :sun do
      sunday true
    end

    trait :everyday do
      mon; tue; wed; thu; fri; sat; sun
    end
  end
end
