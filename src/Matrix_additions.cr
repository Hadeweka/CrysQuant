struct Matrix(T)
  def *(scalar : Complex | Number)
    Matrix.new(@rows, @columns) do |i|
      i * scalar
    end
  end

  def kronecker_product(other_matrix : Matrix)
    width = @rows
    height = @columns
    other_width = other_matrix.rows.size
    other_height = other_matrix.columns.size

    new_matrix = Matrix.new(width * other_width, height * other_height) do |index, i, j|
      first_part = self[i // other_width, j // other_height]
      second_part = other_matrix[i % other_width, j % other_height]
      first_part * second_part
    end

    new_matrix
  end

  def ⊗(other_matrix : Matrix)
    kronecker_product(other_matrix)
  end

  def ⊤
    self.transpose
  end
end