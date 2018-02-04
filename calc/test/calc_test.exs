defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "find_top_op" do
    assert Calc.find_top_op(["1", "+", "2"]) == 1
    assert Calc.find_top_op(["1", "-", "2", "+", "4"]) == 1
    assert Calc.find_top_op(["1", "-", "2", "*", "4"]) == 3
    assert Calc.find_top_op(["1", "-", "2", "/", "4"]) == 3
    assert Calc.find_top_op(["1", "*", "2", "/", "4"]) == 1
    assert Calc.find_top_op(["1", "/", "2", "*", "4"]) == 1
  end

  test "solve_one_set" do
    assert Calc.solve_one_set(["1", "+", "2"]) == 3
    assert Calc.solve_one_set(["1", "-", "2"]) == -1
    assert Calc.solve_one_set(["1", "/", "2"]) == 0
    assert Calc.solve_one_set(["1", "*", "2"]) == 2
  end

  test "straight_eval" do
    assert Calc.straight_eval(["1", "+", "2"]) == ["3"]
    assert Calc.straight_eval(["3"]) == ["3"]
    assert Calc.straight_eval(["1", "+", "2", "*", "3"]) == ["7"]
    assert Calc.straight_eval(["6", "/", "2", "*", "3"]) == ["9"]
    assert Calc.straight_eval(["1", "+", "3", "*", "3", "+", "1"]) == ["11"]
  end

  test "reduce_helper" do
    assert Calc.reduce_helper("(", {1, 0}) == {2, 1}
    assert Calc.reduce_helper(")", {1, 0}) == {0, 1}
    assert Calc.reduce_helper("a", {1, 0}) == {1, 1}
    assert Calc.reduce_helper("(", {0, 5}) == {0, 5}
  end

  test "find_first_closing_paren" do
    assert Calc.find_first_closing_paren(["3", "+", "2", ")", "*", "(", "2", "+", "1", ")"]) == 4
    assert Calc.find_first_closing_paren(["(", ")", ")"]) == 3
    assert Calc.find_first_closing_paren(["(", ")", "(", ")", ")"]) == 5
  end

  test "eval_logic" do
    assert Calc.eval_logic(["1", "+", "2", "*", "3"]) == ["7"]
    assert Calc.eval_logic(["6", "/", "2", "*", "3"]) == ["9"]
    assert Calc.eval_logic(["24", "/", "6", "+", "(", "5", "-", "4", ")"]) == ["5"]
    assert Calc.eval_logic(["(", "24", "/", "6", "+", "(", "5", "-", "4", ")", ")"]) == ["5"]
  end

  test "eval" do
    assert Calc.eval("((2 + 1) * (24 / 6 + (5 - 4)))") == 15
    assert Calc.eval("2 + 3") == 5
    assert Calc.eval("5 * 1") == 5
    assert Calc.eval("20 / 4") == 5
    assert Calc.eval("24 / 6 + (5 - 4)") == 5
    assert Calc.eval("1 + 3 * 3 + 1") == 11
  end
end
