# KevalaExercise
Solution to the Kevala Interview Homework by Edward Smith.

## Installation Instrutions
To run this code, you can do the following. You will need elixir installed on your system.

```
mix escript.build
./kevala_exercise --file data/test_1.csv --dedupe phone
./kevala_exercise --file data/test_1.csv --dedupe email
./kevala_exercise --file data/test_1.csv --dedupe email_or_phone
```

## Running Tests
You an run the tests by running:
```
mix test
```

# Notes
* If we are de-duping right now but are missing phone numbers or email, only one such record would be preserved right now.
* To reduce unneeded transformations, data is kept as a list. While making the code a bit more specific to the input format, it is likely a bit more efficient (though random access of lists is not ideal, they are short enough it is likely fine)
* The same phone number in different formats will messup de-duplication
* CSV data with quotes around data is not handled well right now
* Technically ordering of deduping on phone or email matters. I made the decision to do phone first.
* Main method isn't currently tested. It has the most side effects and while it could be tested with files, it was skipped in the interest of time (most logic is in other methods)
* Currently handles invalid rows (doesn't split on "," and has length not equal to 4) but only prints a warning
* Adding more examples to the @doc's could add tests through doctest
* Ideally logging would be disabled during tests
