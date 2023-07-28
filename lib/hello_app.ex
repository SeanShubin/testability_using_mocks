# mix run -e HelloApp.main -- greeting-target.txt
defmodule HelloApp do
  def main() do
    time_unit = :microsecond
    microseconds_before = System.monotonic_time time_unit
    target = System.argv |> List.first |> File.read!
    IO.puts "Hello, #{target}!"
    microseconds_after = System.monotonic_time time_unit
    microseconds_duration = microseconds_after - microseconds_before
    IO.puts "Took #{microseconds_duration} microseconds"
  end
end
