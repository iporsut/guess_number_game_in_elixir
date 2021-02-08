defmodule GuessGame do
  defstruct [:target, :limit, :used, :guess_result, :state, :msg, :max]

  def new(opt \\ []) do
    max = opt[:max] || 100
    limit = opt[:limit] || 10

    %GuessGame{
      target: Enum.random(1..max),
      limit: limit,
      max: max,
      used: 1,
      state: :continue
    }
  end

  def play(%GuessGame{} = gg)
      when gg.state == :over,
      do: gg

  def play(%GuessGame{} = gg) when gg.state == :continue do
    gg
    |> guess()
    |> play()
  end

  def guess(%GuessGame{} = gg) do
    gg
    |> get_guess_number()
    |> check_guess_result()
    |> print_msg()
    |> inc_used()
  end

  def print_msg(%GuessGame{msg: msg} = gg) do
    IO.puts(msg)
    gg
  end

  def inc_used(%GuessGame{used: used} = gg),
    do: %GuessGame{gg | used: used + 1}

  def get_guess_number(%GuessGame{} = gg) do
    guess_result =
      IO.gets("Guess the number from 1 to #{gg.max}: ")
      |> String.trim()
      |> Integer.parse()
      |> case do
        {number, ""}
        when number >= 1 and number <= gg.max ->
          %{number: number, error: nil}

        _else ->
          %{number: 0, error: "invalid number"}
      end

    %GuessGame{gg | guess_result: guess_result}
  end

  def check_guess_result(%GuessGame{} = gg)
      when gg.guess_result.number == gg.target,
      do: %GuessGame{gg | state: :over, msg: "Good job! You guessed it!"}

  def check_guess_result(%GuessGame{} = gg)
      when gg.used == gg.limit,
      do: %GuessGame{
        gg
        | state: :over,
          msg: "Sorry. You didn't guess my number. It was: #{gg.target}"
      }

  def check_guess_result(%GuessGame{} = gg)
      when gg.guess_result.error != nil,
      do: %GuessGame{
        gg
        | state: :continue,
          msg:
            "Your input is invalid! Please put the number during 1 to #{gg.max}.\n#{
              gg.limit - gg.used
            } guess left."
      }

  def check_guess_result(%GuessGame{} = gg)
      when gg.guess_result.number < gg.target,
      do: %GuessGame{
        gg
        | state: :continue,
          msg: "Oops. Your guess was LOW.\n#{gg.limit - gg.used} guess left."
      }

  def check_guess_result(%GuessGame{} = gg)
      when gg.guess_result.number > gg.target,
      do: %GuessGame{
        gg
        | state: :continue,
          msg: "Oops. Your guess was HIGH.\n#{gg.limit - gg.used} guess left."
      }

  def is_over(%GuessGame{} = gg),
    do: gg.state == :over
end
