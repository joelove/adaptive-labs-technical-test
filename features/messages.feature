Feature: Display messages page

  Background:
    Given I am on the message display page

  Scenario: Messages are displayed
    Then I should see some messages with handle and sentiment information
    And I should see a message with a message counter of "2"

  Scenario: Messages containing specific keywords should be highlighted
    Then I should see a message containing "coke" that is highlighted

  Scenario: Messages not containing specific keywords should not be highlighted
    Then I should see a message not containing "coke" that is not highlighted
