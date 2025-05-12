module Parser
  class Token
    attr_accessor :key, :type, :value, :indentation

    def initialize(key, type, value, indentation)
      @key = key
      @type = type
      @value = value
      @indentation = indentation
    end

    def to_s
      "<#{@key} type=#{@type} value=#{@value} indentation=#{@indentation}>"
    end
  end

  class Node
    attr_accessor :key, :type, :value, :children, :indentation

    def initialize(key, type, value, children, indentation)
      @key = key
      @type = type
      @value = value
      @children = children
      @indentation = indentation
    end

    def to_s
      "<#{@key} type=#{@type} value=#{@value} children=#{@children.map {|child| child.to_s}} indentation=#{@indentation}\n>"
    end
  end

  class Parser
    def initialize(input)
      @input = input
      @tokenized = []
      @output = []
    end

    def parse
      @tokenized = tokenize(@input)
      @output = tree_builder(@tokenized)

      @output
    end

    private
    def normalize_indentation(line)
      line.gsub("\t", ' ' * 2)
    end

    def tokenize(input)
      tokenized = []
      base_indent = nil
      input.each_line do |line|
        line = line.chomp
        next if line.empty?
        
        line = normalize_indentation(line)
        indentation = line[/\A */].size
        key = line.split(" ").first
        value = line.split(" ")[1..-1].join(" ")

        if key == '|'
          # handle multiline
          # all next line will be type text untill its indentation is lower or its empty
          base_indent = indentation
          tokenized << Token.new(nil, "text", value, indentation)
        elsif (base_indent != nil && base_indent <= indentation)
          # follow base indent and strip the indentation
          value = line.lstrip
          tokenized << Token.new(nil, "text", value, base_indent)
        else
          tokenized << Token.new(key, "tag", value, indentation)
        end
      end

      tokenized
    end

    # recursive function so it reach all elements
    def tree_builder(tokens, parent_indent=0)
      nodes = []

      while !tokens.empty?
        token = tokens.first

        if token.indentation < parent_indent
          break
        elsif token.indentation > parent_indent
          # child of the last node
          last = nodes.last
          last.children += tree_builder(tokens, token.indentation)
        else
          # same level
          token = tokens.shift
          nodes << Node.new(token.key, token.type, token.value, [], token.indentation)
        end
      end

      nodes
    end
  end
end

class Compiler
  def self.compile(node)
    html = ''
    node.each do |element|
      indents = " " * element.indentation
      html << "\n"
      html << indents
      html << "<#{element.key}>" if element.type == "tag"
      html << element.value

      if element.children.any?
        html << indents + self.compile(element.children)
        html << "\n"
        html << indents + "</#{element.key}>"
      else
        html << "</#{element.key}>" if element.type == "tag"
      end
    end
    
   html
  end
end

text_input = File.read('./html.txt')
puts text_input.inspect
parser = Parser::Parser.new(text_input)
parsed_text = parser.parse

puts parsed_text

compiled_text = Compiler.compile(parsed_text)
puts compiled_text

