# frozen_string_literal: true

ActionView::Base.field_error_proc = lambda { |html_tag, instance|
  return html_tag if html_tag =~ /^<label/

  html = Nokogiri::HTML::DocumentFragment.parse(html_tag)
  html.children.add_class('input-errror, border-red-500')

  error_message_markup = <<~HTML
    <p class='text-red-800'>
      #{sanitize(instance.error_message.to_sentence)}
    </p>
  HTML

  "#{html}#{error_message_markup}".html_safe
}
