defmodule KevalaExerciseTest do
  use ExUnit.Case
  doctest KevalaExercise
  @raw_duplicate_phonenumbers ["John,Doe,jdoe@example.com,111-111-1111\n", "Johnie,D,johnied@example.com,111-111-1111\n"]
  @raw_duplicate_emails ["John,Doe,jd@example.com,111-111-1112\n", "Johnie,D,jd@example.com,111-111-1111\n"]
  @raw_invalid ["John,Doe,jd@example.com,111-111-1112\n", "Johnie,111-111-1111\n"]

  @duplicate_phonenumbers [["John", "Doe", "jdoe@example.com", "111-111-1111"], ["Johnie", "D", "johnied@example.com", "111-111-1111"]]
  @duplicate_emails [["John", "Doe", "jd@example.com", "111-111-1112"], ["Johnie", "D", "jd@example.com", "111-111-1111"]]

  test "process_stream/2 with duplicate phone numbers" do
    first_record = List.first(@raw_duplicate_phonenumbers)
    [^first_record] = 
      @raw_duplicate_phonenumbers
      |> KevalaExercise.process_stream(:phone)
      |> Enum.to_list()
  end

  test "process_stream/2 with duplicate emails" do
    first_record = List.first(@raw_duplicate_emails)
    [^first_record] = 
      @raw_duplicate_emails
      |> KevalaExercise.process_stream(:email)
      |> Enum.to_list()
  end

  test "process_stream/2 with invalid record" do
    first_record = List.first(@raw_invalid)
    [^first_record] = 
      @raw_invalid
      |> KevalaExercise.process_stream(:email)
      |> Enum.to_list()
  end

  test "dedupe/2 with :phone strategy dedupes duplicate phonenumbers" do
    first_record = List.first(@duplicate_phonenumbers)
    [^first_record] = 
      @duplicate_phonenumbers
      |> KevalaExercise.dedupe(:phone)
  end

  test "dedupe/2 with :email_or_phone strategy dedupes duplicate phonenumbers" do
    first_record = List.first(@duplicate_phonenumbers)
    [^first_record] = 
      @duplicate_phonenumbers
      |> KevalaExercise.dedupe(:email_or_phone)
  end

  test "dedupe/2 with :phone strategy preserves non-duplicates" do
    @duplicate_emails = 
      @duplicate_emails
      |> KevalaExercise.dedupe(:phone)
  end

  test "dedupe/2 with :email strategy dedupes duplicate emails" do
    first_record = List.first(@duplicate_emails)
    [^first_record] = 
      @duplicate_emails
      |> KevalaExercise.dedupe(:email)
  end

  test "dedupe/2 with :email_or_phone strategy dedupes duplicate emails" do
    first_record = List.first(@duplicate_emails)
    [^first_record] = 
      @duplicate_emails
      |> KevalaExercise.dedupe(:email_or_phone)
  end

  test "dedupe/2 with :email strategy preserves non-duplicates" do
    @duplicate_phonenumbers = 
      @duplicate_phonenumbers
      |> KevalaExercise.dedupe(:email)
  end

  test "dedupe/2 with unknown strategy preserves all records" do
    @duplicate_phonenumbers = 
      @duplicate_phonenumbers
      |> KevalaExercise.dedupe(:unknown)
  end
end
