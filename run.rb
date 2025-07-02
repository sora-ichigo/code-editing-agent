#frozen_string_literal: true

require "ruby_llm"

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
  end

  def run
    puts "Chat with Agent. Type 'exit' to quit."
    loop do
      print "You: "
      user_input = gets.chomp
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

