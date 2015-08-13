FactoryGirl.define do

  factory :comment do
    comment { Faker::Lorem.characters 250 }
    spot
    user
    design
  end
end
