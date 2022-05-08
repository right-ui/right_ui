defmodule RightUI.Element.Link do
  use RightUI, :component

  defmacro __using__(_) do
    quote do
      import RightUI.Element.Link, only: [link: 1, external_link: 1]
    end
  end

  def link(assigns) do
    assigns =
      assigns
      |> attr(:type, :enum, values: ["a", "live_patch", "live_redirect"], default: "a")
      |> attr(:to, :string, required: true)
      |> attr(:class, :string)
      |> attr(:inner_block, :slot, required: true)
      |> attr(:extra, :rest)
      |> attr_done()

    ~H"""
    <%= apply(link_function(@type), [
      [to: @to, class: @class] ++ @extra,
      [do: render_slot(@inner_block)]
    ]) %>
    """
  end

  @doc """
  Generates a `<a target="_blank">` element with vulnerability care.

  Setting `target="_blank"` on <a> elements implies `rel="noopener"` behaviour in
  modern Web browser. But, for browser compatibility, I prefer adding `rel="noopener"`
  by default.

  There're other available `rel` property values, such as:

  + `noreferrer` - don't send referrer information when navigating to another page.
  + `nofollow` - indicates that the linked page is not endorsed by you. It may be
    used by some search engines that use popularity ranking techniques.

  Get more details by reading:

  + [Open link in new tab or window](https://stackoverflow.com/a/15551842)
  + [Prevent Reverse Tabnabbing Attacks With Proper noopener, noreferrer, and nofollow Attribution](https://web.archive.org/web/20201225051333/https://blog.bhanuteja.dev/noopener-noreferrer-and-nofollow-when-to-use-them-how-can-these-prevent-phishing-attacks?guid=none&deviceId=4b2457f9-8062-46ca-a224-b24488072b1c)

  """
  def external_link(assigns) do
    assigns =
      assigns
      |> attr(:to, :string, required: true)
      |> attr(:rel, :string, default: "")
      |> attr(:class, :string)
      |> attr(:inner_block, :slot, required: true)
      |> attr(:extra, :rest)
      |> attr_done()

    ~H"""
    <%= apply(link_function("a"), [
      [target: "_blank", to: @to, rel: ~m(noopener #{@rel}), class: @class] ++ @extra,
      [do: render_slot(@inner_block)]
    ]) %>
    """
  end

  defp link_function("a"), do: &Phoenix.HTML.Link.link/2
  defp link_function("live_patch"), do: &live_patch/2
  defp link_function("live_redirect"), do: &live_redirect/2
end
