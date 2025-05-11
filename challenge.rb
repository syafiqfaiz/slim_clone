# we want to read a file(txt) and parse it into html

# the expected format insidet the file is
# table
#   thead
#     tr
#       td Heading 1
#       td Heading 2
#   tbody
#     tr 
#       td Body 1
#       td Body 2


# the plan?
# read the file
# line by line
# parse it into a hash
# and then compile it into html

# limitations
# 1. the file is well formatted, always indented with 2 spaces
# 2. only text, no logic/variables
# 3. no multiline text
# 4. no html attributes


# the parser
# read line by line and parse it into a hash
# the hash will be a nested hash

# input
# table
#   thead
#     tr
#       td Heading 1
#       td Heading 2
#   tbody
#     tr 
#       td Body 1
#       td Body 2

# output
# {key: "table", type:"tag", value: [
#   {key: "thead", type:"tag", value: [
#     {key: "tr", type:"tag", value: [
#       {key: "td", type:"tag", value:[
#         {type: "text", value: "Heading 1"}
#       ]},
#       {key: "td", value:[
#         {type: "text", value: "Heading 2"}
#       ]},
#     ]},
#   ]},
#   {key: "tbody", type:"tag", value: [
#     {key: "tr", type:"tag", value: [
#       {key: "td", type:"tag", value:[
#         {type: "text", value: "Body 1"}
#       ]},
#       {key: "td", type:"tag", value:[
#         {type: "text", value: "Body 2"}
#       ]},
#     ]},
#   ]},
# ]}
  


# compiler
# the compiler will take the hash and compile it into html
# the compiler will be a recursive function

# require 'byebug'

input = <<~EOF
  table
    thead
      tr
        td Heading 1
        td Heading 2
    tbody
      tr 
        td Body 1
        td Body 2
  EOF

class Parser
  def initialize(input)
    @input = input
    @tokenized = []
    @output = []
  end

  def parse
    @input.each_line do |line|
      line = line.chomp
      next if line.empty?
    
      token = tokenize(line)
      @tokenized << token
    end

    @output = tree_builder(@tokenized)

    @output
  end

  private
  def tokenize(line)
    indentation = line[/\A */].size
    key = line.split(" ").first
    value = line.split(" ")[1..-1].join(" ")
    
    { key: key, type: "tag", value: value, indentation: indentation }
  end

  # recursive function so it reach all elements
  def tree_builder(tokens, parent_indent=0)
    nodes = []

    while !tokens.empty?
      token = tokens.first

      if token[:indentation] < parent_indent
        break
      elsif token[:indentation] > parent_indent
        # child of the last node
        last = nodes.last
        
        last[:children] += tree_builder(tokens, token[:indentation])
      else
        # same level
        token = tokens.shift
        nodes << {key: token[:key], type: token[:type], value: token[:value], children: [], indentation: token[:indentation]}
      end
    end

    nodes
  end
end

class Compiler
  def self.compile(node)
    html = ''
    node.each do |element|
      indents = " " * element[:indentation]
      html << "\n"
      html << indents + "<#{element[:key]}>"
      html << element[:value]
      if element[:children].any?
        html << indents + self.compile(element[:children])
        html << "\n"
        html << indents + "</#{element[:key]}>"
      else
        html << "</#{element[:key]}>"
      end
    end
    
   html
  end
end


parser = Parser.new(input)
parsed_text = parser.parse
# puts parsed_text


compiled_text = Compiler.compile(parsed_text)
puts compiled_text

