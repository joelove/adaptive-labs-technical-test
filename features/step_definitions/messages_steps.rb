Given(/^I am on the message display page$/) do
  visit '/messages/index'
end

Then(/^I should see no messages$/) do
  expect(page).to_not have_css('.message')
end

When(/^I click the "([^"]+?)" link$/) do |link_text|
  click_link link_text
end

Then(/^I should see some messages with handle and sentiment information$/) do
  expect(page).to have_css('.message .message__value')
  expect(page).to have_css('.message .message__handle')
  expect(page).to have_css('.message .message__sentiment')
end

When(/^I click the "([^"]+?)" link twice$/) do |link_text|
  2.times { click_link link_text }
end

Then(/^I should see a message with a message counter of "([1-9][0-9]*)"$/) do |count|
  expect(page).to have_css('.message .message__counter', text: count)
end

Then(/^I should see a message containing "([^"]+?)" that is highlighted$/) do |text|
  expect(page).to have_css('.message.highlight', text: text)
end

Then(/^I should see a message not containing "([^"]+?)" that is not highlighted$/) do |text|
  expect(page).to_not have_css('.message.highlight', text: /^((?!#{text}).)*$/)
end
