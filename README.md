# Work Logger - generate a simple static webpage for your daily work logs


## Usage
First, clone the project.

Then, write a post somewhere in `priv/years/2022/<your_month>/<day_of_month>.md` (in markdown)

Now, we can generate the page

```elixir
mix do deps.get, compile
mix run "WorkLog.create_index"
# it will overwrite the existing sample post with your content
open priv/index.html
```
