#frozen_string_literal: true

require "ruby_llm"
require_relative "calculator"

RubyLLM.configure do |config|
    config.bedrock_api_key = ENV.fetch('AWS_ACCESS_KEY_ID', nil)
    config.bedrock_secret_key = ENV.fetch('AWS_SECRET_ACCESS_KEY', nil)
    config.bedrock_region = ENV.fetch('AWS_REGION', nil) # e.g., 'us-west-2'
    config.bedrock_session_token = ENV.fetch('AWS_SESSION_TOKEN', nil) # For temporary credentials

    config.default_model = "anthropic.claude-3-haiku-20240307-v1:0"
end

class Agent
  def initialize
    @chat = RubyLLM.chat
    @chat.with_tools(Calculator)

    @chat.on_end_message do |message|
      if message.tool_call?
        # AIエージェントのメッセージを表示
        if message.content && !message.content.empty?
          puts "Agent: #{message.content}"
        end
        
        puts ""
        puts "ツールを実行します"
        message.tool_calls.each do |tool_call|
          puts "ツール名: #{tool_call.last.name}"
          puts "引数: #{tool_call.last.arguments}"
        end
        puts ""
      end
    end
  end

  def run
    puts "Chat with Agent. Type 'exit' to quit."
    loop do
      print "You: "
      user_input = ""
      while line = gets
        user_input += line
        break if line.chomp.empty? # Break on empty line
      end

      break if user_input.downcase == 'exit'

      response = @chat.ask user_input
      puts "Agent: #{response.content}"
    end
  end
end

if __FILE__ == $0
  agent = Agent.new
  agent.run
end

