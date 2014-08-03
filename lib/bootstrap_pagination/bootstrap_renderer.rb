require "bootstrap_pagination/version"

module BootstrapPagination
  # Contains functionality shared by all renderer classes.
  module BootstrapRenderer
    ELLIPSIS = '&hellip;'

    def to_html
      list_items = pagination.map do |item|
        case item
          when Fixnum
            page_number(item)
          else
            send(item)
        end
      end

      html_container(tag('ul', list_items.join(@options[:link_separator])))
    end

    protected

    def page_number(page)
      if page == current_page
        tag('li', link(page, page), :class => 'active')
      else
        tag('li', link(page, page, :rel => rel_value(page)))
      end
    end

    def gap
      tag('li', link(ELLIPSIS, '#'), :class => 'disabled')
    end

    def previous_page
      num = @collection.current_page > 1 && @collection.current_page - 1
      previous_or_next_page(num, @options[:previous_label], 'prev')
    end

    def next_page
      num = @collection.current_page < @collection.total_pages && @collection.current_page + 1
      previous_or_next_page(num, @options[:next_label], 'next')
    end

    def previous_or_next_page(page, text, classname)
      if page
        tag('li', link(text, page), :class => classname)
      else
        tag('li', link(text, '#'), :class => "%s disabled" % classname)
      end
    end

    def url(page)
      @base_url_params ||= begin
        url_params = merge_get_params(default_url_params)
        merge_optional_params(url_params)
      end

      url_params = @base_url_params.dup
      add_current_page_param(url_params, page)

      # Remove param for page 1 to avoid SEO duplicated content
      url_params.except!(:page) if url_params[:page] == 1
      
      @template.url_for(url_params)
    end
  end
end