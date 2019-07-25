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
      var cucumberSteps = function() {
        this.When(/^a failing step$/, function() { throw 'fail' });
        this.When(/^a passing step$/, function() { });
      };
      module.exports = cucumberSteps;
      """
    When I run cucumber-js with `--never-skip`
    Then it outputs this text:
      """
      Feature:

        Scenario: Failing
        ✖ Given a failing step
        ✔ Given a passing step

      Failures:

      1) Scenario: Failing - features/a.feature:2
         Step: Given a failing step - features/a.feature:3
         Step Definition: features/step_definitions/cucumber_steps.js:2
         Message:
           fail

      1 scenario (1 failed)
      2 steps (1 failed, 1 passed)
      <duration-stat>
      """
    And the exit status should be 1
