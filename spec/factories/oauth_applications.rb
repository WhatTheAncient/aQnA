FactoryBot.define do
  factory :oauth_application, class: 'Doorkeeper::Application' do
    name { 'Test' }
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
    uid { '122345345678' }
    secret { '876543245321' }
  end
end
