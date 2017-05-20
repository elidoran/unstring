## 0.3.0 - 2017/05/20

1. reorder constructor to use array's length as default limit; which essentially denies auto-learning by default.
2. add `learn()` which ignores restrictions and learns it. Note, it may override a current known string.
3. adapt tests to default denial and add a test ensuring default denial.
4. add tests for `learn()`
5. update all deps


## 0.2.0 - 2017/04/23

1. return `string()` result as an object so it can specify if the value was known or not
2. adapt the tests for the change


## 0.1.0 - 2017/04/23

1. initial working version with tests, 100% code coverage, and Travis CI
