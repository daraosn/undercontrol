FactoryGirl.define do
  factory :thing do
    user_id 1
    api_key "MyString"
    name "MyString"
    description "MyString"
    sensor_type "MyString"
    unit "MyString"
    alarm_max "9.99"
    alarm_min "9.99"
    alarm_threshold 1
    alarm_triggered false
    alarm_action "MyString"
    range_min "9.99"
    range_max "9.99"
  end
end
