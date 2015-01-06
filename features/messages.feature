Feature: Display messages page

  Background:
    Given I am on the message display page

  Scenario: No messages are initially displayed
    Then I should see no messages

  Scenario: Messages are displayed when clicking the "Fetch more messages" link
    When I click the "Fetch more messages" link
    Then I should see some messages with handle and sentiment information

  Scenario: Duplicate messages should increment the appropriate message counter
    When I click the "Fetch more messages" link twice
    Then I should see a message with a message counter of "2"

  Scenario: Messages containing specific keywords should be highlighted
    When I click the "Fetch more messages" link
    Then I should see a message containing "coke" that is highlighted

  Scenario: Messages not containing specific keywords should not be highlighted
    When I click the "Fetch more messages" link
    Then I should see a message not containing "coke" that is not highlighted
