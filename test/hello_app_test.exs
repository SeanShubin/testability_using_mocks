defmodule HelloAppTest do
  use ExUnit.Case
  import Mock

  # https://hexdocs.pm/mock/Mock.html
  # https://github.com/jjh42/mock
  test "say hello to world" do
    monotonic_time_results = [1000, 1234]
    argv_result = ["the-file.txt"]
    file_contents = "world"
    with_mocks(
      [
        {
          System,
          [],
          [
            monotonic_time: [in_series([:microsecond], monotonic_time_results)],
            argv: fn()-> argv_result end
          ]
        },
        {
          IO,
          [],
          [
            puts: fn
              ("Hello, world!")->:ok
              ("Took 234 microseconds")->:ok
              (unexpected) -> flunk("unexpected call: IO.puts(#{inspect unexpected})")
            end
          ]
        },
        {
          File,
          [],
          [
            read!: fn
              ("the-file.txt")->file_contents
              (unexpected) -> flunk("unexpected call: File.read!(#{inspect unexpected})")
            end
          ]
        }
      ]
    ) do
      HelloApp.main()
      assert_called IO.puts("Hello, world!")
      assert_called IO.puts("Took 234 microseconds")
    end
  end
end
