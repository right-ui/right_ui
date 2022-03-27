# RightUI

A simple component library for [Phoenix LiveView](https://github.com/phoenixframework/phoenix_live_view).

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

### Emulate the coming API

Before, I had [an idea about how to declare attributes for components](https://github.com/petalframework/petal_components/issues/27).

This library is a possible implementation of that idea.

### Component Types

#### Basic components

> These components do not cross-call each other.

- element
- icon

#### High-order components

> These components are built on the basic components.

- navigation
- ...

### Attr Names

- the name of a `:function` attr should be prefixed with `fn_`.
- the name of a `:rest` attr should be `extra`.
- the normal attrs should be placed at the end of list of attrs. For example:
  - component-specified attrs
  - `class`
  - `inner_block`
  - `extra`

### How to expose component

- every module uses `__using__/1` for describing what it exposes.

## Acknowledgements

Inspired by:

- [Petal Components](https://github.com/petalframework/petal_components)
- [MUI](https://mui.com/)

Built on:

- [Phoenix LiveView](https://github.com/phoenixframework/phoenix_live_view)
- [TailwindCSS](https://tailwindcss.com/)
- [TailwindUI](https://tailwindui.com/)
- [Adept.Svg](https://github.com/adept-bits/adept_svg)
- [Heroicons](https://heroicons.com/)
