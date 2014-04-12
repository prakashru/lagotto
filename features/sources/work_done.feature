@javascript
Feature: Work done in background
  In order to understand the status of the application
  An admin user
  Should be able to see when background workers are done

  Background:
    Given I am logged in as "admin"
    And the source "Citeulike" exists with 1 worker and a job batch size of 200
    And we have 20 queued articles for "Citeulike"
    And we have 1 worker

    Scenario: Don't see stale articles
      When I go to the "Sources" admin page
      Then I should see 0 stale articles for "Citeulike"

    Scenario: Don't see queued articles
      When I go to the "Sources" admin page
      Then I should see 0 queued articles for "Citeulike"

    Scenario: Don't see jobs
      When I go to the "Sources" admin page
      Then I should see 0 working jobs for "Citeulike"
      And I should see 0 pending jobs for "Citeulike"

    Scenario: Don't see jobs with not enough workers
      Given the source "Citeulike" exists with 1 worker and a job batch size of 10
      When I go to the "Sources" admin page
      Then I should see 0 working jobs for "Citeulike"
      And I should see 0 pending jobs for "Citeulike"