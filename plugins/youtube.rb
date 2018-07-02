module Jekyll
  class Youtube < Liquid::Tag
    def initialize(name, markup, tokens)
      super
      args = markup.strip.split
      raise "Usage: #{tag_name} id [width] [height]" unless args.length > 0

      @id = args[0]
      @width = args[1] ? args[1] : 640
      @height = args[2] ? args[2] : 390
    end

    def render(context)
      %(<iframe width="#{@width}" height="#{@height}" src="https://www.youtube.com/embed/#{@id}" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>)
    end
  end
end

Liquid::Template.register_tag('youtube', Jekyll::Youtube)
