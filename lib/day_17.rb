# frozen_string_literal: true

Day17 = Struct.new(:computer)

class Day17
  EXAMPLE = <<~STRING
    Register A: 729
    Register B: 0
    Register C: 0

    Program: 0,1,5,4,3,0
  STRING

  EndOfProgramError = Class.new(StandardError)

  Computer = Struct.new(:register_a, :register_b, :register_c, :pointer, :program, :output) do
    def run!
      step! until halted?
    end

    def step!
      case literal!
      in 0 # adv
        numerator = register_a
        denominator = 2**combo!
        self.register_a = numerator / denominator
      in 1 # bxl
        self.register_b = (register_b ^ literal!) % 8
      in 2 # bst
        self.register_b = combo! % 8
      in 3 # jnz
        if register_a != 0
          self.pointer = literal!
        end
      in 4 # bxc
        literal!
        self.register_b ^= register_c
      in 5 # out
        output << combo! % 8
      in 6 # bdv
        numerator = register_a
        denominator = 2**combo!
        self.register_b = numerator / denominator
      in 7 # cdv
        numerator = register_a
        denominator = 2**combo!
        self.register_c = numerator / denominator
      else
        nil
      end
    rescue EndOfProgramError
    end

    def halted?
      pointer >= program.length
    end

    def combo!
      combo(literal!)
    end

    def literal!
      program[pointer].tap do |value|
        raise EndOfProgramError if value.nil?

        self.pointer += 1
      end
    end

    def combo(operand)
      case operand
      when 0, 1, 2, 3 then operand
      when 4 then register_a
      when 5 then register_b
      when 6 then register_c
      else
        raise "Invalid combo operand #{operand.inspect} at #{pointer}"
      end
    end
  end

  def self.parse(input)
    registers_str, program_str = input.split("\n\n")
    a, b, c = registers_str.lines.map { |line| line[/\d+/].to_i }
    program = program_str.scan(/\d+/).map(&:to_i)

    new(Computer.new(a, b, c, 0, program, []))
  end

  def part_1
    computer.run!
    computer.output.join(",")
  end

  def part_2
    (0..).each do |register_a|
      computer.register_a = register_a
      computer.output = []
      computer.pointer = 0
      computer.register_b = 0
      computer.register_c = 0
      computer.run!
      return register_a if computer.output == computer.program
    end
  end
end
