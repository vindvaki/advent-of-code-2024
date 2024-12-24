# frozen_string_literal: true

require "matrix"

Day23 = Data.define(:edges)

class Day23
  EXAMPLE = <<~STRING
    kh-tc
    qp-kh
    de-cg
    ka-co
    yn-aq
    qp-ub
    cg-tb
    vc-aq
    tb-ka
    wh-tc
    yn-cg
    kh-ub
    ta-co
    de-co
    tc-td
    tb-wq
    wh-td
    ta-ka
    td-qp
    aq-cg
    wq-ub
    ub-vc
    de-ta
    wq-aq
    wq-vc
    wh-yn
    ka-de
    kh-ta
    co-tc
    wh-qp
    tb-vc
    td-yn
  STRING

  def self.parse(input)
    edges = {}

    input.each_line do |line|
      u, v = line.strip.split("-")
      edges[u] ||= Set[]
      edges[u] << v
      edges[v] ||= Set[]
      edges[v] << u
    end

    new(edges:)
  end

  def part_1
    sets = Set[]
    edges.keys.lazy.grep(/^t/).each do |u|
      edges[u].to_a.combination(2).each do |v, w|
        if edges[v].include?(w)
          sets << [u, v, w].sort
        end
      end
    end
    sets.size
  end

  def part_2
    vertices = edges.keys.sort
    n = vertices.length
    max_cliques = []
    stack = (0...n).map { |i| [i] }

    until stack.empty?
      clique = stack.pop
      i = clique.last
      ((i + 1)...n).each do |j|
        u = vertices[j]
        if clique.all? { |k| edges[u].include?(vertices[k]) }
          stack << clique + [j]
        else
          max_cliques << clique.map { |k| vertices[k] }
        end
      end
    end

    max_cliques.max_by(&:size).join(",")
  end
end
