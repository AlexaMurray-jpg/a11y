return {
    Div = function(elem)
      if  elem.classes:includes("det") then
        local result = pandoc.List({ pandoc.RawBlock('html', '<details class = "det">') })
        result:extend(elem.content)
        result:insert(pandoc.RawBlock('html', '</details>'))
        return result
      elseif  elem.classes:includes("small") then
        local result = pandoc.List({ pandoc.RawBlock('html', '<small>') })
        result:extend(elem.content)
        result:insert(pandoc.RawBlock('html', '</small>'))
        return result
      elseif  elem.classes:includes("figure") then
        local result = pandoc.List({ pandoc.RawBlock('html', '<figure>') })
        local content = pandoc.List()
          for _, block in ipairs(elem.content) do
              if block.t == "Para" then
                  content:insert(pandoc.Plain(block.content))
              else
                  content:insert(block)
              end
          end
        result:extend(elem.content)
        result:insert(pandoc.RawBlock('html', '</figure>'))
        return result
      elseif  elem.classes:includes("video") then
        local result = pandoc.List({ pandoc.RawBlock('html', '<video controls muted playsinline>') })
        result:extend(elem.content)
        result:insert(pandoc.RawBlock('html', '</video>'))
        return result
      elseif  elem.classes:includes("source") then
        local result = pandoc.List({ pandoc.RawBlock('html', '<source src = '..elem.attributes.src..' type=video/mp4 />') })
        return result
      elseif  elem.classes:includes("comment") then
        local result = pandoc.List({ pandoc.RawBlock('html', '<!--') })
        result:extend(elem.content)
        result:insert(pandoc.RawBlock('html', '-->'))
        return result
      else
        return elem
      end
    end,
    Para = function(elem)
      local text_1 = pandoc.utils.stringify(elem)
      text_1 = text_1:gsub('“', '"'):gsub('”', '"'):gsub('‘', "'"):gsub('’', "'")
      local pattern = '{{iframe:%s*src%s*=%s*"([^"]+)"%s*title%s*=%s*"([^"]+)"}}'
      local src, title = text_1:match(pattern)
      if #elem.content == 1 and elem.content[1].t == "Str" and elem.content[1].text == "{{hello_math_simple}}" then
        return pandoc.CodeBlock(io.open("html/simple.html", "r"):read("*a"), {class="html"})
      elseif src and title then
        local html = string.format(
          '<iframe src="%s" title="%s"></iframe>',
          src, title
          )
          return pandoc.RawBlock('html', html)
      else
        return elem
      end
    end,
    Span = function(elem)
      if elem.classes:includes("summ") then
        local result = pandoc.List({ pandoc.RawInline('html', '<summary>') })
        result:extend(elem.content)
        result:insert(pandoc.RawInline('html', '</summary>'))
        return result
      elseif elem.classes:includes("figcaption") then
        local result = pandoc.List({ pandoc.RawInline('html', '<figcaption class="figcaption" style="font-size:1.35rem;">') })
        result:extend(elem.content)
        result:insert(pandoc.RawInline('html', '</figcaption>'))
        return result
      else
        return elem
      end
    end,
    Str = function (elem)
        if elem.text == "{{construction}}" then
            return pandoc.Emph {pandoc.Str "This page is under construction."}
        elseif elem.text == "{{sconstruction}}" then
            return pandoc.Emph {pandoc.Str "This section is under construction."}
        else
            return elem
        end
    end,
}
