defmodule GuessGame do
  defstruct [:target, :limit, :used, :guess_result, :state, :msg, :max]

  def new(opt \\ []) do
    max = opt[:max] || 100
    limit = opt[:limit] || 10

    %GuessGame{
      target: Enum.random(1..max),
      limit: limit,
      max: max,
      used: 1
    }
  end

  def play(%GuessGame{} = gg) do
    gg =
      gg
      |> guess()

    IO.puts(gg.msg)

    unless gg |> is_over() do
      IO.puts("#{gg.limit - gg.used} guess left.")
      play(%GuessGame{gg | used: gg.used + 1})
    end
  end

  def guess(%GuessGame{} = gg) do
    gg
    |> get_guess_number()
    |> check_guess_result()
  end

  def get_guess_number(%GuessGame{} = gg) do
    %GuessGame{
      gg
      | guess_result:
          IO.gets("Guess the number from 1 to #{gg.max}: ")
          |> String.trim()
          |> Integer.parse()
          |> case do
            {number, ""} when number >= 1 and number <= gg.max -> %{number: number, error: nil}
            _else -> %{number: 0, error: "invalid number"}
          end
    }
  end

  def check_guess_result(%GuessGame{} = gg) do
    cond do
      gg.guess_result.number == gg.target ->
        %GuessGame{gg | state: :over, msg: "Good job! You guessed it!"}

      gg.used == gg.limit ->
        %GuessGame{
          gg
          | state: :over,
            msg: "Sorry. You didn't guess my number. It was: #{gg.target}"
        }

      gg.guess_result.error != nil ->
        %GuessGame{
          gg
          | state: :continue,
            msg: "Your input is invalid! Please put the number during 1 to #{gg.max}."
        }

      gg.guess_result.number < gg.target ->
        %GuessGame{
          gg
          | state: :continue,
            msg: "Oops. Your guess was LOW."
        }

      # else number > target
      true ->
        %GuessGame{
          gg
          | state: :continue,
            msg: "Oops. Your guess was HIGH."
        }
    end
  end

  def is_over(%GuessGame{} = gg) do
    gg.state == :over
  end
end
