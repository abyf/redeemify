FactoryGirl.define do
  factory :user do
    provider "google_oauth2"
    uid "12345"
    name "user"
    email "user@domain.com"
  end
end