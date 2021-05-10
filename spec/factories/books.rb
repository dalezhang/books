FactoryBot.define do
  factory :book do
    name {  FFaker::Book.title }
    count { 10 }
  end
end
