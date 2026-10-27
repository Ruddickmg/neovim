local function display()

end

local function select()
  vim.ui.select({ 'Option A', 'Option B', 'Option C' }, {
      prompt = 'Select an action:',
  }, function(choice)
      if choice then
          print("You chose: " .. choice)
      end
  end)
end

return {
  select = select
}
