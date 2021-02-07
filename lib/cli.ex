defmodule GuessGame.CLI do
  import GuessGame

  def main(_args \\ []) do
    GuessGame.new()
    |> play()
  end
end
