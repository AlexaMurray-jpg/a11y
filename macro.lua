return {
    Div = function(elem)
      if  elem.classes:includes("det") then
        local result = pandoc.List({ pandoc.RawBlock('html', '<details>') })
        result:extend(elem.content)
        result:insert(pandoc.RawBlock('html', '</details>'))
        return result
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