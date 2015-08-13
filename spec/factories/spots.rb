FactoryGirl.define do

  factory :spot do
    x_pos { Faker::Number.positive(0, 1400).to_s } # must be lazy because just one spot can occupy the same space (x_pos, y_pos)
    y_pos { Faker::Number.positive(0, 1400).to_s } # must be lazy because just one spot can occupy the same space (x_pos, y_pos)
    user
    design

    factory :spot_with_comments do
      transient do
        comments_count 3
      end

      after(:create) do |spot, evaluator|
        create_list(:comment, evaluator.comments_count, spot: spot)
      end
    end

    factory :spot_with_one_comment do
      transient do
        comments_count 1
      end

      after(:create) do |spot, evaluator|
        create_list(:comment, evaluator.comments_count, spot: spot)
      end
    end

  end
end
