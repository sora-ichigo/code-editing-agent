#frozen_string_literal: true

require_relative 'calculator'
require 'ruby_llm'

RubyLLM.configure do |config|
  config.bedrock_api_key = ENV.fetch('AWS_ACCESS_KEY_ID', nil)
  config.bedrock_secret_key = ENV.fetch('AWS_SECRET_ACCESS_KEY', nil)
  config.bedrock_region = ENV.fetch('AWS_REGION', nil)
  config.bedrock_session_token = ENV.fetch('AWS_SESSION_TOKEN', nil)
  
  config.default_model = "anthropic.claude-3-haiku-20240307-v1:0"
end

chat = RubyLLM.chat

puts "Calculator tool demo:"
puts "=" * 30

queries = [
  "2+3を計算してください",
  "10から5を引いてください", 
  "4×6の答えは？",
  "20を4で割ってください",
  "2+3*4を計算してください",
  "(2+3)*4を計算してください"
]

queries.each do |query|
  puts "\nQuery: #{query}"
  response = chat.with_tool(Calculator).ask(query)
  puts "Response: #{response.content}"
end