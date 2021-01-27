defmodule KevalaExercise do
  @moduledoc """
  Solution to the Kevala Interview Homework.
  """

  require Logger

  @output_file "./data/output.csv"

  @doc """
  Main entrypoint for the application.
  """
  def main(args) do
    options = [strict: [file: :string, dedupe: :string]]
    {[file: filename, dedupe: dedupe_strategy],_,_}= OptionParser.parse(args, options)
    Logger.info("Processing #{filename} and deduping on #{dedupe_strategy}")

    File.stream!(filename)
    |> process_stream(String.to_atom(dedupe_strategy))
    |> Stream.into(File.stream!(@output_file))
    |> Stream.run()
    Logger.info("Completed. See output at #{@output_file}")
  end

  @doc """
  Processes a stream, deduping based on the specified dedupe strategy

  Example:
    iex> File.stream!("./data/test_1.csv")|> KevalaExercise.process_stream(:phone)
  """
  def process_stream(stream, dedupe_strategy) do
    stream
    |> Stream.map(&String.split(&1, ","))
    |> Stream.reject(&invalid_csv_line(&1))
    |> Stream.map(&Enum.map(&1, fn elem -> String.trim(elem) end))
    |> dedupe(dedupe_strategy)
    |> Stream.map(&Enum.join(&1, ","))
    |> Stream.map(fn s -> s <> "\n" end)
  end

  @doc """
  Dedupes records based on the dupication strategy.

  Example:
    iex> [[1, 1, "jdoe@example.com", 1], [1, 1, "jdoe@example.com", 1]] |> KevalaExercise.dedupe(:email)
    [[1, 1, "jdoe@example.com", 1]]

    iex> [[1, 1, "jdoe1@example.com", 111-111-1111], [1, 1, "jdoe@example.com", 111-111-1111]] |> KevalaExercise.dedupe(:phone)
    [[1, 1, "jdoe1@example.com", 111-111-1111]]

    iex> [[1, 1, "jdoe1@example.com", 111-111-1113], [1, 1, "jdoe1@example.com", 111-111-1111], [1, 1, "jdoe@example.com", 111-111-1111]] |> KevalaExercise.dedupe(:email_or_phone)
    [[1, 1, "jdoe1@example.com", 111-111-1113]]
  """
  def dedupe(stream, :email) do
    stream
    |> Enum.uniq_by(fn [_, _, email, _] -> email  end)
  end
  def dedupe(stream, :phone) do
    stream
    |> Enum.uniq_by(fn [_, _, _, phone] -> phone end)
  end
  def dedupe(stream, :email_or_phone) do
    stream
    |> dedupe(:phone)
    |> dedupe(:email)
  end
  def dedupe(stream, _), do: stream

  defp invalid_csv_line(element) when is_list(element) and length(element) === 4, do: false
  defp invalid_csv_line(element) do
    Logger.warn("Dropping invalid line: `#{element}`")
    true
  end
end
