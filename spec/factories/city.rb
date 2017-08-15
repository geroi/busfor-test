FactoryGirl.define do
  factory :city do
    name {  FFaker::AddressRU.city }
  end
end
