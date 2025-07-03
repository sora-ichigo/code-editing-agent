#frozen_string_literal: true

require "ruby_llm"

class Calculator < RubyLLM::Tool
  description "基本的な四則演算を実行するツール"
  
  param :expression, desc: "計算式（例：2+3、10-5、4*6、20/4）"
  
  def execute(expression:)
    tokens = tokenize(expression)
    result = evaluate(tokens)
    "#{expression} = #{result}"
  end
  
  private
  
  def tokenize(expression)
    expression.scan(/\d+|[+\-*\/()]/).map do |token|
      if token =~ /^\d+$/
        token.to_i
      else
        token
      end
    end
  end
  
  def evaluate(tokens)
    postfix = infix_to_postfix(tokens)
    evaluate_postfix(postfix)
  end
  
  def infix_to_postfix(tokens)
    output = []
    operators = []
    precedence = { '+' => 1, '-' => 1, '*' => 2, '/' => 2 }
    
    tokens.each do |token|
      case token
      when Integer
        output << token
      when '('
        operators << token
      when ')'
        while operators.last != '('
          output << operators.pop
        end
        operators.pop
      when '+', '-', '*', '/'
        while operators.any? && operators.last != '(' && 
              precedence[operators.last].to_i >= precedence[token]
          output << operators.pop
        end
        operators << token
      end
    end
    
    output.concat(operators.reverse)
  end
  
  def evaluate_postfix(postfix)
    stack = []
    
    postfix.each do |token|
      case token
      when Integer
        stack << token
      when '+', '-', '*', '/'
        b = stack.pop
        a = stack.pop
        
        raise ArgumentError, "無効な計算式です" if a.nil? || b.nil?
        
        result = case token
        when '+'
          a + b
        when '-'
          a - b
        when '*'
          a * b
        when '/'
          raise ZeroDivisionError, "ゼロで除算することはできません" if b == 0
          a / b
        end
        
        stack << result
      end
    end
    
    raise ArgumentError, "無効な計算式です" if stack.size != 1
    stack.first
  end
end