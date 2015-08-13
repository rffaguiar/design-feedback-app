FactoryGirl.define do
  factory :user do
    name { Faker::Name.first_name + ' ' + Faker::Name.last_name}
    email { Faker::Internet.email }
    password { Faker::Internet.password(8,30)  }

    factory :user_with_singles do
      transient do
        designs_count 3
      end

      after(:create) do |user, evaluator|
        create_list(:design, evaluator.designs_count, user: user)
      end
    end

    factory :user_with_comments do
      transient do
        comments_count 2
      end

      after(:create) do |user, evaluator|
        create_list(:comment, evaluator.comments_count, user: user)
      end
    end

    factory :user_with_spots do
      transient do
        spots_count 3
      end

      after(:create) do |user, evaluator|
        create_list(:spot, evaluator.spots_count, user: user)
      end
    end

    factory :user_with_spots_and_one_comment do
      transient do
        comments_count 1
      end

      after(:create) do |user, evaluator|
        spot = create(:spot, user: user)
        create_list(:comment, evaluator.comments_count, user: user, spot: spot)
      end
    end

    factory :user_with_spots_and_many_comments do
      transient do
        comments_count 5
      end

      after(:create) do |user, evaluator|
        spot = create(:spot, user: user)
        create_list(:comment, evaluator.comments_count, user: user, spot: spot)
      end
    end

  end # factory :user do
end # FactoryGirl.define do
