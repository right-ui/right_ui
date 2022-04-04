defmodule RightUI.Element.Form do
  @moduledoc """
  Wrap the functions provided by `Phoenix.HTML.Form`.

  ## Ignored functions

  ### invisible ones

  + `hidden_input`
  + `options_for_select`

  ### helpers

  + `humanize`
  + `input_id`
  + `input_name`
  + `input_type`
  + `input_value`
  + `input_validations`
  + `inputs_for`

  ## TODO

  ### from `Phoenix.HTML.Form`

  + radio_button
  + time_select
  + date_select
  + datetime_select

  ### From Petal Components

  + `radio_group`
  + `checkbox_group`

  """

  use RightUI, :component

  import Phoenix.HTML.Form,
    only: [
      input_id: 2,
      input_id: 3,
      input_name: 2,
      input_value: 2,
      humanize: 1
    ]

  @generic_inputs [
    :text_input,
    :email_input,
    :number_input,
    :password_input,
    :url_input,
    :search_input,
    :telephone_input,
    :color_input,
    :range_input,
    :time_input,
    :date_input,
    :datetime_local_input,
    :textarea,
    :file_input,
    :checkbox
  ]

  @select_inputs [
    :select,
    :multiple_select
  ]

  defmacro __using__(_) do
    quote do
      import RightUI.Element.Form,
        only:
          [input_label: 1, error: 1, form_field: 1] ++
            Enum.map(@generic_inputs, &{&1, 1}) ++
            Enum.map(@select_inputs, &{&1, 1})
    end
  end

  @doc """
  Generates a input label tag.

  > Because `label/1` has been occupied to `Phoenix.HTML.Form.label/1`, `input_label/1`
  > is used at here.

  ## Examples

      <.input_label class="...">...</.input_label>
      #=> <label class="...">...</label>

      # Assuming form contains a User schema
      <.input_label form={form} field={:name} class="...">...</.input_label>
      #=> <label for="user_name" class="...">...</label>

      <.input_label form={:user} field={:name} class="...">...</.input_label>
      #=> <label for="user_name" class="...">...</label>

      <.input_label form={:user} field={:role} value="admin" class="...">...</.input_label>
      #=> <label for="user_role_admin" class="...">...</label>

  """
  def input_label(assigns) do
    if assigns[:form] && assigns[:field] do
      render_label_with_form_and_field(assigns)
    else
      render_label_without_form_or_field(assigns)
    end
  end

  defp render_label_without_form_or_field(assigns) do
    assigns =
      assigns
      |> attr(:class, :string)
      |> attr(:inner_block, :slot, required: true)
      |> attr(:extra, :rest)
      |> attr_done()

    ~H"""
    <label class={merge_class([class_label(), @class])} {@extra}>
      <%= render_slot(@inner_block) %>
    </label>
    """
  end

  defp render_label_with_form_and_field(assigns) do
    assigns =
      assigns
      |> attr(:form, :any)
      |> attr(:field, :any)
      |> attr(:value, :any, default: input_value(assigns.form, assigns.field))
      |> attr(:id, :string,
        default:
          if(assigns[:value],
            do: input_id(assigns.form, assigns.field, assigns[:value]),
            else: input_id(assigns.form, assigns.field)
          )
      )
      |> attr(:name, :string, default: input_name(assigns.form, assigns.field))
      |> attr(:class, :string)
      |> attr(:inner_block, :any)
      |> attr(:extra, :rest)
      |> attr_done()

    ~H"""
    <label for={@id} phx-feedback-for={@name} class={merge_class([class_label(), @class])} {@extra}>
      <%= if @inner_block do %>
        <%= render_slot(@inner_block) %>
      <% else %>
        <%= humanize(@field) %>
      <% end %>
    </label>
    """
  end

  defp class_label(), do: "block text-sm font-medium text-neutral-700"

  @doc """
  Generates a input tag.

  ## Examples

      <.text_input form={@form} field={:name} />

  """
  Enum.map(@generic_inputs, fn type ->
    def unquote(type)(assigns) do
      render_generic_input(unquote(type), assigns)
    end
  end)

  defp render_generic_input(type, assigns) do
    assigns =
      assigns
      |> attr(:form, :any, required: true)
      |> attr(:field, :any, required: true)
      |> attr(:class, :string)
      |> attr(:extra, :rest)
      |> attr_done()

    ~H"""
    <%= apply(Phoenix.HTML.Form, type, [
      @form,
      @field,
      [
        class:
          merge_class([
            class_default(type),
            class_form_error(@form, @field),
            @class
          ]),
        phx_feedback_for: input_name(@form, @field)
      ] ++ @extra
    ]) %>
    """
  end

  Enum.map(@select_inputs, fn type ->
    def unquote(type)(assigns) do
      render_select_input(unquote(type), assigns)
    end
  end)

  defp render_select_input(type, assigns) do
    assigns =
      assigns
      |> attr(:form, :any, required: true)
      |> attr(:field, :any, required: true)
      |> attr(:options, :any, required: true)
      |> attr(:class, :string)
      |> attr(:extra, :rest)
      |> attr_done()

    ~H"""
    <%= apply(Phoenix.HTML.Form, type, [
      @form,
      @field,
      @options,
      [
        class:
          merge_class([
            class_default(type),
            class_form_error(@form, @field),
            @class
          ]),
        phx_feedback_for: input_name(@form, @field)
      ] ++ @extra
    ]) %>
    """
  end

  @class_default one_line_class("""
                 px-3 py-2
                 text-base sm:text-sm
                 bg-white rounded-md shadow-sm border border-neutral-300
                 focus:outline-none focus:border-primary-400 focus:ring focus:ring-offset-0 focus:ring-primary-300 focus:ring-opacity-50
                 transition ease-in-out duration-150
                 phx-form-error:text-danger-900
                 phx-form-error:border-danger-400
                 phx-form-error:focus:border-danger-400 phx-form-error:focus:ring-danger-300 phx-form-error:focus:ring-opacity-50
                 """)

  defp class_form_error(form, field),
    do: if(has_error?(form, field), do: "phx-form-error", else: "")

  defp class_default(:color_input), do: merge_class([@class_default, "h-10"])

  defp class_default(:file_input),
    do:
      one_line_class("""
      text-sm text-neutral-500
      file:mr-4 file:px-4 file:py-2
      file:rounded-md file:border-0
      file:text-sm file:font-semibold
      file:bg-primary-50 file:text-primary-600
      hover:file:bg-primary-100
      focus:outline-none
      """)

  defp class_default(:range_input), do: ""

  defp class_default(:checkbox),
    do: merge_class([@class_default, "w-4 h-4 px-0 py-0 text-primary-600"])

  defp class_default(:select),
    do: merge_class([@class_default, "pr-9"])

  defp class_default(_), do: @class_default

  @doc """
  Generates tag for inlined form input errors.
  """
  def error(assigns) do
    assigns =
      assigns
      |> attr(:form, :any, required: true)
      |> attr(:field, :any, required: true)
      |> attr(:name, :string, default: input_name(assigns.form, assigns.field))
      |> attr(:class, :string)
      |> attr(:extra, :rest)
      |> attr_done()

    ~H"""
    <%= if has_error?(@form, @field) do %>
      <div
        class={merge_class(["phx-no-feedback:hidden", @class])}
        phx-feedback-for={input_name(@form, @field)}
        {@extra}
      >
        <%= for error <- extract_errors(@form, @field) do %>
          <span class="block text-xs text-danger-600">
            <%= translate_error(error) %>
          </span>
        <% end %>
      </div>
    <% end %>
    """
  end

  defp has_error?(form, field) do
    !(form.errors
      |> Keyword.get_values(field)
      |> Enum.empty?())
  end

  defp extract_errors(form, field) do
    Keyword.get_values(form.errors, field)
  end

  # Translates an error message.
  defp translate_error({msg, opts}) do
    # Because the error messages we show in our forms and APIs
    # are defined inside Ecto, we need to translate them dynamically.
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", fn _ -> to_string(value) end)
    end)
  end

  @doc """
  A combo of <.input_label>, <.input>, <.error>.
  """
  def form_field(assigns) do
    assigns =
      assigns
      |> attr(:type, :string, required: true)
      |> attr(:form, :any, required: true)
      |> attr(:field, :any, required: true)
      |> attr(:label, :string, default: humanize(assigns.field))
      |> attr(:options, :any)
      |> attr(:class, :string)
      |> attr(:extra, :rest)
      |> attr_done()

    ~H"""
    <div class={merge_class("space-y-2", @class)} {@extra}>
      <%= case @type do %>
        <% "text_input" -> %>
          <.input_label form={@form} field={@field}><%= @label %></.input_label>
          <.text_input form={@form} field={@field} class="block w-full" />
        <% "email_input" -> %>
          <.input_label form={@form} field={@field}><%= @label %></.input_label>
          <.email_input form={@form} field={@field} class="block w-full" />
        <% "number_input" -> %>
          <.input_label form={@form} field={@field}><%= @label %></.input_label>
          <.number_input form={@form} field={@field} class="block w-full" />
        <% "password_input" -> %>
          <.input_label form={@form} field={@field}><%= @label %></.input_label>
          <.password_input form={@form} field={@field} class="block w-full" />
        <% "url_input" -> %>
          <.input_label form={@form} field={@field}><%= @label %></.input_label>
          <.url_input form={@form} field={@field} class="block w-full" />
        <% "search_input" -> %>
          <.input_label form={@form} field={@field}><%= @label %></.input_label>
          <.search_input form={@form} field={@field} class="block w-full" />
        <% "telephone_input" -> %>
          <.input_label form={@form} field={@field}><%= @label %></.input_label>
          <.telephone_input form={@form} field={@field} class="block w-full" />
        <% "color_input" -> %>
          <.input_label form={@form} field={@field}><%= @label %></.input_label>
          <.color_input form={@form} field={@field} />
        <% "range_input" -> %>
          <.input_label form={@form} field={@field}><%= @label %></.input_label>
          <.range_input form={@form} field={@field} class="block w-full" />
        <% "time_input" -> %>
          <.input_label form={@form} field={@field}><%= @label %></.input_label>
          <.time_input form={@form} field={@field} class="block w-full" />
        <% "date_input" -> %>
          <.input_label form={@form} field={@field}><%= @label %></.input_label>
          <.date_input form={@form} field={@field} class="block w-full" />
        <% "datetime_local_input" -> %>
          <.input_label form={@form} field={@field}><%= @label %></.input_label>
          <.datetime_local_input form={@form} field={@field} class="block w-full" />
        <% "textarea" -> %>
          <.input_label form={@form} field={@field}><%= @label %></.input_label>
          <.textarea form={@form} field={@field} class="block w-full" />
        <% "checkbox" -> %>
          <.input_label form={@form} field={@field} class="flex items-center">
            <.checkbox form={@form} field={@field} />
            <span class="ml-2"><%= @label %></span>
          </.input_label>
        <% "select" -> %>
          <.input_label form={@form} field={@field}><%= @label %></.input_label>
          <.select form={@form} field={@field} options={@options} class="block w-full" />
        <% "multiple_select" -> %>
          <.input_label form={@form} field={@field}><%= @label %></.input_label>
          <.multiple_select form={@form} field={@field} options={@options} class="block w-full" />
      <% end %>

      <.error form={@form} field={@field} />
    </div>
    """
  end
end
