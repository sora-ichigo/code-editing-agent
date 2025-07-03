#frozen_string_literal: true

require 'minitest/autorun'
require_relative 'calculator'

class TestCalculator < Minitest::Test
  def setup
    @calculator = Calculator.new
  end

  def test_calculator_inherits_from_ruby_llm_tool
    assert_kind_of RubyLLM::Tool, @calculator
  end

  def test_calculator_has_description
    assert_equal "基本的な四則演算を実行するツール", Calculator.description
  end

  def test_calculator_has_expression_parameter
    params = Calculator.parameters
    assert params.key?(:expression)
    assert_equal "計算式（例：2+3、10-5、4*6、20/4）", params[:expression].description
  end

  def test_addition
    result = @calculator.execute(expression: "2 + 3")
    assert_equal "2 + 3 = 5", result
  end

  def test_subtraction
    result = @calculator.execute(expression: "10 - 5")
    assert_equal "10 - 5 = 5", result
  end

  def test_multiplication
    result = @calculator.execute(expression: "4 * 6")
    assert_equal "4 * 6 = 24", result
  end

  def test_division
    result = @calculator.execute(expression: "20 / 4")
    assert_equal "20 / 4 = 5", result
  end

  def test_division_with_integer_result
    result = @calculator.execute(expression: "10 / 3")
    assert_equal "10 / 3 = 3", result
  end

  def test_complex_expression
    result = @calculator.execute(expression: "2 + 3 * 4")
    assert_equal "2 + 3 * 4 = 14", result
  end

  def test_expression_with_parentheses
    result = @calculator.execute(expression: "(2 + 3) * 4")
    assert_equal "(2 + 3) * 4 = 20", result
  end

  def test_invalid_expression
    assert_raises(ArgumentError) do
      @calculator.execute(expression: "2 + + 3")
    end
  end

  def test_division_by_zero
    assert_raises(ZeroDivisionError) do
      @calculator.execute(expression: "10 / 0")
    end
  end
end