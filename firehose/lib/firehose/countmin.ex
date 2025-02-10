defmodule Firehose.CountMin do
  alias Firehose.CountMin

  defstruct count: nil, top: []

  # better results with higher values of this
  @h 3
  @k 127
  @t 5

  def new do
    %Firehose.CountMin{
      count: make_matrix(@h, @k),
      top: []
    }
  end

  def add(%CountMin{count: count} = cm, word) do
    h1 = hash1(word)
    h2 = hash2(word)
    h3 = hash3(word)
    count = setm(count, 0, h1, getm(count, 0, h1) + 1)
    count = setm(count, 1, h2, getm(count, 1, h2) + 1)
    count = setm(count, 2, h3, getm(count, 2, h3) + 1)

    cm = %CountMin{cm | count: count}
    update_top(cm, word)
  end

  def get(%CountMin{count: count}, word) do
    h1 = hash1(word)
    h2 = hash2(word)
    h3 = hash3(word)
    a = getm(count, 0, h1)
    b = getm(count, 1, h2)
    c = getm(count, 2, h3)
    Enum.min([a, b, c])
  end

  defp update_top(%CountMin{top: top} = cm, word) do
    c = get(cm, word)

    top =
      if List.keymember?(top, word, 0) do
        List.keyreplace(top, word, 0, {word, c})
      else
        [{word, c} | top]
      end

    top = List.keysort(top, 1) |> Enum.reverse() |> Enum.take(@t)
    %CountMin{cm | top: top}
  end

  defp hash1(word) do
    # Bersntein
    hash(word, 5381, 33, @k)
  end

  defp hash2(word) do
    hash(word, 0, 5, @k)
  end

  defp hash3(word) do
    hash(word, 0, 31, @k)
  end

  defp hash(word, init_val, a, p) do
    String.to_charlist(word)
    |> Enum.reduce(init_val, fn c, h ->
      rem(h * a + c, p)
    end)
  end

  defp make_matrix(rows, cols) do
    Tuple.duplicate(0, cols) |> Tuple.duplicate(rows)
  end

  defp setm(matrix, row, col, value) do
    new_row = elem(matrix, row) |> put_elem(col, value)
    matrix |> put_elem(row, new_row)
  end

  defp getm(matrix, row, col) do
    matrix |> elem(row) |> elem(col)
  end
end
