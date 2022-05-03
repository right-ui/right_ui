defmodule RightUI.AttrError do
  defexception [:message]

  @impl true
  def exception({:required, name}) do
    message = "attr #{inspect(name)} is required"
    %__MODULE__{message: message}
  end

  @impl true
  def exception({:bad_type, name, type}) do
    message = "the value of attr #{inspect(name)} should be of type #{inspect(type)}"
    %__MODULE__{message: message}
  end

  @impl true
  def exception({:bad_enum_value, name, values}) do
    message = "the value of attr #{inspect(name)} should be one of #{inspect(values)}"
    %__MODULE__{message: message}
  end
end

defmodule RightUI.Helper do
  import Phoenix.LiveView, only: [assign: 3, assign_new: 3]
  import Phoenix.LiveView.Helpers, only: [assigns_to_attributes: 2]

  alias RightUI.AttrError

  @key_for_excluded_keys :__excluded_keys__

  @doc """
  Emulate the official API which is coming soon.

  Read more at https://github.com/phoenixframework/phoenix_live_view/pull/1747

  ## Example

  ```elixir
  def button(assigns) do
    assigns =
      assigns
      |> attr(:class, :string)
      |> attr(:extra, :rest)
      |> attr_done()

    ~H\"\"\"
    <button class={@class} {@extra}>
      <%= render_slot(@inner_block) %>
    </table>
    \"\"\"
  end
  ```

  ## Supported types

  + `:integer`
  + `:float`
  + `:number`
  + `:boolean`
  + `:atom`
  + `:string`
  + `:list`
  + `:map`
  + `:function`
  + `:slot`
  + `:enum` with `:values` option
  + `:rest` with `:exclude` option
  + `:any`

  ## Options

  + `:required`
  + `:default`
  + `:values` - only useful for `:enum` type.
  + `:exclude` - only useful for `:rest` type.

  """
  def attr(assigns, name, type, opts \\ []) do
    required = Keyword.get(opts, :required, false)
    default = Keyword.get(opts, :default, default_of(type))

    assigns =
      if required do
        if Map.has_key?(assigns, name) do
          assigns
        else
          raise AttrError, {:required, name}
        end
      else
        assign_new(assigns, name, fn -> default end)
      end

    assigns = set_excluded_key(assigns, name)

    assigns =
      case type do
        :rest ->
          excluded_keys =
            if manual_excluded_keys = Keyword.get(opts, :exclude) do
              excluded_keys = [@key_for_excluded_keys | manual_excluded_keys]
              [name | excluded_keys]
            else
              get_excluded_keys(assigns)
            end

          rest = assigns_to_attributes(assigns, excluded_keys)
          assign(assigns, name, rest)

        :enum ->
          values = Keyword.fetch!(opts, :values)
          value = Map.get(assigns, name)

          if value in values do
            assigns
          else
            raise AttrError, {:bad_enum_value, name, values}
          end

        :slot ->
          value = Map.get(assigns, name)

          if is_slot(value) do
            assigns
          else
            raise AttrError, {:bad_type, name, type}
          end

        :any ->
          assigns

        expected_type ->
          value = Map.get(assigns, name)

          if type_of(value) == expected_type do
            assigns
          else
            raise AttrError, {:bad_type, name, type}
          end
      end

    assigns
  end

  def attr_done(assigns) do
    clean_excluded_keys(assigns)
  end

  defp set_excluded_key(assigns, name) do
    excluded_keys = get_excluded_keys(assigns)
    Map.put(assigns, @key_for_excluded_keys, [name | excluded_keys])
  end

  defp get_excluded_keys(assigns) do
    Map.get(assigns, @key_for_excluded_keys, [@key_for_excluded_keys])
  end

  defp clean_excluded_keys(assigns) do
    Map.delete(assigns, @key_for_excluded_keys)
  end

  defp type_of(nil), do: :missing

  defp type_of(term) do
    cond do
      is_integer(term) -> :integer
      is_float(term) -> :float
      is_number(term) -> :number
      is_boolean(term) -> :boolean
      is_binary(term) -> :string
      is_function(term) -> :function
      is_map(term) -> :map
      is_list(term) -> :list
      true -> :unknown
    end
  end

  defp is_slot([%{__slot__: _} | []]), do: true
  defp is_slot([%{__slot__: _} | _]), do: true
  defp is_slot(_), do: false

  defp default_of(type) do
    case type do
      :integer ->
        0

      :float ->
        0.0

      :number ->
        0

      :boolean ->
        false

      :string ->
        ""

      :map ->
        %{}

      :list ->
        []

      _ ->
        nil
    end
  end

  @doc """
  """
  def merge_class(old, new) do
    merge_as_simple_value([old, new])
  end

  def merge_class(list) do
    merge_as_simple_value(list)
  end

  defp merge_as_simple_value(list) when is_list(list) do
    list
    |> Enum.map(&String.trim/1)
    |> Enum.join(" ")
    |> String.trim()
  end

  @doc """
  Remove whitespaces from a class string.
  """
  def one_line_class(class) do
    class
    |> String.split(~r/\s+/)
    |> Enum.join(" ")
  end

  # # Currently, this isn't work as expected, I will handle it later.
  # #
  # # If the default class is `text-sm text-neutral-200`, the new is `text-red-200`,
  # # then the final class is `text-red-200`.
  # # As you can see, `text-sm` is removed, which isn't expected.
  # defp merge_as_tailwind_class(default, new) do
  #   default_classes = separate_classes(default)
  #   new_classes = separate_classes(new)

  #   classes =
  #     Enum.reduce(default_classes, new_classes, fn class, acc ->
  #       prefix = tailwind_prefix(class)

  #       if Enum.any?(new_classes, &String.starts_with?(&1, "#{prefix}-")) do
  #         acc
  #       else
  #         [class | acc]
  #       end
  #     end)

  #   Enum.join(classes, " ")
  # end

  # defp separate_classes(classes) do
  #   String.split(classes, ~r{\s+}, trim: true)
  # end

  # defp tailwind_prefix(class) do
  #   [prefix | _] = String.split(class, "-", parts: 2)
  #   prefix
  # end
end
