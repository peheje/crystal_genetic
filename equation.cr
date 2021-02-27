class Operation
  def initialize(@sign : String, @unary : Bool, @eval : Proc(Node, Node, Float64))
  end
end

class Node
  @left : Node?
  @right : Node?

  def initialize(@operation : Operation, @value : Float64 = 0.0)
  end
end

def random_node(operations : Array(Operation), leaf : Boolean)
  if leaf
    Node.new operations[0], rand(-10.0..10.0)
  else
    Node.new operations[rand(1..operations.size - 1)]
  end
end

operations = Array(Operation).new

#n = random_node()