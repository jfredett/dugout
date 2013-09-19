class Concord < Module
  def initialize(*names)
    # Remove the restriction on number of arguments in concord
    @names = names
  end
end
