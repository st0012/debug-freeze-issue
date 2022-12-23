# Debugger Frozen With Timeout Issue Repro

## Steps

1. Run `bundle install`
1. Run `bundle exec rails s`
1. Visit `http://localhost:3000/` in the browser
1. Once inside the breakpoint, execute the `timeout` method in the console, which should print `Timeout.timeout`
1. Type `timeout` again. But this time, `Timeout.timeout` wouldn't be printed and the debugger just freezes

```
Processing by HelloController#hello as HTML
[1, 10] in ~/projects/debug-freeze-issue/app/controllers/hello_controller.rb
     1| class HelloController < ApplicationController
     2|   def hello
     3|     Timeout.timeout(3600) do
=>   4|       binding.b
     5|     end
     6|   end
     7|
     8|   def timeout
     9|     Timeout.timeout(1) { puts "Timeout.timeout" }
    10|   end
=>#0    block in hello at ~/projects/debug-freeze-issue/app/controllers/hello_controller.rb:4
  #1    block {|exc=#<Timeout::Error: Timeout::Error>|} in timeout at ~/.gem/ruby/3.1.2/gems/timeout-0.3.1/lib/timeout.rb:189
  # and 81 frames (use `bt' command for all frames)
(rdbg) timeout
Timeout.timeout
nil
(rdbg) timeout
# just freezes from here
```


### Notes

- Occasionally it'd work fine (1 in 5~6 tries), but most of the time it'd freeze.
- Hit Arrrow Up a few times inside the console could also reproduce it.
    - This is because that key triggers the `reline` library's call, which uses `Timeout.timeout` underneath.

    ```
    [1, 10] in ~/projects/debug-freeze-issue/app/controllers/hello_controller.rb
        1| class HelloController < ApplicationController
        2|   def hello
        3|     Timeout.timeout(3600) do
    =>   4|       binding.b
        5|     end
        6|   end
        7|
        8|   def timeout
        9|     Timeout.timeout(1) { puts "Timeout.timeout" }
        10|   end
    =>#0    block in hello at ~/projects/debug-freeze-issue/app/controllers/hello_controller.rb:4
    #1    block {|exc=#<Timeout::Error: Timeout::Error>|} in timeout at ~/.gem/ruby/3.1.2/gems/timeout-0.3.1/lib/timeout.rb:189
    # and 81 frames (use `bt' command for all frames)
    (ruby) q!^[[A^[[A^[[A
    # freezes
    ```
