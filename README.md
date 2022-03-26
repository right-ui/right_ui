# RightUI

Built on:

- [Phoenix LiveView](https://github.com/phoenixframework/phoenix_live_view)
- [TailwindCSS](https://tailwindcss.com/)
- [TailwindUI](https://tailwindui.com/)

## Usage

Add `RightUI` to your view helpers:

```elixir
use RightUI
```

Build component or live component based on `RightUI.Helper`:

```elixir
use RightUI, :component
```

```elixir
use RightUI, :live_component
```

## About the design

- every module uses `__using__/1` for describing what it exposes.
