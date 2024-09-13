function change(amount)
  if math.type(amount) ~= "integer" then
    error("Amount must be an integer")
  end
  if amount < 0 then
    error("Amount cannot be negative")
  end
  local counts, remaining = {}, amount
  for _, denomination in ipairs({25, 10, 5, 1}) do
    counts[denomination] = remaining // denomination
    remaining = remaining % denomination
  end
  return counts
end

-- Write your first then lower case function here
function first_then_lower_case(sequence, predicate)
  for _, value in ipairs(sequence) do
    if predicate(value) then
      return string.lower(value)
    end
  end
  return nil
end

-- Write your powers generator here
function powers_generator(base, limit)
  return coroutine.create(function()
    local power = 1
    while power <= limit do
      coroutine.yield(power)
      power = power * base
    end
  end)
end

-- Write your say function here
function say(word)
  local words = {}

  local function chain(nextWord)
    if nextWord == nil then
      return table.concat(words, ' ')
    else
      table.insert(words, nextWord)
      return chain
    end
  end

  if word ~= nil then
    return chain(word)
  end

  return chain(nil)
end


-- Write your line count function here
function meaningful_line_count(filename)
  local count = 0
  local file, err = io.open(filename, "r")
  
  if not file then
    error("No such file")
  end
  
  local status, read_error = pcall(function()
    for line in file:lines() do
      local trimmed_line = line:match("^%s*(.-)%s*$")
      if trimmed_line and #trimmed_line > 0 and not trimmed_line:find("^#") then
        count = count + 1
      end
    end
  end)

  file:close()
  
  if not status then
    error(read_error)
  end
  
  return count
end

-- Write your Quaternion table here

Quaternion = {}
Quaternion.__index = Quaternion

function Quaternion.new(a, b, c, d)
  local self = setmetatable({}, Quaternion)
  self.a = a
  self.b = b
  self.c = c
  self.d = d
  return self
end

function Quaternion.__add(q1, q2)
  return Quaternion.new(
    q1.a + q2.a,
    q1.b + q2.b,
    q1.c + q2.c,
    q1.d + q2.d
  )
end

function Quaternion.__mul(q1, q2)
  return Quaternion.new(
    q1.a * q2.a - q1.b * q2.b - q1.c * q2.c - q1.d * q2.d,
    q1.a * q2.b + q1.b * q2.a + q1.c * q2.d - q1.d * q2.c,
    q1.a * q2.c - q1.b * q2.d + q1.c * q2.a + q1.d * q2.b,
    q1.a * q2.d + q1.b * q2.c - q1.c * q2.b + q1.d * q2.a
  )
end

function Quaternion.__eq(q1, q2)
  return q1.a == q2.a and q1.b == q2.b and q1.c == q2.c and q1.d == q2.d
end

function Quaternion:conjugate()
  return Quaternion.new(self.a, -self.b, -self.c, -self.d)
end

function Quaternion:coefficients()
  return {self.a, self.b, self.c, self.d}
end

--Couldnt figure out how to get this method to work correctly
function Quaternion:tostring()
  local terms = {}

  if self.a ~= 0 or (#terms == 0) then
    table.insert(terms, string.format("%g", self.a))
  end

  if self.b ~= 0 then
    if self.b > 0 and #terms > 0 then
      table.insert(terms, string.format("+%gi", self.b))
    else
      table.insert(terms, string.format("%gi", self.b))
    end
  end

  if self.c ~= 0 then
    if self.c > 0 and #terms > 0 then
      table.insert(terms, string.format("+%gj", self.c))
    else
      table.insert(terms, string.format("%gj", self.c))
    end
  end

  if self.d ~= 0 then
    if self.d > 0 and #terms > 0 then
      table.insert(terms, string.format("+%gk", self.d))
    else
      table.insert(terms, string.format("%gk", self.d))
    end
  end

  if #terms == 0 then
    return "0"
  end

  return table.concat(terms)
end

