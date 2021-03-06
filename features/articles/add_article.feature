@javascript
Feature: Add article
  In order to collect metrics
  A user
  Should be able to add an article

    Background:
      Given I am logged in as "admin"

    Scenario: Article is added succesfully
      When I add an article with DOI "10.1371/journal.pone.000001", year "2012", month "8", day "13" and title "Research Blogs and the Discussion of Scholarly Information"
      Then I should see an article with title "Research Blogs and the Discussion of Scholarly Information"

    Scenario: Article is missing title
      When I add an article with DOI "10.1371/journal.pone.000001", year "2012", month "8", day "13" and title ""
      Then I should see the error message "can't be blank"

    Scenario: Article with invalid date
      When I add an article with DOI "10.1371/journal.pone.000001", year "2012", month "2", day "30" and title "Research Blogs and the Discussion of Scholarly Information"
      Then I should see the error message "is not a valid date"
