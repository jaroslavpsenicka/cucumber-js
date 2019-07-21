Feature: Never skip

  Using the `--never-skip` flag prevents test from failing even in case of error

  Scenario: --never-skip
    Given a file named "features/a.feature" with:
      """
      Feature:
        Scenario: Failing
          Given a failing step
          Given a passing step
      """
    Given a file named "features/step_definitions/cucumber_steps.js" with:
      """
      import {Given} from 'cucumber'

      Given(/^a failing step$/, function() { throw 'fail' })
      Given(/^a passing step$/, function() {})
      """
    When I run cucumber-js with `--never-skip`
    Then scenario "Failing" step "Given a failing step" has status "failed"
    Then scenario "Failing" step "Given a passing step" has status "passed"
    And it fails
