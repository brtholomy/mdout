-- WARN: bottomup AST traversal: this will run first
function Para(el)
  return pandoc.Div({el}, {['custom-style'] = "Body"})
end

function HorizontalRule(el)
    -- inject a space into a fresh Para object
    local empty_para = pandoc.Para({pandoc.Space()})
    return pandoc.Div({empty_para}, {['custom-style'] = "section_number_auto"})
end

function Code(el)
    -- NOTE: must be Span
    -- NOTE: We pass {el} as a list to keep the text intact.
    -- TODO: this should be default. modify VerbatimChar to be what we expect.
    return pandoc.Span({el}, {['custom-style'] = "VerbatimChar"})
end

function BulletList(el)
  for i, item in ipairs(el.content) do
    for j, block in ipairs(item) do

      -- If Para ran first, this block is now a Div.
      if block.t == "Div" and block.attributes['custom-style'] == "Body" then
        block.attributes['custom-style'] = "List long"

      -- fallback if it's still a raw Para or Plain
      elseif block.t == "Para" then
        item[j] = pandoc.Div({block}, {['custom-style'] = "List long"})
      elseif block.t == "Plain" then
        -- upgrade "tight" lists to paragraphs
        local upgraded_para = pandoc.Para(block.content)
        -- apply short style:
        item[j] = pandoc.Div({upgraded_para}, {['custom-style'] = "List short"})
      end
    end
  end
  return el
end

function OrderedList(el)
  for i, item in ipairs(el.content) do
    for j, block in ipairs(item) do
      if block.t == "Div" and block.attributes['custom-style'] == "Body" then
        block.attributes['custom-style'] = "List numbered"
      elseif block.t == "Para" then
        item[j] = pandoc.Div({block}, {['custom-style'] = "List numbered"})

      elseif block.t == "Plain" then
        -- Upgrade "tight" lists to paragraphs
        local upgraded_para = pandoc.Para(block.content)
        -- apply short style:
        item[j] = pandoc.Div({upgraded_para}, {['custom-style'] = "List numbered short"})
      end

    end
  end
  return el
end

-- function BlockQuote(el)
--   for i, block in ipairs(el.content) do
--     if block.t == "Div" and block.attributes['custom-style'] == "Body" then
--       block.attributes['custom-style'] = "Blockquote"
--     elseif block.t == "Para" then
--       el.content[i] = pandoc.Div({block}, {['custom-style'] = "Blockquote"})
--     end
--   end
--   return el
-- end

-- 4. Intercept Blockquotes and Citations (>> syntax)
function BlockQuote(el)

  -- Detect the double blockquote (>> author)
  -- If the outer blockquote contains exactly one element, and that element is ANOTHER blockquote...
  if #el.content == 1 and el.content[1].t == "BlockQuote" then
    local inner_quote = el.content[1]

    -- The inner quote was already processed bottom-up, so it currently has "Blockquote".
    -- We loop through it and overwrite it with your citation style.
    for i, block in ipairs(inner_quote.content) do
      if block.t == "Div" and block.attributes['custom-style'] == "Blockquote" then
        block.attributes['custom-style'] = "Blockquote source"
      end
    end

    -- Return the inner content directly. This strips away both layers of the Word
    -- blockquote structure and outputs a clean, cleanly styled paragraph for Publisher.
    return inner_quote.content
  end

  -- If it's just a normal single blockquote (> text), run the standard logic
  for i, block in ipairs(el.content) do

    if block.t == "Div" and block.attributes['custom-style'] == "Body" then
      block.attributes['custom-style'] = "Blockquote"
    elseif block.t == "Para" then
      el.content[i] = pandoc.Div({block}, {['custom-style'] = "Blockquote"})
    end

  end

  return el
end
