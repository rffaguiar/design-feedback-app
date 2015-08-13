FactoryGirl.define do
  factory :design do
    title { Faker::Name.first_name }
    subtitle { Faker::Lorem.sentence }
    link { Faker::Lorem.characters 8 }
    image_path "image_path/saf/hahaha.jpg"
    image_thumb_path "image_path/saf/hahaha-thumb.jpg"
    user

    factory :design_with_spots do
      transient do
        spots_count 2
      end

      after(:create) do |design, evaluator|
        create_list(:spot, evaluator.spots_count, design: design)
      end
    end

  end
end
