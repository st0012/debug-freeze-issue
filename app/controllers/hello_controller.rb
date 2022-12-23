class HelloController < ApplicationController
  def hello
    Timeout.timeout(3600) do
      binding.b
    end
  end

  def timeout
    Timeout.timeout(1) { puts "Timeout.timeout" }
  end
end
