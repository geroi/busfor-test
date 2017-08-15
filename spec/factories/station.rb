FactoryGirl.define do
  factory :station do
    sequence :name do |n|
      "Станция #{n}"
    end

    city
  end
end
