# frozen_string_literal: true

class Graph
  DistanceVertex = Data.define(:distance, :vertex) do
    def <=>(other)
      key <=> other.key
    end

    def key
      [distance, vertex]
    end
  end

  Edge = Data.define(:source, :target, :weight)

  def initialize(&block)
    @edges_out_proc = block
  end

  def edges_out(vertex)
    @edges_out_proc.call(vertex)
  end

  def shortest_paths(source:)
    distances = Hash.new(Float::INFINITY)
    distances[source] = 0
    prev = {}
    queue = SortedSet[DistanceVertex.new(distance: 0, vertex: source)]

    until queue.empty?
      head = queue.first
      queue.delete(head)
      vertex = head.vertex

      break if block_given? && yield(head.distance, vertex)

      edges_out(head.vertex).each do |edge|
        neighbor = edge.target
        neighbor_distance = head.distance + edge.weight

        case neighbor_distance <=> distances[neighbor]
        when -1
          prev[neighbor] = Set[vertex]
          distances[neighbor] = neighbor_distance
          queue << DistanceVertex.new(
            distance: neighbor_distance,
            vertex: neighbor
          )
        when 0
          prev[neighbor] << vertex
        end
      end
    end

    [distances, prev]
  end
end
