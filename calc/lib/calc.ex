defmodule Calc do
  @moduledoc """
  Documentation for Calc.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Calc.hello
      :world

  """
  def hello do
    :world
  end

  def find_top_op(eq) do
    mul = Enum.find_index(eq, fn x -> x == "*" end)
    div = Enum.find_index(eq, fn x -> x == "/" end)
    add = Enum.find_index(eq, fn x -> x == "+" end)
    sub = Enum.find_index(eq, fn x -> x == "-" end)

    cond do
      (mul != nil && div == nil) || (mul != nil && mul < div) ->
        mul

      div != nil ->
        div

      (add != nil && sub == nil) || (add != nil && add < sub) ->
        add

      sub != nil ->
        sub
    end
  end

  def solve_one_set([a, op, b]) do
    a = Integer.parse(a) |> elem(0)
    b = Integer.parse(b) |> elem(0)

    case op do
      "*" -> a * b
      "/" -> div(a, b)
      "+" -> a + b
      "-" -> a - b
    end
  end

  # there are no more parens when we reach this function
  def straight_eval(eq) do
    cond do
      length(eq) == 1 ->
        eq

      true ->
        priority_op_pos = find_top_op(eq)
        a = Enum.at(eq, priority_op_pos - 1)
        op = Enum.at(eq, priority_op_pos)
        b = Enum.at(eq, priority_op_pos + 1)

        answer_for_one_set =
          solve_one_set([a, op, b])
          |> Integer.to_string()

        beginning = Enum.split(eq, priority_op_pos - 1) |> elem(0)
        ending = Enum.split(eq, priority_op_pos + 2) |> elem(1)

        straight_eval(beginning ++ [answer_for_one_set] ++ ending)
    end
  end

  def reduce_helper(x, acc) do
    if elem(acc, 0) == 0 do
      acc
    else
      case x do
        "(" -> {elem(acc, 0) + 1, elem(acc, 1) + 1}
        ")" -> {elem(acc, 0) - 1, elem(acc, 1) + 1}
        _ -> {elem(acc, 0), elem(acc, 1) + 1}
      end
    end
  end

  def find_first_closing_paren(eq) do
    eq
    |> Enum.reduce({1, 0}, fn x, acc -> reduce_helper(x, acc) end)
    |> elem(1)
  end

  def eval_logic(eqL) do
    first_open_paren = Enum.find_index(eqL, fn x -> x == "(" end)

    case first_open_paren do
      nil ->
        straight_eval(eqL)

      _ ->
        first_close_paren =
          eqL
          |> Enum.split(first_open_paren + 1)
          |> elem(1)
          |> find_first_closing_paren
          |> Kernel.+(1)
          |> Kernel.+(first_open_paren)

        beginning = Enum.split(eqL, first_open_paren) |> elem(0)

        ending =
          eqL
          |> Enum.split(first_close_paren)
          |> elem(1)

        first_paren_set_answer =
          eqL
          |> Enum.split(first_close_paren - 1)
          |> elem(0)
          |> Enum.split(first_open_paren + 1)
          |> elem(1)
          |> eval_logic

        eval_logic(beginning ++ first_paren_set_answer ++ ending)
    end
  end

  def eval(eq) do
    eq
    |> String.trim()
    |> String.replace("(", "( ")
    |> String.replace(")", " )")
    |> String.split()
    |> eval_logic
    |> Enum.at(0)
    |> Integer.parse()
    |> elem(0)
  end

  def main do
    IO.gets("Enter a valid arithmetic expression\n")
    |> eval()
    |> IO.puts()

    main
  end
end

# Calc.eval("2 + 3")

# calc$ mix run -e Calc.main
# > 2 + 3
# 5
# > 5 * 1
# 5
# > 20 / 4
# 5
# > 24 / 6 + (5 - 4)
# 5
# > 1 + 3 * 3 + 1
# 11
# > ^C^C
