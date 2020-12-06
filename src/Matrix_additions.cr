struct Matrix(T)
  def *(scalar : Complex)
    Matrix.new(@rows, @columns) do |element|
      self[element] * scalar
    end
  end

  def kronecker_product(other_matrix : Matrix)
    width = @columns
    height = @rows
    other_width = other_matrix.columns.size
    other_height = other_matrix.rows.size

    new_matrix = Matrix.new(rows: height * other_height, columns: width * other_width) do |index, i, j|
      first_part = self[row: i // other_height, column: j // other_width]
      second_part = other_matrix[row: i % other_height, column: j % other_width]
      first_part * second_part
    end

    new_matrix
  end

  def direct_sum(other_matrix : Matrix)
    width = @columns
    height = @rows
    other_width = other_matrix.columns.size
    other_height = other_matrix.rows.size

    new_matrix = Matrix.new(rows: height + other_height, columns: width + other_width) do |index, i, j|
      if i < width && j < height
        self[row: j, column: i]
      elsif i >= width && j >= height
        other_matrix[row: j - height, column: i - width]
      else
        T.new(0)
      end
    end

    new_matrix
  end

  def append(other_matrix : Matrix)
    width = @columns
    height = @rows
    other_width = other_matrix.columns.size
    other_height = other_matrix.rows.size

    if width != other_width
      raise("Widths #{width} and #{other_width} are conflicting.")
    end

    new_matrix = Matrix.new(height + other_height, width) do |index, i, j|
      if i < height
        self[row: i, column: j]
      else
        other_matrix[row: i - height, column: j]
      end
    end
  end

  def ⊗(other_matrix : Matrix)
    kronecker_product(other_matrix)
  end

  def ⊕(other_matrix : Matrix)
    direct_sum(other_matrix)
  end

  def ⊤
    self.transpose
  end
end